/// **Architecture Layer**: Presentation (ViewModel)
/// **Purpose**: Manages state and presentation logic for Shopping Screen.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reestoko/core/network/models/shopping_item_dto.dart';
import 'package:reestoko/features/shopping/data/repositories/shopping_repository.dart';

class ShoppingViewModel extends ChangeNotifier {
  final ShoppingRepository _repository;
  StreamSubscription<List<ShoppingItemDto>>? _subscription;

  List<ShoppingItemDto> _items = [];
  List<ShoppingItemDto> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ShoppingViewModel({ShoppingRepository? repository})
      : _repository = repository ?? ShoppingRepositoryImpl();

  void initialize(String householdId) {
    _isLoading = true;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _repository.streamShoppingList(householdId).listen((data) {
      _items = data;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> toggleItemPurchased(String householdId, String itemId, bool isPurchased) async {
    await _repository.toggleItemPurchased(householdId, itemId, isPurchased);
  }

  Future<void> purchaseAllChecked(String householdId) async {
    final checked = _items.where((i) => i.isPurchased).toList();
    if (checked.isEmpty) return;
    await _repository.purchaseAndRestock(householdId, checked);
  }

  Future<void> addItem(String householdId, ShoppingItemDto item) async {
    await _repository.addShoppingItem(householdId, item);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
