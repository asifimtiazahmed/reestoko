/// **Architecture Layer**: Presentation (Page)
/// **Purpose**: Full Inventory Management Screen with Zone Filters, Search, Stock Status, and FAB Add Modal.

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reestoko/core/network/models/inventory_item_dto.dart';
import 'package:reestoko/features/inventory/presentation/viewmodels/inventory_view_model.dart';
import 'package:reestoko/features/inventory/presentation/widgets/add_edit_item_modal.dart';
import 'package:reestoko/features/inventory/presentation/widgets/inventory_widgets.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<InventoryViewModel>().initialize('house_123');
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddEditModal(BuildContext context, {InventoryItemDto? item}) {
    final vm = context.read<InventoryViewModel>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => AddEditItemModal(
        initialItem: item,
        onSave: (newItem) {
          if (item == null) {
            vm.addItem('house_123', newItem);
          } else {
            vm.updateItem('house_123', newItem);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Inventory', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(FluentIcons.add_24_filled, color: Colors.green),
            onPressed: () => _openAddEditModal(context),
          ),
        ],
      ),
      body: Consumer<InventoryViewModel>(
        builder: (context, viewModel, child) {
          final items = viewModel.filteredItems.where((item) {
            if (_searchQuery.isEmpty) return true;
            return item.name.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search inventory...',
                    prefixIcon: const Icon(FluentIcons.search_24_regular),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Zone Filter Chips
              ZoneFilterChips(
                selectedZoneId: viewModel.selectedZoneId,
                onZoneSelected: (zoneId) => viewModel.selectZone(zoneId),
              ),

              // Items Count Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${items.length} Items Found',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              // Inventory List View
              Expanded(
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : items.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(FluentIcons.box_24_regular, size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 12),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? 'No items matching "$_searchQuery"'
                                      : 'No items in this zone yet.',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return InventoryItemCard(
                                item: item,
                                onIncrement: () =>
                                    viewModel.updateQuantity('house_123', item.id, item.quantity + 1),
                                onDecrement: () =>
                                    viewModel.updateQuantity('house_123', item.id, item.quantity - 1),
                                onTap: () => _openAddEditModal(context, item: item),
                                onDelete: () => viewModel.deleteItem('house_123', item.id),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddEditModal(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
