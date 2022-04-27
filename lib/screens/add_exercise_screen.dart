import 'package:flutter/material.dart';
// import 'package:flutter_switch/flutter_switch.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:teenfit/widgets/exercise_types/sets_and_reps.dart';
import 'package:teenfit/widgets/exercise_types/super_set.dart';
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
  String? exerciseType;

  @override
  void didChangeDependencies() {
    exerciseProv = ModalRoute.of(context)!.settings.arguments as Map;

    if (isInit == false) {
      newExercise = exerciseProv!['exercise'];

      if (newExercise!.restTime != null) {
        exerciseType = 'Time';
      } else if (newExercise!.reps2 != null) {
        exerciseType = 'Superset';
      } else {
        exerciseType = 'Reps and Sets';
      }

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

    Widget buildDropDown() {
      return Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, bottom: 8.0, top: 0),
            child: DropdownButtonFormField2(
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              isExpanded: true,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 30,
              buttonHeight: 60,
              buttonPadding: const EdgeInsets.only(left: 20, right: 10),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              items: [
                DropdownMenuItem<String>(
                  value: 'Reps and Sets',
                  child: Text(
                    'Reps and Sets',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'Time',
                  child: Text(
                    'Time',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'Superset',
                  child: Text(
                    'Superset',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
              value: exerciseType,
              onChanged: (value) {
                setState(() {
                  exerciseType = value.toString();
                });
              },
            ),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: _theme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          isEdit ? 'Edit Your Exercise' : 'Add A Exercise',
          maxLines: 2,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.black,
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
              buildDropDown(),
              SizedBox(
                height: _mediaQuery.size.height * 0.03,
              ),
              exerciseType == 'Time'
                  ? TimeExercise(exerciseProv)
                  : exerciseType == 'Superset'
                      ? SuperSet(exerciseProv)
                      : SetsAndReps(exerciseProv),
              SizedBox(
                height: _mediaQuery.size.height * 0.3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
