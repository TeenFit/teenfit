import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _theme.secondaryHeaderColor,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          height: _mediaQuery.size.width * 0.5,
          width: _mediaQuery.size.width * 0.5,
          child: Image.asset(
            'assets/images/teen_fit_logo_white_withpeople 1@3x.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
