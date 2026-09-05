/// **Architecture Layer**: Data / Repository
/// **Purpose**: Repository interface and implementation for Shopping List operations.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reestoko/core/network/models/shopping_item_dto.dart';
import 'package:reestoko/core/utils/app_logger.dart';

abstract class ShoppingRepository {
  Stream<List<ShoppingItemDto>> streamShoppingList(String householdId);
  Future<void> addShoppingItem(String householdId, ShoppingItemDto item);
  Future<void> toggleItemPurchased(String householdId, String itemId, bool isPurchased);
  Future<void> purchaseAndRestock(String householdId, List<ShoppingItemDto> purchasedItems);
}

class ShoppingRepositoryImpl implements ShoppingRepository {
  final FirebaseFirestore _firestore;

  ShoppingRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<ShoppingItemDto>> streamShoppingList(String householdId) {
    AppLogger.d('Listening to Firestore shopping list stream for household: $householdId');
    return _firestore
        .collection('households')
        .doc(householdId)
        .collection('shopping_list')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ShoppingItemDto.fromJson(data);
      }).toList();
    });
  }

  @override
  Future<void> addShoppingItem(String householdId, ShoppingItemDto item) async {
    try {
      final docRef = _firestore
          .collection('households')
          .doc(householdId)
          .collection('shopping_list')
          .doc(item.id.isNotEmpty ? item.id : null);

      final itemData = item.toJson();
      itemData['id'] = docRef.id;
      itemData['createdAt'] = FieldValue.serverTimestamp();

      await docRef.set(itemData);
      AppLogger.i('Added shopping item: ${item.name}');
    } catch (e) {
      AppLogger.e('Error adding shopping item: $e');
      rethrow;
    }
  }

  @override
  Future<void> toggleItemPurchased(String householdId, String itemId, bool isPurchased) async {
    try {
      await _firestore
          .collection('households')
          .doc(householdId)
          .collection('shopping_list')
          .doc(itemId)
          .update({'isPurchased': isPurchased});
    } catch (e) {
      AppLogger.e('Error toggling shopping item purchased state: $e');
      rethrow;
    }
  }

  @override
  Future<void> purchaseAndRestock(String householdId, List<ShoppingItemDto> purchasedItems) async {
    final batch = _firestore.batch();

    for (final item in purchasedItems) {
      // 1. Delete or mark completed from shopping list
      final shopDocRef = _firestore
          .collection('households')
          .doc(householdId)
          .collection('shopping_list')
          .doc(item.id);
      batch.delete(shopDocRef);

      // 2. Increment inventory stock if linked to inventory item
      if (item.inventoryItemId != null && item.inventoryItemId!.isNotEmpty) {
        final invDocRef = _firestore
            .collection('households')
            .doc(householdId)
            .collection('items')
            .doc(item.inventoryItemId);

        batch.update(invDocRef, {
          'quantity': FieldValue.increment(item.quantityToBuy),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }

    await batch.commit();
    AppLogger.i('Batch purchased and restocked ${purchasedItems.length} items.');
  }
}
