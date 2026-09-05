/// **Architecture Layer**: Presentation (Widgets)
/// **Purpose**: Reusable widgets for the Inventory Screen (Item Card, Zone Filter Chips).

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reestoko/core/network/models/inventory_item_dto.dart';

class ZoneFilterChips extends StatelessWidget {
  final String selectedZoneId;
  final Function(String) onZoneSelected;

  const ZoneFilterChips({
    super.key,
    required this.selectedZoneId,
    required this.onZoneSelected,
  });

  @override
  Widget build(BuildContext context) {
    final zones = [
      {'id': 'ALL', 'label': 'All Items'},
      {'id': 'zone_fridge', 'label': 'Fridge'},
      {'id': 'zone_pantry', 'label': 'Pantry'},
      {'id': 'zone_freezer', 'label': 'Freezer'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: zones.map((z) {
          final isSelected = selectedZoneId == z['id'];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(z['label']!),
              selected: isSelected,
              selectedColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (_) => onZoneSelected(z['id']!),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class InventoryItemCard extends StatelessWidget {
  final InventoryItemDto item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const InventoryItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onTap,
    required this.onDelete,
  });

  Color _getStatusColor(BuildContext context, String status) {
    switch (status) {
      case 'EXPIRING_SOON':
        return Colors.orange;
      case 'EXPIRED':
        return Colors.red;
      case 'LOW_STOCK':
        return Colors.amber[800]!;
      case 'NORMAL':
      default:
        return Theme.of(context).primaryColor;
    }
  }

  String _formatStatus(String status) {
    switch (status) {
      case 'EXPIRING_SOON':
        return 'Expiring Soon';
      case 'EXPIRED':
        return 'Expired';
      case 'LOW_STOCK':
        return 'Low Stock';
      case 'NORMAL':
      default:
        return 'In Stock';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(context, item.status);
    final statusLabel = _formatStatus(item.status);

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Item Icon Box
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(FluentIcons.food_24_regular, color: statusColor, size: 28),
                ),
                const SizedBox(width: 12),

                // Item Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              statusLabel,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (item.expirationDate != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              'Exp: ${DateFormat('MM/dd').format(DateTime.parse(item.expirationDate!))}',
                              style: TextStyle(color: Colors.grey[600], fontSize: 11),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Inline Quantity Controls
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(FluentIcons.subtract_circle_24_regular, color: Colors.grey),
                      onPressed: onDecrement,
                    ),
                    Text(
                      '${item.quantity} ${item.unit}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    IconButton(
                      icon: Icon(FluentIcons.add_circle_24_filled, color: Theme.of(context).primaryColor),
                      onPressed: onIncrement,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
