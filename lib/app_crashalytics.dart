import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:reestoko/utils/app_logger.dart';

class AppCrashalytics {
  static Future<void> init() async {
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    AppLogger.i('AppCrashalytics initialized');
  }

  static void recordError(dynamic exception, StackTrace? stack, {dynamic reason}) {
    FirebaseCrashlytics.instance.recordError(exception, stack, reason: reason);
  }
}
