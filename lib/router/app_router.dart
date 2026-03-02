import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reestoko/screens/error_page.dart';
import 'package:reestoko/screens/home_screen/home_screen.dart';
import 'package:reestoko/screens/inventory_screen/inventory_screen.dart';
import 'package:reestoko/screens/main_shell/main_shell.dart';
import 'package:reestoko/screens/main_shell/main_shell_view_model.dart';
import 'package:reestoko/screens/reports_screen/reports_screen.dart';
import 'package:reestoko/screens/settings_screen/settings_screen.dart';
import 'package:reestoko/screens/shopping_screen/shopping_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    observers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
    errorBuilder: (context, state) => ErrorPage(errorMessage: state.error.toString()),
    routes: [
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
                builder: (context, state) => const InventoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/shopping',
                name: 'shopping',
                builder: (context, state) => const ShoppingScreen(),
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
