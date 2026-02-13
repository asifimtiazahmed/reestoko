import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Boolean
  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  // String
  String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  // Integer
  int getInt(String key, {int defaultValue = 0}) {
    return _prefs?.getInt(key) ?? defaultValue;
  }

  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  // Double
  double getDouble(String key, {double defaultValue = 0.0}) {
    return _prefs?.getDouble(key) ?? defaultValue;
  }
  
  Future<void> setDouble(String key, double value) async {
    await _prefs?.setDouble(key, value);
  }

  // Removal
  Future<void> clearKey(String key) async {
    await _prefs?.remove(key);
  }

  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
