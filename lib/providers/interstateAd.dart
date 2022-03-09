import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:teenfit/screens/exercise_screen.dart';

class AdmobHelper {
  InterstitialAd? interstitialAd;

  int numofattemptload = 0;

  // create interstitial ads
  Future<void> createInterad() async {
    await MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        testDeviceIds: [
          '115733308bd2f2a218053cbfc69aa606',
          'kGADSimulatorID'
        ]));

    await InterstitialAd.load(
      // adUnitId: 'ca-app-pub-3605247207313682/6959471110',
      // adUnitId: InterstitialAd.testAdUnitId,
      adUnitId: 'ca-app-pub-3940256099942544/4411468910',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd adInter) {
          interstitialAd = adInter;
          numofattemptload = 0;
        },
        onAdFailedToLoad: (LoadAdError error) async {
          numofattemptload++;
          interstitialAd = null;
          if (numofattemptload <= 2) {
            await createInterad();
          }
        },
      ),
    );
  }

// show interstitial ads to user
  Future<void> showInterad(context, arguments) async {
    if (interstitialAd == null) {
      Navigator.of(context)
          .pushNamed(ExerciseScreen.routeName, arguments: arguments);
      return;
    }

    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
      print("ad onAdshowedFullscreen");

      // FirebaseAnalytics.instance.logAdImpression();
    }, onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print("ad Disposed");
      interstitialAd = null;

      ad.dispose();

      Navigator.of(context)
          .pushNamed(ExerciseScreen.routeName, arguments: arguments);
    }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError aderror) {
      print('$ad OnAdFailed $aderror');
      interstitialAd = null;

      ad.dispose();

      Navigator.of(context)
          .pushNamed(ExerciseScreen.routeName, arguments: arguments);
    }, onAdImpression: (InterstitialAd ad) {
      print('ad impression');
    });

    await interstitialAd!.show();

    Navigator.of(context)
        .pushNamed(ExerciseScreen.routeName, arguments: arguments);
  }
}
