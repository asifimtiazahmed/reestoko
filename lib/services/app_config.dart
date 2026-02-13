import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reestoko/app_crashalytics.dart';
import 'package:reestoko/firebase_options.dart';
import 'package:reestoko/manager/analytics_manager.dart';
import 'package:reestoko/manager/app_remote_config.dart';
import 'package:reestoko/manager/data_manager.dart';
import 'package:reestoko/router/app_router.dart';
import 'package:reestoko/screens/error_page.dart';
import 'package:reestoko/services/local_storage_service.dart';
import 'package:reestoko/utils/app_logger.dart';

class AppConfig {
  static Future<void> configure() async {
    WidgetsFlutterBinding.ensureInitialized();

    // License registry (example) or Font config
    GoogleFonts.config.allowRuntimeFetching = true;

    if (kIsWeb) {
      // Web specific init
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    } else if (Platform.isAndroid || Platform.isIOS) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

      // Global Error Widget
      if (kReleaseMode) {
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return Material(
            child: ErrorPage(errorMessage: 'A critical error occurred.', errorDetails: details),
          );
        };
      }

      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      // Initialize Crashlytics
      await AppCrashalytics.init();

      // Initialize Ads
      //TODO: Enable after firebase setup
      // await AdManager().init();

      // Register Singletons
      GetIt.I.registerSingleton<AppRouter>(AppRouter());
      GetIt.I.registerSingleton<AppLogger>(AppLogger());

      final localStorage = LocalStorageService();
      await localStorage.init();
      GetIt.I.registerSingleton<LocalStorageService>(localStorage);

      GetIt.I.registerSingleton<AnalyticsManager>(AnalyticsManager());

      final remoteConfig = AppRemoteConfig();
      GetIt.I.registerSingleton<AppRemoteConfig>(remoteConfig);

      final dataManager = DataManager();
      GetIt.I.registerSingleton<DataManager>(dataManager);

      //Bootstrap DataManager
      await dataManager.bootstrap();

      AppLogger.i('AppConfig initialization complete');
    }
  }
}
