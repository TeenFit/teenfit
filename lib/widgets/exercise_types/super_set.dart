import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:teenfit/pickers/exercise_image_picker.dart';
import '/providers/exercise.dart';
import 'package:uuid/uuid.dart';

class SuperSet extends StatefulWidget {
  final Map? exerciseProv;

  SuperSet(
    this.exerciseProv,
  );

  @override
  _SuperSetState createState() => _SuperSetState();
}

class _SuperSetState extends State<SuperSet> {
  final _formKey4 = GlobalKey<FormState>();
  var uuid = Uuid();
  bool isInit = false;
  bool isLoading = false;
  int reps2 = 5;
  int reps = 5;
  int sets = 1;

  Map? _exerciseProv;
  Exercise? _newExercise;
  Function? _addExercise;
  Function? _updateExercise;

  @override
  void didChangeDependencies() {
    _exerciseProv = widget.exerciseProv;

    if (isInit == false) {
      _newExercise = _exerciseProv!['exercise'];

      reps = _newExercise!.reps != null ? _newExercise!.reps! : 5;
      reps2 = _newExercise!.reps2 != null ? _newExercise!.reps2! : 5;
      sets = _newExercise!.sets != null ? _newExercise!.sets! : 5;

      _newExercise = Exercise(
        name2: _newExercise!.name2,
        exerciseImage2: _newExercise!.exerciseImage2,
        exerciseImageLink2: _newExercise!.exerciseImageLink2,
        reps2: _newExercise!.reps2,
        exerciseImageLink: _newExercise!.exerciseImageLink,
        exerciseId: _newExercise!.exerciseId,
        name: _newExercise!.name,
        exerciseImage: _newExercise!.exerciseImage,
        reps: _newExercise!.reps,
        sets: _newExercise!.sets,
        restTime: _newExercise!.restTime,
        timeSeconds: _newExercise!.timeSeconds,
      );

      setState(() {
        isInit = true;
      });
    }

    _addExercise = _exerciseProv!['addExercise'];

    _updateExercise = _exerciseProv!['updateExercise'];

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    bool isEdit = _exerciseProv!['edit'];

    void _showToast(String msg) {
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        msg: msg,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 10,
        webShowClose: true,
        textColor: Colors.white,
        backgroundColor: Colors.grey.shade700,
      );
    }

    Future<void> _pick(File? image, File? video) async {
      setState(() {
        isLoading = true;
      });
      if (image != null) {
        setState(() {
          _newExercise = Exercise(
              name2: _newExercise!.name2,
              exerciseImage2: _newExercise!.exerciseImage2,
              exerciseImageLink2: _newExercise!.exerciseImageLink2,
              reps2: _newExercise!.reps2,
              exerciseId: _newExercise!.exerciseId,
              name: _newExercise!.name,
              exerciseImage: image,
              sets: _newExercise!.sets,
              reps: _newExercise!.reps,
              timeSeconds: _newExercise!.timeSeconds,
              restTime: _newExercise!.restTime,
              exerciseImageLink: _newExercise!.exerciseImageLink);
        });
      } else if (video != null) {
        setState(() {
          _newExercise = Exercise(
              name2: _newExercise!.name2,
              exerciseImage2: _newExercise!.exerciseImage2,
              exerciseImageLink2: _newExercise!.exerciseImageLink2,
              reps2: _newExercise!.reps2,
              exerciseId: _newExercise!.exerciseId,
              name: _newExercise!.name,
              exerciseImage: video,
              sets: _newExercise!.sets,
              reps: _newExercise!.reps,
              timeSeconds: _newExercise!.timeSeconds,
              restTime: _newExercise!.restTime,
              exerciseImageLink: _newExercise!.exerciseImageLink);
        });
      }
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }

    Future<void> _pick2(File? image2, File? video2) async {
      setState(() {
        isLoading = true;
      });
      if (image2 != null) {
        setState(() {
          _newExercise = Exercise(
              name2: _newExercise!.name2,
              exerciseImage2: image2,
              exerciseImageLink2: _newExercise!.exerciseImageLink2,
              reps2: _newExercise!.reps2,
              exerciseId: _newExercise!.exerciseId,
              name: _newExercise!.name,
              exerciseImage: _newExercise!.exerciseImage,
              sets: _newExercise!.sets,
              reps: _newExercise!.reps,
              timeSeconds: _newExercise!.timeSeconds,
              restTime: _newExercise!.restTime,
              exerciseImageLink: _newExercise!.exerciseImageLink);
        });
      } else if (video2 != null) {
        setState(() {
          _newExercise = Exercise(
              name2: _newExercise!.name2,
              exerciseImage2: video2,
              exerciseImageLink2: _newExercise!.exerciseImageLink2,
              reps2: _newExercise!.reps2,
              exerciseId: _newExercise!.exerciseId,
              name: _newExercise!.name,
              exerciseImage: _newExercise!.exerciseImage,
              sets: _newExercise!.sets,
              reps: _newExercise!.reps,
              timeSeconds: _newExercise!.timeSeconds,
              restTime: _newExercise!.restTime,
              exerciseImageLink: _newExercise!.exerciseImageLink);
        });
      }
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }

    void removeImage() {
      setState(() {
        _newExercise = Exercise(
            name2: _newExercise!.name2,
            exerciseImage2: _newExercise!.exerciseImage2,
            exerciseImageLink2: _newExercise!.exerciseImageLink2,
            reps2: _newExercise!.reps2,
            exerciseId: _newExercise!.exerciseId,
            name: _newExercise!.name,
            exerciseImage: null,
            sets: _newExercise!.sets,
            reps: _newExercise!.reps,
            timeSeconds: _newExercise!.timeSeconds,
            restTime: _newExercise!.restTime,
            exerciseImageLink: null);
      });
    }

    void removeImage2() {
      setState(() {
        _newExercise = Exercise(
            name2: _newExercise!.name2,
            exerciseImage2: null,
            exerciseImageLink2: null,
            reps2: _newExercise!.reps2,
            exerciseId: _newExercise!.exerciseId,
            name: _newExercise!.name,
            exerciseImage: _newExercise!.exerciseImage,
            sets: _newExercise!.sets,
            reps: _newExercise!.reps,
            timeSeconds: _newExercise!.timeSeconds,
            restTime: _newExercise!.restTime,
            exerciseImageLink: _newExercise!.exerciseImageLink);
      });
    }

    Future<void> _submit() async {
      if (!_formKey4.currentState!.validate()) {
        _showToast('Failed Fields');
        return;
      }

      setState(() {
        isLoading = true;
      });

      _formKey4.currentState!.save();

      _newExercise = Exercise(
          name2: _newExercise!.name2,
          exerciseId: _newExercise!.exerciseId,
          name: _newExercise!.name,
          exerciseImage: _newExercise!.exerciseImage,
          sets: sets,
          reps: reps,
          timeSeconds: null,
          restTime: null,
          exerciseImage2: _newExercise!.exerciseImage2,
          exerciseImageLink2: _newExercise!.exerciseImageLink2,
          reps2: reps2,
          exerciseImageLink: _newExercise!.exerciseImageLink);

      isEdit
          ? await _updateExercise!(_newExercise)
          : await _addExercise!(_newExercise);

      Navigator.of(context).pop();

      if (this.mounted) {
        setState(() {
          isLoading = true;
        });
      }
    }

    Widget buildExerciseName() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
          width: _mediaQuery.size.width,
          child: TextFormField(
            initialValue: _newExercise!.name,
            decoration: InputDecoration(
              hintText: 'Exercise Name 1',
              hintStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
            ),
            style: TextStyle(
              fontSize: 20,
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().trim().isEmpty) {
                return 'Name is Required';
              } else if (value == null) {
                return 'Name is Required';
              }
              return null;
            },
            onSaved: (input) {
              _newExercise = Exercise(
                  name2: _newExercise!.name2,
                  exerciseImage2: _newExercise!.exerciseImage2,
                  exerciseImageLink2: _newExercise!.exerciseImageLink2,
                  reps2: _newExercise!.reps2,
                  exerciseId: _newExercise!.exerciseId,
                  name: input.toString().trim(),
                  timeSeconds: _newExercise!.timeSeconds,
                  restTime: _newExercise!.restTime,
                  sets: _newExercise!.sets,
                  reps: _newExercise!.reps,
                  exerciseImage: _newExercise!.exerciseImage,
                  exerciseImageLink: _newExercise!.exerciseImageLink);
            },
          ),
        ),
      );
    }

    Widget buildExerciseName2() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
          width: _mediaQuery.size.width,
          child: TextFormField(
            initialValue: _newExercise!.name2,
            decoration: InputDecoration(
              hintText: 'Exercise 2 Name',
              hintStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
            ),
            style: TextStyle(
              fontSize: 20,
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().trim().isEmpty) {
                return 'Name is Required';
              } else if (value == null) {
                return 'Name is Required';
              }
              return null;
            },
            onSaved: (input) {
              _newExercise = Exercise(
                  name2: input.toString().trim(),
                  exerciseImage2: _newExercise!.exerciseImage2,
                  exerciseImageLink2: _newExercise!.exerciseImageLink2,
                  reps2: _newExercise!.reps2,
                  exerciseId: _newExercise!.exerciseId,
                  name: _newExercise!.name,
                  timeSeconds: _newExercise!.timeSeconds,
                  restTime: _newExercise!.restTime,
                  sets: _newExercise!.sets,
                  reps: _newExercise!.reps,
                  exerciseImage: _newExercise!.exerciseImage,
                  exerciseImageLink: _newExercise!.exerciseImageLink);
            },
          ),
        ),
      );
    }

    Widget buildSets() {
      return Container(
        height: _mediaQuery.size.height * 0.2,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Container(
              height: (_mediaQuery.size.height - _appBarHeight) * 0.32,
              width: _mediaQuery.size.width,
              child: Column(
                children: [
                  Text(
                    'SETS',
                    style: TextStyle(
                      wordSpacing: 2,
                      fontSize: 20,
                    ),
                  ),
                  NumberPicker(
                    axis: Axis.horizontal,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      border: Border.all(),
                    ),
                    value: sets,
                    minValue: 1,
                    maxValue: 10,
                    step: 1,
                    onChanged: (value) => setState(() => sets = value),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget buildReps() {
      return Container(
        height: _mediaQuery.size.height * 0.2,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Container(
              height: (_mediaQuery.size.height - _appBarHeight) * 0.32,
              width: _mediaQuery.size.width,
              child: Column(
                children: [
                  Text(
                    'REPS',
                    style: TextStyle(
                      wordSpacing: 2,
                      fontSize: 20,
                    ),
                  ),
                  NumberPicker(
                    axis: Axis.horizontal,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      border: Border.all(),
                    ),
                    value: reps,
                    minValue: 5,
                    maxValue: 25,
                    step: 1,
                    onChanged: (value) => setState(() => reps = value),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget buildReps2() {
      return Container(
        height: _mediaQuery.size.height * 0.2,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Container(
              height: (_mediaQuery.size.height - _appBarHeight) * 0.32,
              width: _mediaQuery.size.width,
              child: Column(
                children: [
                  Text(
                    'REPS 2',
                    style: TextStyle(
                      wordSpacing: 2,
                      fontSize: 20,
                    ),
                  ),
                  NumberPicker(
                    axis: Axis.horizontal,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      border: Border.all(),
                    ),
                    value: reps2,
                    minValue: 5,
                    maxValue: 25,
                    step: 1,
                    onChanged: (value) => setState(() => reps2 = value),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      height: (_mediaQuery.size.height - _appBarHeight) * 0.77,
      width: _mediaQuery.size.width,
      child: Form(
        key: _formKey4,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: (_mediaQuery.size.height - _appBarHeight) * 0.01,
              ),
              buildSets(),
              ExerciseImagePicker(
                  _pick,
                  null,
                  _newExercise!.exerciseImageLink,
                  _newExercise!.exerciseImage,
                  false,
                  removeImage,
                  removeImage2),
              buildExerciseName(),
              SizedBox(
                height: _mediaQuery.size.height * 0.03,
              ),
              buildReps(),
              ExerciseImagePicker(
                  _pick,
                  _pick2,
                  _newExercise!.exerciseImageLink2,
                  _newExercise!.exerciseImage2,
                  true,
                  removeImage,
                  removeImage2),
              buildExerciseName2(),
              SizedBox(
                height: _mediaQuery.size.height * 0.03,
              ),
              buildReps2(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: _mediaQuery.size.width,
                  height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: _theme.secondaryHeaderColor,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                            strokeWidth: 4,
                            backgroundColor: _theme.shadowColor,
                            color: Colors.white,
                          )
                        : Text(
                            'Submit',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w900,
                              fontSize: _mediaQuery.size.height * 0.03,
                            ),
                          ),
                    onPressed: isLoading
                        ? () {}
                        : () async {
                            await _submit();
                          },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
