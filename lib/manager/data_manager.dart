import 'package:flutter/foundation.dart';
import 'package:reestoko/constants/app_constants.dart';
import 'package:reestoko/utils/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataManager with ChangeNotifier {
  late final SharedPreferences _prefs;

  bool _bootstrapped = false;
  bool get isBootstrapped => _bootstrapped;

  // Example State
  bool _isOnboardingComplete = false;
  bool get isOnboardingComplete => _isOnboardingComplete;

  DataManager() {
    AppLogger.i('DataManager initialized');
  }

  // One-shot startup orchestration
  Future<void> bootstrap() async {
    if (_bootstrapped) return;

    _prefs = await SharedPreferences.getInstance();

    // Restore local state
    _restoreState();

    _bootstrapped = true;
    notifyListeners();
    AppLogger.i('DataManager bootstrapped');
  }

  void _restoreState() {
    _isOnboardingComplete = _prefs.getBool(AppConstants.keyOnboarding) ?? false;
    AppLogger.d('Restored state: Onboarding=$_isOnboardingComplete');
  }

  // Example Action
  Future<void> setOnboardingComplete(bool complete) async {
    _isOnboardingComplete = complete;
    await _prefs.setBool(AppConstants.keyOnboarding, complete);
    notifyListeners();
  }

  // Example: Persist Theme
  Future<void> saveTheme(String themeName) async {
    await _prefs.setString(AppConstants.keyTheme, themeName);
  }

  String? getSavedTheme() {
    return _prefs.getString(AppConstants.keyTheme);
  }
}
