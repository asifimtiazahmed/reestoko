/// **Architecture Layer**: Core
/// **Purpose**: Application navigation configuration.

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reestoko/core/error/error_page.dart';
import 'package:reestoko/features/home/presentation/pages/home_screen.dart';
import 'package:reestoko/features/inventory/presentation/pages/inventory_screen.dart';
import 'package:reestoko/features/inventory/presentation/viewmodels/inventory_view_model.dart';
import 'package:reestoko/features/main_shell/presentation/pages/main_shell.dart';
import 'package:reestoko/features/main_shell/presentation/viewmodels/main_shell_view_model.dart';
import 'package:reestoko/features/reports/presentation/pages/reports_screen.dart';
import 'package:reestoko/features/auth/presentation/pages/auth_screen.dart';
import 'package:reestoko/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:reestoko/features/settings/presentation/pages/settings_screen.dart';
import 'package:reestoko/features/shopping/presentation/pages/shopping_screen.dart';
import 'package:reestoko/features/shopping/presentation/viewmodels/shopping_view_model.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    observers: Firebase.apps.isNotEmpty
        ? [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)]
        : [],
    errorBuilder: (context, state) => ErrorPage(errorMessage: state.error.toString()),
    routes: [
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
          child: const AuthScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ChangeNotifierProvider(
            create: (_) => MainShellViewModel(),
            child: MainShell(navigationShell: navigationShell),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inventory',
                name: 'inventory',
                builder: (context, state) => ChangeNotifierProvider(
                  create: (_) => InventoryViewModel()..initialize('house_123'),
                  child: const InventoryScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/shopping',
                name: 'shopping',
                builder: (context, state) => ChangeNotifierProvider(
                  create: (_) => ShoppingViewModel()..initialize('house_123'),
                  child: const ShoppingScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reports',
                name: 'reports',
                builder: (context, state) => const ReportsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
