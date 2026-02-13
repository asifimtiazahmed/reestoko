import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:go_router/go_router.dart';
import 'package:reestoko/screens/error_page.dart';
import 'package:reestoko/screens/home_screen.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    observers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
    errorBuilder: (context, state) => ErrorPage(errorMessage: state.error.toString()),
    routes: [
      GoRoute(path: '/', name: 'home', builder: (context, state) => const HomeScreen()),
      // Add more routes here
    ],
  );
}
