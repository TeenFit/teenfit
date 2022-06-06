import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class AdState with ChangeNotifier {
  late InterstitialAd _interstitialAd;
  bool _isAdLoaded = false;

  String get interstitialAdUnit => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/8691691433'
      : 'ca-app-pub-3605247207313682/6959471110';

  String get interstitialAdUnit2 => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/8691691433'
      : 'ca-app-pub-3605247207313682/3164676581';

  InterstitialAd get interstitialAd {
    return _interstitialAd;
  }

  bool get isAdLoaded {
    return _isAdLoaded;
  }

  Future<void> initAd(context) async {
    await InterstitialAd.load(
      adUnitId: interstitialAdUnit2,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void onAdLoaded(InterstitialAd ad) {
    print('AdLoaded');
    _interstitialAd = ad;
    _isAdLoaded = true;

    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('onAdDismissedFullScreenContent.');
        _interstitialAd.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('onAdFailedToShowFullScreenContent');
        _interstitialAd.dispose();
      },
    );

    notifyListeners();
  }
}
