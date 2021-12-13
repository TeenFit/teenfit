import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:teenfit/Custom/http_execption.dart';

class AdmobHelper with ChangeNotifier {
  InterstitialAd? _interstitialAd;

  // create interstitial ads
  Future<void> createInterad() async {
    await InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/4411468910',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          return;
        },
        onAdFailedToLoad: (LoadAdError error) {
          throw HttpException('Failed');
        },
      ),
    );
  }

// show interstitial ads to user
  Future<void> showInterad() async {
    if (_interstitialAd == null) {
      throw HttpException('Failed');
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
      print("ad onAdshowedFullscreen");
    }, onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print("ad Disposed");
      _interstitialAd = null;
      ad.dispose();
    }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError aderror) {
      print('$ad OnAdFailed $aderror');
      _interstitialAd = null;
      ad.dispose();
    });

    await _interstitialAd!.show();
  }
}
