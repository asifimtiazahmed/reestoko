# Reestoko MVP Specification Document

## 1. Product Overview & Vision
**Reestoko** is an intuitive, smart household stock management and pantry tracking application designed for individuals and families. The primary goal is to prevent food waste, monitor inventory levels in real-time across home storage zones (Fridge, Pantry, Freezer), and streamline grocery shopping through automated low-stock detection and auto-restocking capabilities.

---

## 2. Core MVP Feature Modules

### 2.1 User Management & Household Context
- **Authentication**: Email/Password and Google Sign-In via Firebase Auth.
- **User Profile**: User ID, display name, email, avatar URL, and theme preferences.
- **Household Context**: 
  - Every user belongs to a `Household`.
  - *Current MVP Model*: 1 Household per User (`user.householdId`).
  - *Future-Proof Design*: Schema stores `memberUids: [uid]` array so multi-user shared access (e.g. spouse, roommates) can be enabled seamlessly without database migration.

### 2.2 Storage Zone Management
- **Predefined Zones**:
  - **Fridge**: Perishables, dairy, produce.
  - **Pantry**: Dry goods, canned items, spices.
  - **Freezer**: Frozen meals, meats, ice cream.
- **Custom Zones**: Support for user-defined storage areas (e.g., "Garage Storage", "Spice Rack").
- **Zone Metrics**: Total item count and visual breakdown per zone.

### 2.3 Inventory Item Tracking
- **Item Fields**:
  - `id`: Unique identifier (UUID).
  - `name`: Item name (e.g., "Organic Whole Milk").
  - `zoneId`: Associated storage zone.
  - `category`: Category tag (Dairy, Produce, Bakery, Meat, Canned, Beverages, Household).
  - `quantity`: Current numeric quantity.
  - `minThreshold`: Minimum threshold triggering low stock alerts (default: 1).
  - `unit`: Unit of measurement (pcs, kg, liters, oz, boxes).
  - `expirationDate`: Expiry timestamp.
  - `barcode`: Barcode string (optional, for scanner lookup).
  - `updatedAt` / `createdAt`: Audit timestamps.
- **Stock Status Logic**:
  - `NORMAL`: Quantity > `minThreshold` and days to expire > 3.
  - `LOW_STOCK`: Quantity <= `minThreshold`.
  - `EXPIRING_SOON`: Expiration date within 3 days.
  - `EXPIRED`: Expiration date in the past.

### 2.4 Priority Action Feed & Home Dashboard
- **Header Summary**: Overall household stock percentage (e.g., "Your kitchen is 85% stocked").
- **Smart Banner Alert**: Highlight top urgent items (e.g., "Apples expiring soon! Use in a recipe").
- **Quick Stats Row**: Total item count, Low Stock count, Expiring Soon count.
- **Priority Action Feed**: Chronological list of urgent items requiring action (buying or consuming).
- **Quick Action Bar**: Search bar with integrated Barcode/QR scanner trigger.

### 2.5 Smart Shopping List & Auto-Restock
- **Auto-Populate**: Items reaching `LOW_STOCK` automatically generate a draft entry in the Shopping List.
- **Manual Additions**: Users can manually add custom items to buy.
- **Check-off & Restock Flow**:
  - Tapping check-box marks item as `purchased`.
  - Option to auto-increment item quantity in inventory upon purchase confirmation.

### 2.6 Analytics & Reports
- **Consumption Rate**: Track fast-moving pantry items vs slow-moving stock.
- **Waste Prevention Summary**: Track items consumed before expiration vs expired items discarded.
- **Category Distribution**: Pie/Bar chart breakdown of item stock across categories.

### 2.7 App System Services
- **Remote Config**: Dynamic version enforcement (`force_update_current_version`) and feature toggles.
- **AdMob Integration**: Native banner and interstitial ads for non-premium users.
- **Crashlytics & Analytics**: App stability logging and user event tracking (`AppLogger`, `AppCrashalytics`).

---

## 3. Technical Architecture & Design Principles

```
lib/
 ├── core/                        # Shared cross-cutting concerns
 │    ├── constants/              # App-wide constants
 │    ├── di/                     # Service Locator / Dependency Injection
 │    ├── error/                  # Custom exceptions & failure models
 │    ├── network/                # OpenAPI generated HTTP client & WebSockets
 │    ├── router/                 # GoRouter navigation configuration
 │    ├── services/               # Device & Firebase infrastructure services
 │    └── theme/                  # UI AppTheme tokens
 │
 ├── features/                    # Feature Modules (Clean Architecture)
 │    ├── auth/                   # Login, Registration, Session state
 │    ├── home/                   # Dashboard & Priority Action Feed
 │    ├── inventory/              # Items, Zone detail, Item details & Edit
 │    ├── shopping/               # Shopping list & Auto-restock engine
 │    ├── reports/                # Stock analytics & Waste tracking
 │    └── settings/               # App preferences, theme, profile
```

### Key Architectural Guidelines (Anti-God Class Principles)
1. **Single Responsibility Principle (SRP)**: ViewModels handle UI state presentation only; business logic resides in Use Cases / Repositories.
2. **Data Layer Decoupling**: ViewModels call abstract `Repository` interfaces, not raw Firestore SDK or direct HTTP clients.
3. **Immutability & Value Objects**: All data models use `copyWith`, `Equatable`, and JSON serializability.
