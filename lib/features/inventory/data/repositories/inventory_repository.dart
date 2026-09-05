/// **Architecture Layer**: Data / Repository
/// **Purpose**: Repository interface and implementation for Inventory management.
/// Prevents God Classes and direct API/Firestore leaks into ViewModels.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reestoko/core/network/models/inventory_item_dto.dart';
import 'package:reestoko/core/utils/app_logger.dart';

abstract class InventoryRepository {
  Stream<List<InventoryItemDto>> streamInventoryItems(String householdId);
  Future<void> addInventoryItem(String householdId, InventoryItemDto item);
  Future<void> updateItemQuantity(String householdId, String itemId, int newQuantity);
  Future<void> deleteInventoryItem(String householdId, String itemId);
}

class InventoryRepositoryImpl implements InventoryRepository {
  final FirebaseFirestore _firestore;

  InventoryRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<InventoryItemDto>> streamInventoryItems(String householdId) {
    AppLogger.d('Listening to Firestore inventory stream for household: $householdId');
    return _firestore
        .collection('households')
        .doc(householdId)
        .collection('items')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return InventoryItemDto.fromJson(data);
      }).toList();
    });
  }

  @override
  Future<void> addInventoryItem(String householdId, InventoryItemDto item) async {
    try {
      final docRef = _firestore
          .collection('households')
          .doc(householdId)
          .collection('items')
          .doc(item.id.isNotEmpty ? item.id : null);

      final itemData = item.toJson();
      itemData['id'] = docRef.id;
      itemData['createdAt'] = FieldValue.serverTimestamp();
      itemData['updatedAt'] = FieldValue.serverTimestamp();

      await docRef.set(itemData);
      AppLogger.i('Added inventory item: ${item.name} ($docRef.id)');
    } catch (e) {
      AppLogger.e('Error adding inventory item: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateItemQuantity(String householdId, String itemId, int newQuantity) async {
    try {
      final docRef = _firestore
          .collection('households')
          .doc(householdId)
          .collection('items')
          .doc(itemId);

      await docRef.update({
        'quantity': newQuantity,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      AppLogger.i('Updated item quantity for $itemId to $newQuantity');
    } catch (e) {
      AppLogger.e('Error updating item quantity: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteInventoryItem(String householdId, String itemId) async {
    try {
      await _firestore
          .collection('households')
          .doc(householdId)
          .collection('items')
          .doc(itemId)
          .delete();
      AppLogger.i('Deleted inventory item: $itemId');
    } catch (e) {
      AppLogger.e('Error deleting inventory item: $e');
      rethrow;
    }
  }
}
