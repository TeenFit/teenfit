import 'package:flutter/material.dart';
import 'package:teenfit/widgets/main_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _theme.primaryColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            color: Colors.white,
            iconSize: _mediaQuery.size.height * 0.08,
            icon: Icon(Icons.menu_rounded),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: MainDrawer(),
      backgroundColor: _theme.primaryColor,
    );
  }
}
