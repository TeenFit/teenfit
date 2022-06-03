import 'dart:io';

import 'package:flutter/cupertino.dart';

class AdState with ChangeNotifier{

  String get interstitialAdUnit => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/8691691433'
      : 'ca-app-pub-3605247207313682/6959471110';

   String get interstitialAdUnit2 => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/8691691433'
      : 'ca-app-pub-3605247207313682/3164676581';

}
