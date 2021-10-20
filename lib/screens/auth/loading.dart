import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: _mediaQuery.size.height,
        width: _mediaQuery.size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: _mediaQuery.size.height,
              width: _mediaQuery.size.width,
              child: Image.asset(
                'assets/images/LoadingBackground.png',
                fit: BoxFit.cover,
              ),
            ),
            CircularProgressIndicator(
              strokeWidth: 4,
              backgroundColor: _theme.shadowColor,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
