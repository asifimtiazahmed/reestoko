/// **Architecture Layer**: Core / Services
/// **Purpose**: Cross-platform AdManager for Google Mobile Ads (Android & iOS).

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:reestoko/core/constants/app_constants.dart';
import 'package:reestoko/core/utils/app_logger.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  bool _isInitialized = false;

  /// Check if Google Mobile Ads are supported on current platform
  bool get isSupported {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Initialize the Google Mobile Ads SDK on supported mobile platforms.
  Future<void> init() async {
    if (!isSupported || _isInitialized) return;
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      AppLogger.i('AdManager initialized for mobile platform');
    } catch (e) {
      AppLogger.e('Failed to initialize AdManager', e);
    }
  }

  // ===========================================================================
  // Ad Unit IDs
  // ===========================================================================

  bool get _useTestIds => kDebugMode; // Switches to test IDs in debug mode

  String? get bannerAdUnitId {
    if (!isSupported) return null;
    if (Platform.isAndroid) {
      return _useTestIds ? AppConstants.testBannerIdAndroid : AppConstants.prodBannerIdAndroid;
    } else if (Platform.isIOS) {
      return _useTestIds ? AppConstants.testBannerIdiOS : AppConstants.prodBannerIdiOS;
    }
    return null;
  }

  String? get interstitialAdUnitId {
    if (!isSupported) return null;
    if (Platform.isAndroid) {
      return _useTestIds ? AppConstants.testInterstitialIdAndroid : AppConstants.prodInterstitialIdAndroid;
    } else if (Platform.isIOS) {
      return _useTestIds ? AppConstants.testInterstitialIdiOS : AppConstants.prodInterstitialIdiOS;
    }
    return null;
  }

  // ===========================================================================
  // Ad Loading Helper Methods
  // ===========================================================================

  BannerAd? createBannerAd({
    required Function(Ad) onAdLoaded,
    Function(Ad, LoadAdError)? onAdFailedToLoad,
  }) {
    final adUnitId = bannerAdUnitId;
    if (!isSupported || adUnitId == null) return null;

    return BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (onAdFailedToLoad != null) {
            onAdFailedToLoad(ad, error);
          }
          AppLogger.w('Banner ad failed to load: $error');
        },
      ),
    );
  }
}
