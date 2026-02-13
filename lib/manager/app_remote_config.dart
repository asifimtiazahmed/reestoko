import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:reestoko/constants/app_constants.dart';
import 'package:reestoko/utils/app_logger.dart';

class AppRemoteConfig {
  static String remoteVersion = '';
  static String localVersion = '';

  final _remoteConfig = FirebaseRemoteConfig.instance;
  late PackageInfo _packageInfo;

  AppRemoteConfig() {
    _initRemoteConfig();
  }

  String get remoteBuildVersion => remoteVersion;
  String get localBuildVersion => localVersion;

  /// Load configs from Firebase
  Future<void> _initRemoteConfig() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1), // Adjust for dev/prod
        ),
      );

      await _initPackageInfo();
      await _setDefaultConfig();
      await _remoteConfig.fetchAndActivate();

      // Update remote version after fetch
      remoteVersion = _remoteConfig.getString(AppConstants.keyAppVersion);
      AppLogger.i('Remote Config initialized. Local: $localVersion, Remote: $remoteVersion');
    } catch (e) {
      AppLogger.e('Failed to init Remote Config: $e');
    }
  }

  Future<void> _initPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
    localVersion = _packageInfo.buildNumber.isEmpty ? '1' : _packageInfo.buildNumber;
  }

  /// Set default configs
  Future<void> _setDefaultConfig() async {
    await _remoteConfig.setDefaults(<String, dynamic>{AppConstants.keyAppVersion: localVersion});
  }

  /// Check if update is required
  bool get isUpdateRequired {
    if (remoteVersion.isEmpty || localVersion.isEmpty) return false;
    try {
      int remote = int.parse(remoteVersion);
      int local = int.parse(localVersion);
      return remote > local;
    } catch (e) {
      AppLogger.w('Error parsing versions for update check: $e');
      return false;
    }
  }
}
