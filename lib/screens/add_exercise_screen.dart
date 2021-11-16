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
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  var uuid = Uuid();

  Map? exerciseProv;
  Exercise? newExercise;
  bool? switchOnOf;
  Function? addExercise;
  Function? updateExercise;
  File? exerciseImagePhoto;

  @override
  void didChangeDependencies() {
    exerciseProv = ModalRoute.of(context)!.settings.arguments as Map;

    newExercise = exerciseProv!['exercise'];

    newExercise = Exercise(
      exerciseId: newExercise!.exerciseId,
      name: newExercise!.name,
      exerciseImage: exerciseImagePhoto,
      reps: newExercise!.reps,
      sets: newExercise!.sets,
      restTime: newExercise!.restTime,
      timeSeconds: newExercise!.timeSeconds,
    );

    addExercise = exerciseProv!['addExercise'];

    updateExercise = exerciseProv!['updateExercise'];

    switchOnOf = newExercise!.timeSeconds == null ? false : true;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
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
      exerciseImagePhoto = image;
    }

    Future<void> _submit() async {
      if (newExercise!.exerciseImage == null ||
          newExercise!.exerciseImage!.path.isEmpty) {
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
              exerciseImage: exerciseImagePhoto,
              sets: null,
              reps: null,
              timeSeconds: newExercise!.timeSeconds,
              restTime: newExercise!.restTime,
            )
          : Exercise(
              exerciseId: newExercise!.exerciseId,
              name: newExercise!.name,
              exerciseImage: exerciseImagePhoto,
              sets: newExercise!.sets,
              reps: newExercise!.reps,
              timeSeconds: null,
              restTime: null,
            );

      isEdit ? updateExercise!(newExercise) : addExercise!(newExercise);
    }

    Widget buildAddImage() {
      return ExerciseImagePicker(_pickImage, newExercise!.exerciseImageLink);
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
                buildAddImage(),
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
