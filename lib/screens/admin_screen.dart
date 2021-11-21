import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  static const routeName = '/admin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
// use same format as my workouts page but create a new field in workout tiles called is Admin, which will allow the
// admin to view different controls, one is accept, and the other is deny with a message,
