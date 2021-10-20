import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: _mediaQuery.size.height,
        width: _mediaQuery.size.width,
        child: Image.asset(
          'assets/images/ErrorScreen.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
