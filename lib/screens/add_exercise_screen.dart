import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teenfit/pickers/exercise_image_picker.dart';

import '../providers/exercise.dart';
import 'package:uuid/uuid.dart';

class AddExerciseScreen extends StatefulWidget {
  static const routeName = '/add-exercise-screen';

  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _formKey4 = GlobalKey<FormState>();
  var uuid = Uuid();
  bool isInit = false;

  Map? exerciseProv;
  Exercise? newExercise;
  bool? switchOnOf;
  Function? addExercise;
  Function? updateExercise;

  @override
  void didChangeDependencies() {
    exerciseProv = ModalRoute.of(context)!.settings.arguments as Map;

    if (isInit == false) {
      newExercise = exerciseProv!['exercise'];

      newExercise = Exercise(
        exerciseImageLink: newExercise!.exerciseImageLink,
        exerciseId: newExercise!.exerciseId,
        name: newExercise!.name,
        exerciseImage: newExercise!.exerciseImage,
        reps: newExercise!.reps,
        sets: newExercise!.sets,
        restTime: newExercise!.restTime,
        timeSeconds: newExercise!.timeSeconds,
      );

      switchOnOf = newExercise!.timeSeconds == null ? false : true;

      setState(() {
        isInit = true;
      });
    }

    addExercise = exerciseProv!['addExercise'];

    updateExercise = exerciseProv!['updateExercise'];

    super.didChangeDependencies();
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) == null;
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    bool isEdit = exerciseProv!['edit'];

    void _showToast(String msg) {
      Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 10,
        webShowClose: true,
        textColor: Colors.white,
        backgroundColor: Colors.grey.shade700,
      );
    }

    void _pickImage(File? image) {
      setState(() {
        newExercise = Exercise(
            exerciseId: newExercise!.exerciseId,
            name: newExercise!.name,
            exerciseImage: image,
            sets: null,
            reps: null,
            timeSeconds: newExercise!.timeSeconds,
            restTime: newExercise!.restTime,
            exerciseImageLink: newExercise!.exerciseImageLink);
      });
    }

    Future<void> _submit() async {
      if (newExercise!.exerciseImage == null && isEdit == false) {
        _showToast('Image Required');
        return;
      }

      if (!_formKey4.currentState!.validate()) {
        return;
      }

      _formKey4.currentState!.save();

      newExercise = switchOnOf!
          ? Exercise(
              exerciseId: newExercise!.exerciseId,
              name: newExercise!.name,
              exerciseImage: newExercise!.exerciseImage,
              sets: null,
              reps: null,
              timeSeconds: newExercise!.timeSeconds,
              restTime: newExercise!.restTime,
              exerciseImageLink: newExercise!.exerciseImageLink)
          : Exercise(
              exerciseId: newExercise!.exerciseId,
              name: newExercise!.name,
              exerciseImage: newExercise!.exerciseImage,
              sets: newExercise!.sets,
              reps: newExercise!.reps,
              timeSeconds: null,
              restTime: null,
              exerciseImageLink: newExercise!.exerciseImageLink);

      isEdit ? updateExercise!(newExercise) : addExercise!(newExercise);
    }

    Widget buildAddImage(File? exerciseImage, String? exerciseImageLink) {
      return ExerciseImagePicker(_pickImage, exerciseImageLink, exerciseImage);
    }

    Widget buildExerciseName() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
          width: _mediaQuery.size.width,
          child: TextFormField(
            initialValue: newExercise!.name,
            decoration: InputDecoration(
              hintText: 'Exercise Name',
              hintStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
            ),
            style: TextStyle(
              fontSize: 20,
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().isEmpty) {
                return 'Name is Required';
              }
              return null;
            },
            onSaved: (input) {
              newExercise = Exercise(
                exerciseId: newExercise!.exerciseId,
                name: input.toString().trim(),
                timeSeconds: newExercise!.timeSeconds,
                restTime: newExercise!.restTime,
                sets: newExercise!.sets,
                reps: newExercise!.reps,
                exerciseImage: newExercise!.exerciseImage,
                exerciseImageLink: newExercise!.exerciseImageLink
              );
            },
          ),
        ),
      );
    }

    Widget buildSwitch() {
      return Center(
        child: Container(
          child: FlutterSwitch(
            width: _mediaQuery.size.width * 0.45,
            height: _mediaQuery.size.height * 0.06,
            valueFontSize: _mediaQuery.size.height * 0.03,
            toggleSize: _mediaQuery.size.height * 0.04,
            activeColor: _theme.primaryColor,
            inactiveColor: _theme.shadowColor,
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

    Widget buildRepsOrTime() {
      return switchOnOf!
          ? Container(
              height: _mediaQuery.size.height * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
                      width: _mediaQuery.size.width,
                      child: TextFormField(
                        initialValue: newExercise!.timeSeconds == null
                            ? ''
                            : newExercise!.timeSeconds.toString(),
                        decoration: InputDecoration(
                          hintText: 'Exercise Time (sec)',
                          hintStyle: TextStyle(
                              fontSize: _mediaQuery.size.height * 0.02),
                        ),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'Needs A Value';
                          } else if (isNumeric(value.toString())) {
                            return 'Numbers Only';
                          } else if (int.parse(value.toString()) == 0) {
                            return 'Must be greater';
                          } else if (int.parse(value.toString()) >= 301) {
                            return '300 seconds is max';
                          }
                          return null;
                        },
                        onSaved: (input) {
                          newExercise = Exercise(
                            exerciseId: newExercise!.exerciseId,
                            name: newExercise!.name,
                            timeSeconds: input.toString().isEmpty
                                ? null
                                : int.parse(input.toString().trim()),
                            restTime: newExercise!.restTime,
                            sets: newExercise!.sets,
                            reps: newExercise!.reps,
                            exerciseImage: newExercise!.exerciseImage,
                            exerciseImageLink: newExercise!.exerciseImageLink
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
                      width: _mediaQuery.size.width,
                      child: TextFormField(
                        initialValue: newExercise!.restTime == null
                            ? ''
                            : newExercise!.restTime.toString(),
                        decoration: InputDecoration(
                          hintText: 'Rest Time (sec)',
                          hintStyle: TextStyle(
                              fontSize: _mediaQuery.size.height * 0.02),
                        ),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'Needs A Value';
                          } else if (isNumeric(value.toString())) {
                            return 'Numbers Only';
                          } else if (int.parse(value.toString()) == 0) {
                            return 'Must be greater';
                          } else if (int.parse(value.toString()) >= 151) {
                            return '150 seconds is max';
                          }
                          return null;
                        },
                        onSaved: (input) {
                          newExercise = Exercise(
                            exerciseId: newExercise!.exerciseId,
                            name: newExercise!.name,
                            timeSeconds: newExercise!.timeSeconds,
                            restTime: input.toString().isEmpty
                                ? null
                                : int.parse(input.toString().trim()),
                            sets: newExercise!.sets,
                            reps: newExercise!.reps,
                            exerciseImage: newExercise!.exerciseImage,
                            exerciseImageLink: newExercise!.exerciseImageLink
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              height: _mediaQuery.size.height * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
                      width: _mediaQuery.size.width,
                      child: TextFormField(
                        initialValue: newExercise!.sets == null
                            ? ''
                            : newExercise!.sets.toString(),
                        decoration: InputDecoration(
                          hintText: 'Sets',
                          hintStyle: TextStyle(
                              fontSize: _mediaQuery.size.height * 0.02),
                        ),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'Needs A Value';
                          } else if (isNumeric(value.toString())) {
                            return 'Numbers Only';
                          } else if (int.parse(value.toString().trim()) == 0) {
                            return 'Must be greater';
                          } else if (int.parse(value.toString().trim()) >= 11) {
                            return '10 sets is max';
                          }
                          return null;
                        },
                        onSaved: (input) {
                          newExercise = Exercise(
                            exerciseId: newExercise!.exerciseId,
                            name: newExercise!.name,
                            timeSeconds: newExercise!.timeSeconds,
                            restTime: newExercise!.restTime,
                            sets: input.toString().isEmpty
                                ? null
                                : int.parse(input.toString().trim()),
                            reps: newExercise!.reps,
                            exerciseImage: newExercise!.exerciseImage,
                            exerciseImageLink: newExercise!.exerciseImageLink
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
                      width: _mediaQuery.size.width,
                      child: TextFormField(
                        initialValue: newExercise!.reps == null
                            ? ''
                            : newExercise!.reps.toString(),
                        decoration: InputDecoration(
                          hintText: 'Reps',
                          hintStyle: TextStyle(
                              fontSize: _mediaQuery.size.height * 0.02),
                        ),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'Needs A Value';
                          } else if (isNumeric(value.toString().trim())) {
                            return 'Numbers Only';
                          } else if (int.parse(value.toString().trim()) == 0) {
                            return 'Must be greater';
                          } else if (int.parse(value.toString().trim()) >= 26) {
                            return '25 reps is max';
                          }
                          return null;
                        },
                        onSaved: (input) {
                          newExercise = Exercise(
                            exerciseId: newExercise!.exerciseId,
                            name: newExercise!.name,
                            timeSeconds: newExercise!.timeSeconds,
                            restTime: newExercise!.restTime,
                            sets: newExercise!.sets,
                            reps: input.toString().isEmpty
                                ? null
                                : int.parse(input.toString().trim()),
                            exerciseImage: newExercise!.exerciseImage,
                            exerciseImageLink: newExercise!.exerciseImageLink
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                buildAddImage(
                    newExercise!.exerciseImage, newExercise!.exerciseImageLink),
                buildExerciseName(),
                SizedBox(
                  height: _mediaQuery.size.height * 0.03,
                ),
                buildSwitch(),
                buildRepsOrTime(),
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
                      onPressed: () {
                        _submit();
                      },
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
