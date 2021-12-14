import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:teenfit/pickers/exercise_image_picker.dart';
import 'package:video_trimmer/video_trimmer.dart';

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
  bool isLoading = false;
  int reps = 5;
  int sets = 5;
  int time = 5;
  int restTime = 5;

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

      switchOnOf = newExercise!.timeSeconds == null ? false : true;

      reps = newExercise!.reps != null ? newExercise!.reps! : 5;
      sets = newExercise!.sets != null ? newExercise!.sets! : 5;
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
        final Trimmer _trimmer = Trimmer();
        await _trimmer.loadVideo(videoFile: video);

        await _trimmer.saveTrimmedVideo(
          onSave: (value) async {
            setState(() {
              newExercise = Exercise(
                  exerciseId: newExercise!.exerciseId,
                  name: newExercise!.name,
                  exerciseImage: File(value.toString()),
                  sets: newExercise!.sets,
                  reps: newExercise!.reps,
                  timeSeconds: newExercise!.timeSeconds,
                  restTime: newExercise!.restTime,
                  exerciseImageLink: newExercise!.exerciseImageLink);
            });
          },
          videoFileName: DateTime.now().toString(),
          videoFolderName: 'Workout-Gifs',
          storageDir: StorageDir.temporaryDirectory,
          startValue: 0,
          endValue: 5000,
          outputFormat: FileFormat.gif,
          fpsGIF: 8,
          scaleGIF: 380,
        );

        _trimmer.dispose();
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

      if (!_formKey4.currentState!.validate()) {
        return;
      }

      setState(() {
        isLoading = true;
      });

      _formKey4.currentState!.save();

      newExercise = switchOnOf!
          ? Exercise(
              exerciseId: newExercise!.exerciseId,
              name: newExercise!.name,
              exerciseImage: newExercise!.exerciseImage,
              sets: null,
              reps: null,
              timeSeconds: time,
              restTime: restTime,
              exerciseImageLink: newExercise!.exerciseImageLink)
          : Exercise(
              exerciseId: newExercise!.exerciseId,
              name: newExercise!.name,
              exerciseImage: newExercise!.exerciseImage,
              sets: sets,
              reps: reps,
              timeSeconds: null,
              restTime: null,
              exerciseImageLink: newExercise!.exerciseImageLink);

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

    Widget buildRepsOrTime() {
      return switchOnOf!
          ? Container(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              border: Border.all(),
                            ),
                            value: restTime,
                            minValue: 5,
                            maxValue: 300,
                            step: 5,
                            onChanged: (value) =>
                                setState(() => restTime = value),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
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
                          SizedBox(
                            height: _mediaQuery.size.height * 0.02,
                          ),
                          Text(
                            'SETS',
                            style: TextStyle(
                              wordSpacing: 2,
                              fontSize: 20,
                            ),
                          ),
                          NumberPicker(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              border: Border.all(),
                            ),
                            value: sets,
                            minValue: 5,
                            maxValue: 300,
                            step: 5,
                            onChanged: (value) => setState(() => sets = value),
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
                            'REPS',
                            style: TextStyle(
                              wordSpacing: 2,
                              fontSize: 20,
                            ),
                          ),
                          NumberPicker(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              border: Border.all(),
                            ),
                            value: reps,
                            minValue: 5,
                            maxValue: 300,
                            step: 5,
                            onChanged: (value) => setState(() => reps = value),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
        child: Form(
          key: _formKey4,
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
      ),
    );
  }
}
