import 'dart:io';

import 'package:flutter/cupertino.dart';

class AdState with ChangeNotifier{

  String get interstitialAdUnit => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/8691691433'
      : 'ca-app-pub-3940256099942544/5135589807';

   String get interstitialAdUnit2 => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/8691691433'
      : 'ca-app-pub-3940256099942544/5135589807';

}
