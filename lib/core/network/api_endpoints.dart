/// **Architecture Layer**: Core / Network
/// **Purpose**: Centralized REST endpoint mapping matching OpenAPI specification.

class ApiEndpoints {
  static const String baseUrl = 'https://api.reestoko.app/v1';

  // Auth / User
  static const String currentUser = '/users/me';

  // Households
  static const String households = '/households';
  static String householdById(String householdId) => '/households/$householdId';

  // Zones
  static String zones(String householdId) => '/households/$householdId/zones';

  // Inventory
  static String inventory(String householdId) => '/households/$householdId/inventory';
  static String inventoryItem(String householdId, String itemId) => '/households/$householdId/inventory/$itemId';
  static String priorityFeed(String householdId) => '/households/$householdId/priority-feed';

  // Shopping List
  static String shoppingList(String householdId) => '/households/$householdId/shopping-list';
  static String shoppingListPurchase(String householdId) => '/households/$householdId/shopping-list/purchase';

  // Barcode External Metadata
  static String barcodeLookup(String barcode) => '/barcode/lookup/$barcode';
}
