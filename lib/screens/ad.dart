import 'package:flutter/material.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:teenfit/screens/workout_page.dart';

class AdScreen extends StatelessWidget {
  static const routeName = '/ad-screen';

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    var arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      backgroundColor: _theme.cardColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .popAndPushNamed(WorkoutPage.routeName, arguments: arguments);
            },
            icon: Icon(
              Icons.close,
              color: _theme.highlightColor,
            ),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: _mediaQuery.size.height - _appBarHeight,
        width: _mediaQuery.size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: _mediaQuery.size.width * 0.5,
                height: (_mediaQuery.size.height - _appBarHeight) * 0.2,
                child: Text(
                  'Help Us To Help You For Free',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: _mediaQuery.size.height * 0.06,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                height: _mediaQuery.size.height - _appBarHeight * 0.7,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
