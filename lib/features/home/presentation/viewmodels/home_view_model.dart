/// **Architecture Layer**: Presentation (ViewModel)
/// **Purpose**: Manages the state and business logic for the Home Screen.

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:reestoko/core/services/ad_manager.dart';

class HomeViewModel extends ChangeNotifier {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  BannerAd? get bannerAd => _bannerAd;
  bool get isAdLoaded => _isAdLoaded;

  HomeViewModel() {
    _loadBannerAd();
  }

  void _loadBannerAd() {
    if (!AdManager().isSupported) return;

    _bannerAd = AdManager().createBannerAd(
      onAdLoaded: (ad) {
        _isAdLoaded = true;
        notifyListeners();
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
      },
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
