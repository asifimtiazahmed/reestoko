import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get_it/get_it.dart';
import 'package:reestoko/utils/app_logger.dart';

class AnalyticsManager {
  FirebaseAnalytics? _analytics;
  late final AppLogger _logger; // Use singleton or passed instance

  AnalyticsManager({FirebaseAnalytics? analytics}) {
    _analytics =
        analytics ??
        (GetIt.I.isRegistered<FirebaseAnalytics>() ? GetIt.I<FirebaseAnalytics>() : FirebaseAnalytics.instance);
    // Assuming AppLogger acts as a static utility or singleton registered in GetIt
  }

  // ======================================================
  // Core Tracking
  // ======================================================

  Future<void> logScreenView(String screenName, String screenClass) async {
    await _analytics?.logScreenView(screenName: screenName, screenClass: screenClass);
    AppLogger.d('📊 Analytics: Screen View -> $screenName ($screenClass)');
  }

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    await _analytics?.logEvent(name: name, parameters: parameters);
    AppLogger.d('📊 Analytics: Event -> $name, params: $parameters');
  }

  // ======================================================
  // User Properties
  // ======================================================

  Future<void> setUserId(String? uid) async {
    if (uid != null) {
      await _analytics?.setUserId(id: uid);
      AppLogger.d('📊 Analytics: Set user ID');
    }
  }

  Future<void> setUserProperty(String name, String value) async {
    await _analytics?.setUserProperty(name: name, value: value);
    AppLogger.d('📊 Analytics: Set property $name=$value');
  }

  // ======================================================
  //  App Specific Events (Examples)
  // ======================================================

  Future<void> logAppOpen() async {
    await logEvent('app_open');
  }

  Future<void> logThemeChanged(String themeName) async {
    await logEvent('theme_changed', parameters: {'theme': themeName});
  }
}
