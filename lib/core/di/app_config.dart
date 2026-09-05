/// **Architecture Layer**: Core
/// **Purpose**: Cross-platform dependency injection and app configuration setup (Android, iOS, Web, Desktop).

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reestoko/core/error/error_page.dart';

import 'package:reestoko/core/network/api_client.dart';
import 'package:reestoko/core/network/websocket_service.dart';
import 'package:reestoko/core/router/app_router.dart';
import 'package:reestoko/core/services/analytics_manager.dart';
import 'package:reestoko/core/services/app_crashalytics.dart';
import 'package:reestoko/core/services/app_remote_config.dart';
import 'package:reestoko/core/services/data_manager.dart';
import 'package:reestoko/core/services/local_storage_service.dart';
import 'package:reestoko/core/utils/app_logger.dart';
import 'package:reestoko/firebase_options.dart';

class AppConfig {
  static bool _configured = false;

  static Future<void> configure() async {
    if (_configured) return;

    WidgetsFlutterBinding.ensureInitialized();

    // Google Fonts configuration
    GoogleFonts.config.allowRuntimeFetching = true;

    // Orientation lock for mobile devices (non-web only)
    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
    }

    // Global Error Widget builder in Release mode
    if (kReleaseMode) {
      ErrorWidget.builder = (FlutterErrorDetails details) {
        return Material(
          child: ErrorPage(errorMessage: 'A critical error occurred.', errorDetails: details),
        );
      };
    }

    // Initialize Firebase (Safe cross-platform)
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      }
    } catch (e) {
      debugPrint('Firebase initialization warning: $e');
    }

    // Initialize Crashlytics on supported platforms
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      try {
        await AppCrashalytics.init();
      } catch (e) {
        debugPrint('Crashlytics initialization warning: $e');
      }
    }

    // =========================================================================
    // Universal Singleton Dependency Registration (GetIt)
    // Works on Mobile, Web, and Desktop!
    // =========================================================================

    if (!GetIt.I.isRegistered<AppLogger>()) {
      GetIt.I.registerSingleton<AppLogger>(AppLogger());
    }

    if (!GetIt.I.isRegistered<AppRouter>()) {
      GetIt.I.registerSingleton<AppRouter>(AppRouter());
    }

    if (!GetIt.I.isRegistered<LocalStorageService>()) {
      final localStorage = LocalStorageService();
      try {
        await localStorage.init();
      } catch (e) {
        debugPrint('LocalStorage init warning: $e');
      }
      GetIt.I.registerSingleton<LocalStorageService>(localStorage);
    }

    if (!GetIt.I.isRegistered<AnalyticsManager>()) {
      GetIt.I.registerSingleton<AnalyticsManager>(AnalyticsManager());
    }

    if (!GetIt.I.isRegistered<AppRemoteConfig>()) {
      GetIt.I.registerSingleton<AppRemoteConfig>(AppRemoteConfig());
    }

    if (!GetIt.I.isRegistered<DataManager>()) {
      final dataManager = DataManager();
      GetIt.I.registerSingleton<DataManager>(dataManager);
      await dataManager.bootstrap();
    }

    if (!GetIt.I.isRegistered<ApiClient>()) {
      GetIt.I.registerSingleton<ApiClient>(ApiClient());
    }

    if (!GetIt.I.isRegistered<WebSocketService>()) {
      GetIt.I.registerSingleton<WebSocketService>(WebSocketService());
    }

    _configured = true;
    AppLogger.i('AppConfig universal initialization complete across platforms.');
  }
}
