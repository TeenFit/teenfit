import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../providers/exercise.dart';

class AddExerciseScreen extends StatefulWidget {
  static const routeName = '/add-exercise-screen';

  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _formKey4 = GlobalKey<FormState>();
  var uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    Map exerciseProv = ModalRoute.of(context)!.settings.arguments as Map;

    List<Exercise>? exercises = exerciseProv['exercises'];
    bool isEdit = exerciseProv['edit'];
    Exercise? _exercise = exerciseProv['exercise'];

    Exercise exercise = isEdit
        ? Exercise(
            exerciseId: _exercise!.exerciseId,
            name: _exercise.name,
            timeSeconds: _exercise.timeSeconds,
            restTime: _exercise.restTime,
            exerciseImageLink: _exercise.exerciseImageLink)
        : Exercise(
            exerciseId: uuid.v1(),
            name: '',
            timeSeconds: 0,
            restTime: 0,
            exerciseImageLink: '',
          );

    void addExercise() {
      exercises!.insert(0, exercise);
      Navigator.of(context).pop();
    }

    Widget buildExerciseName() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
          width: _mediaQuery.size.width,
          child: TextFormField(
            initialValue: isEdit ? _exercise!.name : '',
            decoration: InputDecoration(
              hintText: 'Exercise Name',
              hintStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
            ),
            style: TextStyle(
              fontSize: 20,
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().isEmpty) {
                return 'Name is Required';
              }
              return null;
            },
            onSaved: (input) {
              exercise = Exercise(
                  exerciseId: exercise.exerciseId,
                  name: input.toString(),
                  timeSeconds: exercise.timeSeconds,
                  restTime: exercise.restTime,
                  exerciseImageLink: exercise.exerciseImageLink);
            },
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _theme.highlightColor,
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
        child: Form(
          key: _formKey4,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: (_mediaQuery.size.height - _appBarHeight) * 0.01,
                ),
                buildExerciseName(),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: _mediaQuery.size.width,
                    height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: _theme.primaryColor,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w900,
                          fontSize: _mediaQuery.size.height * 0.03,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
