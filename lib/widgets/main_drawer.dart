import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: (_mediaQuery.size.height - _appBarHieght) * 0.1,
          ),
          Container(
            width: double.infinity,
            height: (_mediaQuery.size.height - _appBarHieght) * 0.25,
            child:
                Image.asset('assets/images/teen_fit_logo_withtext_white.png'),
          )
        ],
      ),
    );
  }
}
