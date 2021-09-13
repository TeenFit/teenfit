import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    return Drawer(
      child: Container(
        height: _mediaQuery.size.height - _appBarHieght,
        width: double.infinity,
        color: _theme.accentColor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: (_mediaQuery.size.height - _appBarHieght) * 0.25,
                child: Image.asset(
                  'assets/images/teen_fit_logo_withtext_white.png',
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  width: double.infinity,
                  height: (_mediaQuery.size.height - _appBarHieght) * 0.075,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: _theme.highlightColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {},
                    child: Text('Create A Workout'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
