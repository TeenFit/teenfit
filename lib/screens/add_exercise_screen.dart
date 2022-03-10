import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teenfit/widgets/exercise_types/sets_and_reps.dart';
import 'package:teenfit/widgets/exercise_types/time.dart';
import '../providers/exercise.dart';
import 'package:uuid/uuid.dart';

class AddExerciseScreen extends StatefulWidget {
  static const routeName = '/add-exercise-screen';

  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  var uuid = Uuid();
  bool isInit = false;
  bool isLoading = false;

  Map? exerciseProv;
  Exercise? newExercise;
  bool? switchOnOf;

  @override
  void didChangeDependencies() {
    exerciseProv = ModalRoute.of(context)!.settings.arguments as Map;

    if (isInit == false) {
      newExercise = exerciseProv!['exercise'];

      switchOnOf = newExercise!.timeSeconds == null ? false : true;

      // newExercise = Exercise(
      //   exerciseImageLink: newExercise!.exerciseImageLink,
      //   exerciseId: newExercise!.exerciseId,
      //   name: newExercise!.name,
      //   exerciseImage: newExercise!.exerciseImage,
      //   reps: newExercise!.reps,
      //   sets: newExercise!.sets,
      //   restTime: newExercise!.restTime,
      //   timeSeconds: newExercise!.timeSeconds,
      // );

      setState(() {
        isInit = true;
      });
    }

    super.didChangeDependencies();
  }

  // bool isNumeric(String? s) {
  //   if (s == null) {
  //     return false;
  //   }
  //   return int.tryParse(s) == null;
  // }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    bool isEdit = exerciseProv!['edit'];

    Widget buildSwitch() {
      return Center(
        child: Container(
          child: FlutterSwitch(
            width: _mediaQuery.size.width * 0.45,
            height: _mediaQuery.size.height * 0.06,
            valueFontSize: _mediaQuery.size.height * 0.03,
            toggleSize: _mediaQuery.size.height * 0.04,
            activeColor: _theme.primaryColor,
            inactiveColor: _theme.highlightColor,
            activeTextColor: Colors.white,
            inactiveTextColor: Colors.white,
            value: switchOnOf!,
            activeText: 'Time',
            inactiveText: 'Reps',
            borderRadius: 25,
            padding: 10,
            showOnOff: true,
            disabled: false,
            onToggle: (status) {
              setState(() {
                switchOnOf = status;
              });
            },
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: _theme.cardColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          isEdit ? 'Edit Your Exercise' : 'Add A Exercise',
          maxLines: 2,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontSize: _mediaQuery.size.height * 0.03,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        height: _mediaQuery.size.height - _appBarHeight,
        width: _mediaQuery.size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: (_mediaQuery.size.height - _appBarHeight) * 0.01,
              ),
              SizedBox(
                height: _mediaQuery.size.height * 0.03,
              ),
              buildSwitch(),
              SizedBox(
                height: _mediaQuery.size.height * 0.03,
              ),
              switchOnOf!
                  ? TimeExercise(exerciseProv)
                  : SetsAndReps(exerciseProv),
            ],
          ),
        ),
      ),
    );
  }
}
