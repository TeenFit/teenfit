import 'package:flutter/material.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:teenfit/screens/exercise_screen.dart';

class AdScreen extends StatefulWidget {
  static const routeName = '/ad-screen';

  @override
  State<AdScreen> createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  bool isInit = false;

  @override
  void didChangeDependencies() {
    if (isInit == false) {
      Future.delayed(Duration(milliseconds: 1500));
      if (this.mounted) {
        setState(() {
          isInit = true;
        });
      }
    }
    super.didChangeDependencies();
  }

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
        leading: isInit == false
            ? SizedBox()
            : IconButton(
                onPressed: () {
                  Navigator.of(context).popAndPushNamed(
                      ExerciseScreen.routeName,
                      arguments: arguments);
                },
                icon: Icon(
                  Icons.close,
                  color: _theme.highlightColor,
                  size: _appBarHeight * 0.5,
                ),
              ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: _mediaQuery.size.height - _appBarHeight * 0.9,
        width: _mediaQuery.size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: _mediaQuery.size.width * 0.6,
                height: (_mediaQuery.size.height - _appBarHeight) * 0.25,
                child: Text(
                  'This ad helps keep workouts free',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: _mediaQuery.size.height * 0.03,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                height: _mediaQuery.size.height - _appBarHeight * 0.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
