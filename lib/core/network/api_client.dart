/// **Architecture Layer**: Core / Network
/// **Purpose**: Production Dio-backed API Client implementing the OpenAPI contract endpoints.

import 'package:dio/dio.dart';
import 'package:reestoko/core/network/api_endpoints.dart';
import 'package:reestoko/core/network/models/barcode_product_dto.dart';
import 'package:reestoko/core/network/models/inventory_item_dto.dart';
import 'package:reestoko/core/network/models/shopping_item_dto.dart';
import 'package:reestoko/core/utils/app_logger.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiEndpoints.baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.d('REST API Request: [${options.method}] ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.d('REST API Response: [${response.statusCode}] ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          AppLogger.e('REST API Error: ${e.message} at ${e.requestOptions.path}');
          return handler.next(e);
        },
      ),
    );
  }

  /// Attach Auth Bearer Token for authenticated requests
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // ===========================================================================
  // Inventory Endpoints (OpenAPI: /households/{householdId}/inventory)
  // ===========================================================================

  Future<List<InventoryItemDto>> getInventoryItems({
    required String householdId,
    String? zoneId,
    String? status,
    String? search,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.inventory(householdId),
        queryParameters: {
          if (zoneId != null) 'zoneId': zoneId,
          if (status != null) 'status': status,
          if (search != null) 'search': search,
        },
      );
      final List data = response.data as List;
      return data.map((json) => InventoryItemDto.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      AppLogger.e('Failed to fetch inventory items: $e');
      rethrow;
    }
  }

  Future<InventoryItemDto> createInventoryItem({
    required String householdId,
    required Map<String, dynamic> itemJson,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.inventory(householdId),
        data: itemJson,
      );
      return InventoryItemDto.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      AppLogger.e('Failed to create inventory item: $e');
      rethrow;
    }
  }

  Future<InventoryItemDto> updateInventoryItem({
    required String householdId,
    required String itemId,
    required Map<String, dynamic> updatesJson,
  }) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.inventoryItem(householdId, itemId),
        data: updatesJson,
      );
      return InventoryItemDto.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      AppLogger.e('Failed to update inventory item: $e');
      rethrow;
    }
  }

  Future<void> deleteInventoryItem({
    required String householdId,
    required String itemId,
  }) async {
    try {
      await _dio.delete(ApiEndpoints.inventoryItem(householdId, itemId));
    } catch (e) {
      AppLogger.e('Failed to delete inventory item: $e');
      rethrow;
    }
  }

  // ===========================================================================
  // Shopping List Endpoints (OpenAPI: /households/{householdId}/shopping-list)
  // ===========================================================================

  Future<List<ShoppingItemDto>> getShoppingList({required String householdId}) async {
    try {
      final response = await _dio.get(ApiEndpoints.shoppingList(householdId));
      final List data = response.data as List;
      return data.map((json) => ShoppingItemDto.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      AppLogger.e('Failed to fetch shopping list: $e');
      rethrow;
    }
  }

  Future<void> purchaseShoppingItems({
    required String householdId,
    required List<String> itemIds,
    bool autoRestockToInventory = true,
  }) async {
    try {
      await _dio.post(
        ApiEndpoints.shoppingListPurchase(householdId),
        data: {
          'itemIds': itemIds,
          'autoRestockToInventory': autoRestockToInventory,
        },
      );
    } catch (e) {
      AppLogger.e('Failed to purchase shopping items: $e');
      rethrow;
    }
  }

  // ===========================================================================
  // Barcode Metadata Lookup (OpenAPI: /barcode/lookup/{barcode})
  // ===========================================================================

  Future<BarcodeProductDto> lookupBarcode(String barcode) async {
    try {
      final response = await _dio.get(ApiEndpoints.barcodeLookup(barcode));
      return BarcodeProductDto.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      AppLogger.e('Failed barcode lookup for $barcode: $e');
      rethrow;
    }
  }
}
