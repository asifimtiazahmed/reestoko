# reestoko

A project for managing stock of necessary items at home

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Here is the folder structure for implementation of "Clean Architecture" in Flutter:

```
llib/
 ├── core/                        # Shared functionality across the entire app
 │    ├── constants/              # App-wide constants (e.g., AppConstants)
 │    ├── di/                     # Dependency Injection setup (AppConfig, AppInitializer)
 │    ├── error/                  # Error handling, Custom Exceptions, ErrorPage
 │    ├── router/                 # Navigation setup (AppRouter)
 │    ├── services/               # Core services (AdManager, AnalyticsManager, DataManager, LocalStorageService, AppCrashalytics, RemoteConfig)
 │    ├── theme/                  # Global styling (AppTheme)
 │    ├── utils/                  # Helper classes and loggers (AppLogger)
 │    └── widgets/                # Common UI components (LoadingWidget, UpdatePromptOverlay)
 │
 ├── features/                    # Feature modules containing Data, Domain, and Presentation layers
 │    │
 │    ├── home/
 │    │    └── presentation/
 │    │         ├── pages/        # home_screen.dart
 │    │         ├── viewmodels/   # home_view_model.dart
 │    │         └── widgets/      # home_widgets.dart
 │    │
 │    ├── inventory/
 │    │    └── presentation/
 │    │         ├── pages/        # inventory_screen.dart
 │    │         └── viewmodels/   # inventory_view_model.dart
 │    │
 │    ├── main_shell/             # The Persistent Bottom Navigation Shell
 │    │    └── presentation/
 │    │         ├── pages/        # main_shell.dart
 │    │         └── viewmodels/   # main_shell_view_model.dart
 │    │
 │    ├── reports/
 │    │    └── presentation/
 │    │         ├── pages/        # reports_screen.dart
 │    │         └── viewmodels/   # reports_view_model.dart
 │    │
 │    ├── settings/
 │    │    └── presentation/
 │    │         ├── pages/        # settings_screen.dart
 │    │         └── viewmodels/   # settings_view_model.dart
 │    │
 │    ├── shopping/
 │    │    └── presentation/
 │    │         ├── pages/        # shopping_screen.dart
 │    │         └── viewmodels/   # shopping_view_model.dart
 │    │
 │    └── user/                   # Example of a domain/data feature model
 │         └── data/
 │              └── models/       # user_model.dart
 │
 ├── firebase_options.dart        # Firebase generated file
 └── main.dart                    # Application entry point
```