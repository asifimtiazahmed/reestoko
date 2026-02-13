import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:reestoko/constants/app_constants.dart';
import 'package:reestoko/utils/app_logger.dart';

class AdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  bool _isInitialized = false;

  /// Initialize the Google Mobile Ads SDK.
  Future<void> init() async {
    if (_isInitialized) return;
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      AppLogger.i('AdManager initialized');
    } catch (e) {
      AppLogger.e('Failed to initialize AdManager', e);
    }
  }

  // ===========================================================================
  // Ad Unit IDs
  // ===========================================================================

  bool get _useTestIds => kDebugMode; // Switches to test IDs in debug mode

  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return _useTestIds ? AppConstants.testBannerIdAndroid : AppConstants.prodBannerIdAndroid;
    } else if (Platform.isIOS) {
      return _useTestIds ? AppConstants.testBannerIdiOS : AppConstants.prodBannerIdiOS;
    }
    throw UnsupportedError("Unsupported platform");
  }

  String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return _useTestIds ? AppConstants.testInterstitialIdAndroid : AppConstants.prodInterstitialIdAndroid;
    } else if (Platform.isIOS) {
      return _useTestIds ? AppConstants.testInterstitialIdiOS : AppConstants.prodInterstitialIdiOS;
    }
    throw UnsupportedError("Unsupported platform");
  }

  // ===========================================================================
  // Ad Loading Helper Methods
  // ===========================================================================

  BannerAd createBannerAd({required Function(Ad) onAdLoaded, Function(Ad, LoadAdError)? onAdFailedToLoad}) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
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
