/// **Architecture Layer**: Presentation (Widget)
/// **Purpose**: Interactive Modal Bottom Sheet for Adding / Editing Inventory Items.

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reestoko/core/network/models/barcode_product_dto.dart';
import 'package:reestoko/core/network/models/inventory_item_dto.dart';
import 'package:reestoko/core/widgets/barcode_scanner_dialog.dart';

class AddEditItemModal extends StatefulWidget {
  final InventoryItemDto? initialItem;
  final Function(InventoryItemDto) onSave;

  const AddEditItemModal({
    super.key,
    this.initialItem,
    required this.onSave,
  });

  @override
  State<AddEditItemModal> createState() => _AddEditItemModalState();
}

class _AddEditItemModalState extends State<AddEditItemModal> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _minThresholdController;
  late TextEditingController _barcodeController;

  String _selectedZoneId = 'zone_fridge';
  String _selectedCategory = 'Dairy';
  String _selectedUnit = 'pcs';
  DateTime? _expirationDate;

  final List<Map<String, String>> _zones = [
    {'id': 'zone_fridge', 'name': 'Fridge'},
    {'id': 'zone_pantry', 'name': 'Pantry'},
    {'id': 'zone_freezer', 'name': 'Freezer'},
  ];

  final List<String> _categories = [
    'Dairy',
    'Produce',
    'Bakery',
    'Meat',
    'Canned',
    'Beverages',
    'Household',
  ];

  final List<String> _units = ['pcs', 'kg', 'g', 'liters', 'ml', 'box', 'loaf', 'pack'];

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    _nameController = TextEditingController(text: item?.name ?? '');
    _quantityController = TextEditingController(text: (item?.quantity ?? 1).toString());
    _minThresholdController = TextEditingController(text: (item?.minThreshold ?? 1).toString());
    _barcodeController = TextEditingController(text: item?.barcode ?? '');
    _selectedZoneId = item?.zoneId ?? 'zone_fridge';
    _selectedCategory = item?.category ?? 'Dairy';
    _selectedUnit = item?.unit ?? 'pcs';
    if (item?.expirationDate != null) {
      _expirationDate = DateTime.tryParse(item!.expirationDate!);
    } else {
      _expirationDate = DateTime.now().add(const Duration(days: 7));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _minThresholdController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  Future<void> _openBarcodeScanner() async {
    final BarcodeProductDto? product = await showDialog<BarcodeProductDto>(
      context: context,
      builder: (context) => const BarcodeScannerDialog(),
    );

    if (product != null) {
      setState(() {
        _nameController.text = product.productName;
        _barcodeController.text = product.barcode;
        if (product.category != null && _categories.contains(product.category)) {
          _selectedCategory = product.category!;
        }
      });
    }
  }

  Future<void> _pickExpirationDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expirationDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );

    if (picked != null) {
      setState(() => _expirationDate = picked);
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final id = widget.initialItem?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    final qty = int.tryParse(_quantityController.text) ?? 1;
    final minQty = int.tryParse(_minThresholdController.text) ?? 1;

    String status = 'NORMAL';
    if (qty <= minQty) {
      status = 'LOW_STOCK';
    } else if (_expirationDate != null) {
      final days = _expirationDate!.difference(DateTime.now()).inDays;
      if (days < 0) {
        status = 'EXPIRED';
      } else if (days <= 3) {
        status = 'EXPIRING_SOON';
      }
    }

    final item = InventoryItemDto(
      id: id,
      name: _nameController.text.trim(),
      zoneId: _selectedZoneId,
      category: _selectedCategory,
      quantity: qty,
      minThreshold: minQty,
      unit: _selectedUnit,
      expirationDate: _expirationDate?.toIso8601String(),
      barcode: _barcodeController.text.trim().isEmpty ? null : _barcodeController.text.trim(),
      status: status,
      updatedAt: DateTime.now().toIso8601String(),
    );

    widget.onSave(item);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialItem != null;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Edit Item' : 'Add New Item',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Item Name with Scanner Button
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  hintText: 'e.g., Organic Whole Milk',
                  prefixIcon: const Icon(FluentIcons.food_24_regular),
                  suffixIcon: IconButton(
                    icon: const Icon(FluentIcons.barcode_scanner_24_regular, color: Colors.green),
                    onPressed: _openBarcodeScanner,
                    tooltip: 'Scan Barcode',
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter item name' : null,
              ),
              const SizedBox(height: 12),

              // Zone & Category Dropdowns
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedZoneId,
                      decoration: InputDecoration(
                        labelText: 'Storage Zone',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: _zones
                          .map((z) => DropdownMenuItem(value: z['id'], child: Text(z['name']!)))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedZoneId = val!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: _categories
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedCategory = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Quantity, Unit & Min Threshold
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (val) =>
                          val == null || int.tryParse(val) == null ? 'Enter number' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedUnit,
                      decoration: InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: _units
                          .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedUnit = val!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _minThresholdController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Min Stock',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Expiration Date Picker Row
              InkWell(
                onTap: _pickExpirationDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(FluentIcons.calendar_clock_24_regular, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _expirationDate == null
                              ? 'Set Expiration Date'
                              : 'Expires: ${DateFormat.yMMMd().format(_expirationDate!)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isEditing ? 'Save Changes' : 'Add to Inventory',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
