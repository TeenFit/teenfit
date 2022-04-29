import 'package:flutter/material.dart';

class LoggingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _theme.primaryColor,
    );
  }
}
