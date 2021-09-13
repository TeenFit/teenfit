import 'package:flutter/material.dart';
import 'package:teenfit/widgets/main_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      drawer: MainDrawer(),
    );
  }
}
