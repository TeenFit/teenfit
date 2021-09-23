import 'package:flutter/material.dart';
import '../providers/exercise.dart';

class ExerciseScreen extends StatelessWidget {
  static const routeName = '/exercise-screen';

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);
    final _statusBarHeight = _mediaQuery.padding.top;

    final List<Exercise> exercises =
        ModalRoute.of(context)!.settings.arguments as List<Exercise>;

    return Scaffold(
      backgroundColor: _theme.shadowColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
