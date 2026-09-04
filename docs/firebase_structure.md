# Cloud Firestore Database Schema Reference

This reference document outlines the complete Cloud Firestore database architecture for **Reestoko**. 
It is engineered to support a single user per household for the initial MVP while natively enabling multi-user household collaboration (e.g. sharing stock with spouse, family, or roommates) in future iterations without requiring schema migrations or breaking security rules.

---

## 1. High-Level Collection Hierarchy

```
cloud_firestore/
├── users/                           (Collection: User profiles)
│   └── {userId}                     (Document: User metadata & current household pointer)
│
├── households/                      (Collection: Household containers)
│   └── {householdId}                (Document: Household settings & member ACLs)
│       │
│       ├── zones/                   (Subcollection: Storage zones - Fridge, Pantry, etc.)
│       │   └── {zoneId}             (Document: Zone metadata)
│       │
│       ├── items/                   (Subcollection: Inventory stock items)
│       │   └── {itemId}             (Document: Quantity, expiration, status)
│       │
│       ├── shopping_list/           (Subcollection: Shopping items to buy)
│       │   └── {shoppingItemId}     (Document: Shopping check-off & auto-restock flag)
│       │
│       └── activity_logs/           (Subcollection: Audit history of stock changes)
│           └── {logId}              (Document: Action logs, who added/consumed items)
```

---

## 2. Collection & Document Specifications

### 2.1 Collection: `users`
- **Document ID**: `{userId}` (Matches `request.auth.uid` from Firebase Auth).
- **Purpose**: Stores individual user profile data and active household assignment.

| Field Name | Data Type | Required | Description / Example |
| :--- | :--- | :--- | :--- |
| `id` | String | Yes | Unique Firebase Auth UID (`request.auth.uid`). |
| `name` | String | Yes | Display name (e.g., `"Alex Johnson"`). |
| `email` | String | Yes | User email address. |
| `avatarUrl` | String (URL) | No | Profile photo URL. |
| `householdId` | String | Yes | Primary household ID reference (e.g., `"house_123"`). |
| `isPremium` | Boolean | Yes | Premium subscription tier flag (default: `false`). |
| `createdAt` | Timestamp | Yes | Account creation date. |
| `updatedAt` | Timestamp | Yes | Profile last updated date. |

---

### 2.2 Collection: `households`
- **Document ID**: `{householdId}` (UUID or auto-generated document ID).
- **Purpose**: The root container for shared household data.

| Field Name | Data Type | Required | Description / Example |
| :--- | :--- | :--- | :--- |
| `id` | String | Yes | Household document ID. |
| `name` | String | Yes | Household display name (e.g., `"Sweet Home Pantry"`). |
| `ownerUid` | String | Yes | UID of the user who created the household. |
| `memberUids` | Array of Strings | Yes | List of authorized user UIDs (`["uid_123", "uid_456"]`). *Enables future multi-user sharing!* |
| `createdAt` | Timestamp | Yes | Household creation timestamp. |

---

### 2.3 Subcollection: `households/{householdId}/zones`
- **Document ID**: `{zoneId}` (e.g., `"zone_fridge"`, `"zone_pantry"`, `"zone_freezer"`).
- **Purpose**: Categorizes physical storage locations inside the home.

| Field Name | Data Type | Required | Description / Example |
| :--- | :--- | :--- | :--- |
| `id` | String | Yes | Zone document ID. |
| `name` | String | Yes | Zone display name (`"Fridge"`, `"Pantry"`, `"Freezer"`). |
| `iconName` | String | Yes | Fluent icon name (`"snowflake"`, `"archive"`, `"cube"`). |
| `itemCount` | Integer | Yes | Cache of total items stored in this zone (default: `0`). |

---

### 2.4 Subcollection: `households/{householdId}/items`
- **Document ID**: `{itemId}` (UUID).
- **Purpose**: Individual inventory item records.

| Field Name | Data Type | Required | Description / Example |
| :--- | :--- | :--- | :--- |
| `id` | String | Yes | Inventory item document ID. |
| `name` | String | Yes | Item title (e.g., `"Organic Whole Milk"`). |
| `zoneId` | String | Yes | Storage zone reference ID (`"zone_fridge"`). |
| `category` | String | No | Item category tag (`"Dairy"`, `"Produce"`, `"Meat"`). |
| `quantity` | Integer | Yes | Current stock count (>= 0). |
| `minThreshold` | Integer | Yes | Low stock threshold triggering shopping list auto-add (default: `1`). |
| `unit` | String | Yes | Unit of measurement (`"pcs"`, `"gallon"`, `"kg"`, `"box"`). |
| `expirationDate` | Timestamp | No | Expiration date timestamp. |
| `barcode` | String | No | EAN-13 / UPC barcode digits (`"012345678905"`). |
| `status` | String | Yes | Stock status (`"NORMAL"`, `"LOW_STOCK"`, `"EXPIRING_SOON"`, `"EXPIRED"`). |
| `createdBy` | String | Yes | UID of the user who added the item. |
| `createdAt` | Timestamp | Yes | Creation timestamp. |
| `updatedAt` | Timestamp | Yes | Last modification timestamp. |

---

### 2.5 Subcollection: `households/{householdId}/shopping_list`
- **Document ID**: `{shoppingItemId}` (UUID).
- **Purpose**: Items queued for upcoming grocery runs.

| Field Name | Data Type | Required | Description / Example |
| :--- | :--- | :--- | :--- |
| `id` | String | Yes | Shopping item document ID. |
| `name` | String | Yes | Item name (`"Whole Wheat Bread"`). |
| `quantityToBuy` | Integer | Yes | Needed quantity (>= 1). |
| `unit` | String | Yes | Unit (`"loaf"`, `"pcs"`). |
| `inventoryItemId` | String | No | Original inventory item ID if auto-generated from low stock. |
| `isPurchased` | Boolean | Yes | Check-off state (`true` / `false`). |
| `isAutoGenerated`| Boolean | Yes | `true` if generated automatically from low stock trigger. |
| `addedBy` | String | Yes | User UID who added or triggered the item. |
| `createdAt` | Timestamp | Yes | Timestamp. |

---

### 2.6 Subcollection: `households/{householdId}/activity_logs`
- **Document ID**: `{logId}` (UUID).
- **Purpose**: Real-time event log of household inventory activity.

| Field Name | Data Type | Required | Description / Example |
| :--- | :--- | :--- | :--- |
| `id` | String | Yes | Log ID. |
| `action` | String | Yes | Action type (`"ITEM_ADDED"`, `"QUANTITY_UPDATED"`, `"ITEM_PURCHASED"`, `"ITEM_EXPIRED"`). |
| `itemId` | String | Yes | Target item ID. |
| `itemName` | String | Yes | Item name snapshot. |
| `performedBy` | String | Yes | User UID who executed the action. |
| `timestamp` | Timestamp | Yes | Log event timestamp. |

---

## 3. Recommended Cloud Firestore Composite Indexes

To ensure fast query performance (<50ms) across large inventories, create the following composite indexes in Firebase Console or `firestore.indexes.json`:

1. **Expiring Items Query**:
   - Collection: `items` (Scope: Collection Group or Subcollection)
   - Fields: `status` ASC, `expirationDate` ASC
2. **Low Stock Query**:
   - Collection: `items`
   - Fields: `quantity` ASC, `minThreshold` ASC
3. **Zone Item Lookup**:
   - Collection: `items`
   - Fields: `zoneId` ASC, `name` ASC
