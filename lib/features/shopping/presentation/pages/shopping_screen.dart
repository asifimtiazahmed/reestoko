/// **Architecture Layer**: Presentation (Page)
/// **Purpose**: Full Smart Shopping List Screen with check-off and batch restock.

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reestoko/features/shopping/presentation/viewmodels/shopping_view_model.dart';
import 'package:reestoko/features/shopping/presentation/widgets/shopping_widgets.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ShoppingViewModel>().initialize('house_123');
      }
    });
  }

  void _openAddDialog(BuildContext context) {
    final vm = context.read<ShoppingViewModel>();
    showDialog(
      context: context,
      builder: (dialogContext) => AddShoppingItemDialog(
        onAdd: (newItem) {
          vm.addItem('house_123', newItem);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Shopping List', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(FluentIcons.add_24_filled, color: Colors.green),
            onPressed: () => _openAddDialog(context),
          ),
        ],
      ),
      body: Consumer<ShoppingViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final unpurchased = viewModel.items.where((i) => !i.isPurchased).toList();
          final purchased = viewModel.items.where((i) => i.isPurchased).toList();

          return Column(
            children: [
              // Header Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${unpurchased.length} Items to Buy',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${purchased.length} items checked off',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                    if (purchased.isNotEmpty)
                      ElevatedButton.icon(
                        onPressed: () => viewModel.purchaseAllChecked('house_123'),
                        icon: const Icon(FluentIcons.checkmark_circle_24_filled, size: 18, color: Colors.white),
                        label: const Text('Restock Checked', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                  ],
                ),
              ),

              // Shopping List
              Expanded(
                child: viewModel.items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(FluentIcons.cart_24_regular, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 12),
                            Text(
                              'Your shopping list is empty!',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        children: [
                          if (unpurchased.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              child: Text('TO BUY', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                            ),
                            ...unpurchased.map((item) => ShoppingItemCard(
                                  item: item,
                                  onTogglePurchased: (val) =>
                                      viewModel.toggleItemPurchased('house_123', item.id, val),
                                )),
                          ],
                          if (purchased.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              child: Text('COMPLETED', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                            ),
                            ...purchased.map((item) => ShoppingItemCard(
                                  item: item,
                                  onTogglePurchased: (val) =>
                                      viewModel.toggleItemPurchased('house_123', item.id, val),
                                )),
                          ],
                        ],
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddDialog(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
