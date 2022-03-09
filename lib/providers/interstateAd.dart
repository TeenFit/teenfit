import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:teenfit/screens/exercise_screen.dart';

class AdmobHelper {
  InterstitialAd? _interstitialAd;

  int numofattemptload = 0;

  // create interstitial ads
  Future<void> createInterad() async {
    await InterstitialAd.load(
      adUnitId: 'ca-app-pub-3605247207313682/6959471110',
      request: AdRequest(),
      adLoadCallback:
          InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
        _interstitialAd = ad;
        numofattemptload = 0;
      }, onAdFailedToLoad: (LoadAdError error) {
        numofattemptload++;
        _interstitialAd = null;

        if (numofattemptload <= 2) {
          createInterad();
        }
      }),
    );
  }

// show interstitial ads to user
  Future<void> showInterad(BuildContext context, arguments) async {
    if (_interstitialAd == null) {
      Navigator.of(context)
          .pushNamed(ExerciseScreen.routeName, arguments: arguments);
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
      print("ad onAdshowedFullscreen");

      FirebaseAnalytics.instance.logAdImpression();
    }, onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print("ad Disposed");
      ad.dispose();

      Navigator.of(context)
          .pushNamed(ExerciseScreen.routeName, arguments: arguments);
    }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError aderror) {
      print('$ad OnAdFailed $aderror');
      ad.dispose();
      Navigator.of(context)
          .pushNamed(ExerciseScreen.routeName, arguments: arguments);
    });

    await _interstitialAd!.show();

    _interstitialAd = null;
  }
}
