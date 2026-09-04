/// **Architecture Layer**: Core / Network / Models
/// **Purpose**: Data Transfer Object matching OpenAPI BarcodeProduct schema.

import 'package:equatable/equatable.dart';

class BarcodeProductDto extends Equatable {
  final String barcode;
  final String productName;
  final String? brand;
  final String? category;
  final String? imageUrl;

  const BarcodeProductDto({
    required this.barcode,
    required this.productName,
    this.brand,
    this.category,
    this.imageUrl,
  });

  factory BarcodeProductDto.fromJson(Map<String, dynamic> json) {
    return BarcodeProductDto(
      barcode: json['barcode'] as String,
      productName: json['productName'] as String,
      brand: json['brand'] as String?,
      category: json['category'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'productName': productName,
      if (brand != null) 'brand': brand,
      if (category != null) 'category': category,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  @override
  List<Object?> get props => [barcode, productName, brand, category, imageUrl];
}
