/// **Architecture Layer**: Presentation (ViewModel)
/// **Purpose**: Manages state and presentation logic for Inventory Screen.
/// Clean ViewModel adhering to Single Responsibility Principle.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reestoko/core/network/models/inventory_item_dto.dart';
import 'package:reestoko/features/inventory/data/repositories/inventory_repository.dart';

class InventoryViewModel extends ChangeNotifier {
  final InventoryRepository _repository;
  StreamSubscription<List<InventoryItemDto>>? _inventorySubscription;

  List<InventoryItemDto> _items = [];
  List<InventoryItemDto> get items => _items;

  String _selectedZoneId = 'ALL';
  String get selectedZoneId => _selectedZoneId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  InventoryViewModel({InventoryRepository? repository})
      : _repository = repository ?? InventoryRepositoryImpl();

  /// Initialize inventory stream for household
  void initialize(String householdId) {
    _isLoading = true;
    notifyListeners();

    _inventorySubscription?.cancel();
    _inventorySubscription = _repository.streamInventoryItems(householdId).listen(
      (data) {
        _items = data;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _errorMessage = 'Failed to load inventory: $error';
        notifyListeners();
      },
    );
  }

  /// Filter items by selected zone
  List<InventoryItemDto> get filteredItems {
    if (_selectedZoneId == 'ALL') return _items;
    return _items.where((item) => item.zoneId == _selectedZoneId).toList();
  }

  void selectZone(String zoneId) {
    _selectedZoneId = zoneId;
    notifyListeners();
  }

  Future<void> updateQuantity(String householdId, String itemId, int newQuantity) async {
    if (newQuantity < 0) return;
    await _repository.updateItemQuantity(householdId, itemId, newQuantity);
  }

  Future<void> addItem(String householdId, InventoryItemDto item) async {
    await _repository.addInventoryItem(householdId, item);
  }

  Future<void> updateItem(String householdId, InventoryItemDto item) async {
    await _repository.addInventoryItem(householdId, item);
  }

  Future<void> deleteItem(String householdId, String itemId) async {
    await _repository.deleteInventoryItem(householdId, itemId);
  }

  @override
  void dispose() {
    _inventorySubscription?.cancel();
    super.dispose();
  }
}
