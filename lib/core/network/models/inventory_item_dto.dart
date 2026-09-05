/// **Architecture Layer**: Core / Network / Models
/// **Purpose**: Data Transfer Object matching OpenAPI InventoryItem schema.

import 'package:equatable/equatable.dart';

class InventoryItemDto extends Equatable {
  final String id;
  final String name;
  final String zoneId;
  final String? category;
  final int quantity;
  final int minThreshold;
  final String unit;
  final String? expirationDate;
  final String? barcode;
  final String status;
  final String? updatedAt;

  const InventoryItemDto({
    required this.id,
    required this.name,
    required this.zoneId,
    this.category,
    required this.quantity,
    this.minThreshold = 1,
    required this.unit,
    this.expirationDate,
    this.barcode,
    this.status = 'NORMAL',
    this.updatedAt,
  });

  factory InventoryItemDto.fromJson(Map<String, dynamic> json) {
    return InventoryItemDto(
      id: json['id'] as String,
      name: json['name'] as String,
      zoneId: json['zoneId'] as String,
      category: json['category'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      minThreshold: (json['minThreshold'] as num?)?.toInt() ?? 1,
      unit: json['unit'] as String,
      expirationDate: json['expirationDate'] as String?,
      barcode: json['barcode'] as String?,
      status: json['status'] as String? ?? 'NORMAL',
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'zoneId': zoneId,
      if (category != null) 'category': category,
      'quantity': quantity,
      'minThreshold': minThreshold,
      'unit': unit,
      if (expirationDate != null) 'expirationDate': expirationDate,
      if (barcode != null) 'barcode': barcode,
      'status': status,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        zoneId,
        category,
        quantity,
        minThreshold,
        unit,
        expirationDate,
        barcode,
        status,
        updatedAt,
      ];
}
