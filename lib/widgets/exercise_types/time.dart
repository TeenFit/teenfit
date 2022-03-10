import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:teenfit/pickers/exercise_image_picker.dart';
import '/providers/exercise.dart';
import 'package:uuid/uuid.dart';

class TimeExercise extends StatefulWidget {
  final Map? exerciseProv;

  TimeExercise(this.exerciseProv);

  @override
  _TimeExerciseState createState() => _TimeExerciseState();
}

class _TimeExerciseState extends State<TimeExercise> {
  final _formKey10 = GlobalKey<FormState>();
  var uuid = Uuid();
  bool isInit = false;
  bool isLoading = false;
  int time = 5;
  int restTime = 5;

  Map? exerciseProv;
  Exercise? newExercise;
  Function? addExercise;
  Function? updateExercise;

  @override
  void didChangeDependencies() {
    exerciseProv = widget.exerciseProv;

    if (isInit == false) {
      newExercise = exerciseProv!['exercise'];

      time = newExercise!.timeSeconds != null ? newExercise!.timeSeconds! : 5;
      restTime = newExercise!.restTime != null ? newExercise!.restTime! : 5;

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

      setState(() {
        isInit = true;
      });
    }

    addExercise = exerciseProv!['addExercise'];

    updateExercise = exerciseProv!['updateExercise'];

    super.didChangeDependencies();
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
          newExercise = Exercise(
              exerciseId: newExercise!.exerciseId,
              name: newExercise!.name,
              exerciseImage: image,
              sets: newExercise!.sets,
              reps: newExercise!.reps,
              timeSeconds: newExercise!.timeSeconds,
              restTime: newExercise!.restTime,
              exerciseImageLink: newExercise!.exerciseImageLink);
        });
      } else if (video != null) {
        setState(() {
          newExercise = Exercise(
              exerciseId: newExercise!.exerciseId,
              name: newExercise!.name,
              exerciseImage: video,
              sets: newExercise!.sets,
              reps: newExercise!.reps,
              timeSeconds: newExercise!.timeSeconds,
              restTime: newExercise!.restTime,
              exerciseImageLink: newExercise!.exerciseImageLink);
        });
      }
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }

    Future<void> _submit() async {
      if (newExercise!.exerciseImage == null && isEdit == false) {
        _showToast('Image Required');
        return;
      }

      if (!_formKey10.currentState!.validate()) {
        _showToast('Failed Fields');
        return;
      }

      setState(() {
        isLoading = true;
      });

      _formKey10.currentState!.save();

      newExercise = Exercise(
        exerciseId: newExercise!.exerciseId,
        name: newExercise!.name,
        exerciseImage: newExercise!.exerciseImage,
        sets: null,
        reps: null,
        timeSeconds: time,
        restTime: restTime,
        exerciseImageLink: newExercise!.exerciseImageLink,
      );

      isEdit
          ? await updateExercise!(newExercise)
          : await addExercise!(newExercise);

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
              if (value.toString().trim().isEmpty) {
                return 'Name is Required';
              } else if (value == null) {
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
                  exerciseImageLink: newExercise!.exerciseImageLink);
            },
          ),
        ),
      );
    }

    Widget buildTime() {
      return Container(
        height: _mediaQuery.size.height * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: (_mediaQuery.size.height - _appBarHeight) * 0.32,
                width: _mediaQuery.size.width,
                child: Column(
                  children: [
                    Text(
                      'TIME',
                      style: TextStyle(
                        wordSpacing: 2,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: _mediaQuery.size.height * 0.02,
                    ),
                    NumberPicker(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(),
                      ),
                      value: time,
                      minValue: 5,
                      maxValue: 300,
                      step: 5,
                      onChanged: (value) => setState(() => time = value),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: (_mediaQuery.size.height - _appBarHeight) * 0.32,
                width: _mediaQuery.size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: _mediaQuery.size.height * 0.02,
                    ),
                    Text(
                      'REST TIME',
                      style: TextStyle(
                        wordSpacing: 2,
                        fontSize: 20,
                      ),
                    ),
                    NumberPicker(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(),
                      ),
                      value: restTime,
                      minValue: 5,
                      maxValue: 300,
                      step: 5,
                      onChanged: (value) => setState(() => restTime = value),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: _mediaQuery.size.height - _appBarHeight,
      width: _mediaQuery.size.width,
      child: Form(
        key: _formKey10,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: (_mediaQuery.size.height - _appBarHeight) * 0.01,
              ),
              ExerciseImagePicker(_pick, newExercise!.exerciseImageLink,
                  newExercise!.exerciseImage),
              buildExerciseName(),
              SizedBox(
                height: _mediaQuery.size.height * 0.03,
              ),
              buildTime(),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
