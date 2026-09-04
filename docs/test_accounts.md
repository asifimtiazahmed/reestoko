# Reestoko Demo Test Accounts & Login Credentials

Use these pre-configured test user accounts and credentials to test user authentication, multi-household isolation, Cloud Firestore security rules, and guest incognito mode.

---

## 1. Demo User Accounts & Passwords

### Account 1: Primary Family Account (Alex Johnson)
- **Email**: `alex.johnson@reestoko.app`
- **Password**: `Password123!`
- **Household Name**: `"Johnson Family Pantry"`
- **Household ID**: `house_johnson_01`
- **Role**: Household Owner & Member
- **Pre-populated Stock**: 14 items across Fridge, Pantry, Freezer (Organic Whole Milk, Wheat Bread, Eggs, Red Bell Peppers, Chicken Breast, Ice Cream, Coffee Beans, etc.)

---

### Account 2: Secondary Family Account (Sarah Smith)
- **Email**: `sarah.smith@reestoko.app`
- **Password**: `Password123!`
- **Household Name**: `"Smith Household Stock"`
- **Household ID**: `house_smith_02`
- **Role**: Household Owner & Member
- **Pre-populated Stock**: 8 items (Almond Milk, Greek Yogurt, Spaghetti, Tomato Sauce, Salmon Fillets, Apples)

---

### Account 3: Incognito / Guest Mode (Anonymous User)
- **Login Type**: Guest Incognito Access (No Password Required)
- **User ID**: Auto-generated Firebase Anonymous Auth UID (`request.auth.isAnonymous == true`)
- **Household ID**: `house_guest_temp`
- **Features Available**: Full local pantry browsing, item adding, barcode scanner.
- **Upgrade Prompts**: Attempting to invite members or create custom zones displays an interactive upgrade prompt asking the guest user to register via Google, Apple, or Email to save their stock across devices!

---

## 2. Programmatic Firestore Seeding

You can run or trigger the automated Firestore seed generator directly inside the app settings screen or via `FirebaseSeedData.seedDemoData()`.
