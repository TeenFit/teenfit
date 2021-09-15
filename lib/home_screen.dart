import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:teenfit/widgets/main_drawer.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    return Scaffold(
      drawer: MainDrawer(),
      backgroundColor: _theme.primaryColor,
    );
  }
}
