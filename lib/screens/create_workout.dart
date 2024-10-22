import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/Custom/custom_dialog.dart';
import 'package:teenfit/pickers/workout_image_picker.dart';
import 'package:uuid/uuid.dart';

import '../screens/add_exercise_screen.dart';
import '../providers/exercise.dart';
import '../widgets/exercise_tiles.dart';
import '../providers/workouts.dart';
import '../providers/workout.dart';

class AddWorkoutScreen extends StatefulWidget {
  static const routeName = '/add-workout-screen';

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _formKey3 = GlobalKey<FormState>();
  var uuid = Uuid();
  Workout? newWorkout;
  Workout? workout;
  bool isEdit = false;
  var workoutProv;
  bool _isLoading = false;
  bool isInit = false;

  List<Exercise>? exerciseEditList;

  @override
  void didChangeDependencies() async {
    workoutProv = ModalRoute.of(context)!.settings.arguments;

    workout = workoutProv['workout'];
    isEdit = workoutProv['isEdit'];

    exerciseEditList = workout!.exercises == [] ? [] : workout!.exercises;

    if (isInit == false) {
      newWorkout = Workout(
  
        views: workout!.views,
        searchTerms: workout!.searchTerms,
        failed: false,
        pending: true,
        date: workout!.date,
        creatorId: workout!.creatorId,
        workoutId: workout!.workoutId,
        workoutName: workout!.workoutName,
        bannerImage: workout!.bannerImage,
        bannerImageLink: workout!.bannerImageLink,
        exercises: exerciseEditList!,
      );

      setState(() {
        isInit = true;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    void deleteExercise(String exerciseId) {
      exerciseEditList!
          .removeWhere((exercise) => exercise.exerciseId == exerciseId);
      Navigator.of(context).pop();

      if (this.mounted) {
        setState(() {});
      }
    }

    void addExercise(Exercise exercisE) {
      exerciseEditList!.add(
        Exercise(
            name2: exercisE.name2,
            exerciseImage2: exercisE.exerciseImage2,
            exerciseImageLink2: exercisE.exerciseImageLink2,
            reps2: exercisE.reps2,
            exerciseImageLink: exercisE.exerciseImageLink,
            exerciseId: exercisE.exerciseId,
            name: exercisE.name,
            exerciseImage: exercisE.exerciseImage,
            reps: exercisE.reps,
            sets: exercisE.sets,
            restTime: exercisE.restTime,
            timeSeconds: exercisE.timeSeconds),
      );

      setState(() {});
    }

    void updateExercise(Exercise exercisE) {
      int index = exerciseEditList!
          .indexWhere((element) => element.exerciseId == exercisE.exerciseId);
      exerciseEditList!.removeAt(index);
      exerciseEditList!.insert(index, exercisE);

      if (this.mounted) {
        setState(() {});
      }
    }

    void _pickImage(File? image) {
      setState(() {
        newWorkout = Workout(
       
          views: workout!.views,
          searchTerms: workout!.searchTerms,
          failed: false,
          pending: true,
          date: workout!.date,
          creatorId: workout!.creatorId,
          workoutId: workout!.workoutId,
          workoutName: workout!.workoutName,
          bannerImage: image,
          bannerImageLink: workout!.bannerImageLink,
          exercises: exerciseEditList!,
        );
      });
    }

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

    Future<void> _submit() async {
      if (!_formKey3.currentState!.validate()) {
        _showToast('Failed Fields');
        return;
      }
      if (newWorkout!.bannerImage == null && isEdit == false) {
        _showToast('An Image is Required');
        return;
      }

      if (exerciseEditList!.length < 1) {
        _showToast('A Minnimum Of 3 Exercises Is Required');
        return;
      }

      if (exerciseEditList!.length > 12) {
        _showToast('Maximum Of 12 Exercises');
      }

      _formKey3.currentState!.save();

      newWorkout = Workout(

        views: newWorkout!.views,
        failed: false,
        searchTerms: newWorkout!.searchTerms,
        pending: newWorkout!.pending,
        date: newWorkout!.date,
        creatorId: newWorkout!.creatorId,
        workoutId: newWorkout!.workoutId,
        workoutName: newWorkout!.workoutName,
        bannerImage: newWorkout!.bannerImage,
        bannerImageLink: newWorkout!.bannerImageLink,
        exercises: newWorkout!.exercises,
      );

      setState(() {
        _isLoading = true;
      });

      try {
        isEdit
            ? await Provider.of<Workouts>(context, listen: false)
                .updateWorkout(newWorkout!)
            : await Provider.of<Workouts>(context, listen: false)
                .addWorkout(newWorkout!);

        Navigator.of(context).pop();
      } catch (e) {
        _showToast('Unable To Add Workout Try Again Later');
      }

      List<Exercise> deleteFiles = newWorkout!.exercises
          .where(
            (element) => (element.exerciseImage != null &&
                element.exerciseImage!.path.contains('Workout-Gifs')),
          )
          .toList();

      deleteFiles.forEach((e) async {
        await e.exerciseImage!.delete();
      });

      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    Widget buildWorkoutName() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
          width: _mediaQuery.size.width,
          child: TextFormField(
            initialValue: workout!.workoutName,
            decoration: InputDecoration(
              hintText: 'Workout Name',
              hintStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
            ),
            style: TextStyle(
              fontSize: 20,
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().trim().isEmpty) {
                return 'Name is Required';
              } else if (value.toString().trim().length > 25) {
                return 'Stay Under 25 Characters Please';
              }
              return null;
            },
            onSaved: (input) {
              newWorkout = Workout(

                views: newWorkout!.views,
                searchTerms: newWorkout!.searchTerms,
                failed: false,
                pending: newWorkout!.pending,
                date: newWorkout!.date,
                creatorId: newWorkout!.creatorId,
                workoutId: newWorkout!.workoutId,
                workoutName: input.toString().trim(),
                bannerImage: newWorkout!.bannerImage,
                bannerImageLink: newWorkout!.bannerImageLink,
                exercises: newWorkout!.exercises,
              );
            },
          ),
        ),
      );
    }

   

    Widget buildAddExercises() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Container(
          height: _mediaQuery.size.height * 0.7,
          width: _mediaQuery.size.width,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    0, 0, 0, _mediaQuery.size.height * 0.01),
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
                    child: Text(
                      'Add Exercise',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w900,
                        fontSize: _mediaQuery.size.height * 0.03,
                      ),
                    ),
                    onPressed: _isLoading == true
                        ? () {}
                        : () {
                            if (exerciseEditList!.length < 12) {
                              Navigator.of(context).pushNamed(
                                AddExerciseScreen.routeName,
                                arguments: {
                                  'addExercise': addExercise,
                                  'updateExercise': updateExercise,
                                  'edit': false,
                                  'exercise': Exercise(
                                    name2: null,
                                    exerciseId: uuid.v1(),
                                    name: '',
                                    reps: null,
                                    sets: null,
                                    timeSeconds: null,
                                    restTime: null,
                                    exerciseImage: null,
                                    exerciseImageLink: null,
                                    exerciseImage2: null,
                                    exerciseImageLink2: null,
                                    reps2: null,
                                  ),
                                },
                              );
                            } else {
                              _showToast('Maximum 12 Exercises');
                            }
                          },
                  ),
                ),
              ),
              Container(
                height: _mediaQuery.size.height * 0.6,
                width: _mediaQuery.size.width,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: _theme.highlightColor,
                    width: 10,
                  ),
                ),
                child: ReorderableListView.builder(
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex = newIndex - 1;
                      }
                      final element = exerciseEditList!.removeAt(oldIndex);
                      exerciseEditList!.insert(newIndex, element);
                    });
                  },
                  itemBuilder: (ctx, index) {
                    final String id = exerciseEditList![index].exerciseId;

                    return ExerciseTiles(
                      key: ValueKey(id),
                      isDeleteable: true,
                      addExercise: _isLoading == true ? () {} : addExercise,
                      updateExercise:
                          _isLoading == true ? () {} : updateExercise,
                      delete: _isLoading == true ? () {} : deleteExercise,
                      exercise: Exercise(
                        name2: newWorkout!.exercises[index].name2,
                        exerciseImage2:
                            newWorkout!.exercises[index].exerciseImage2,
                        exerciseImageLink2:
                            newWorkout!.exercises[index].exerciseImageLink2,
                        reps2: newWorkout!.exercises[index].reps2,
                        exerciseId: newWorkout!.exercises[index].exerciseId,
                        name: newWorkout!.exercises[index].name,
                        exerciseImage:
                            newWorkout!.exercises[index].exerciseImage,
                        exerciseImageLink:
                            newWorkout!.exercises[index].exerciseImageLink,
                        reps: newWorkout!.exercises[index].reps,
                        sets: newWorkout!.exercises[index].sets,
                        restTime: newWorkout!.exercises[index].restTime,
                        timeSeconds: newWorkout!.exercises[index].timeSeconds,
                      ),
                      size: _mediaQuery.size.width * 0.9,
                    );
                  },
                  itemCount: newWorkout!.exercises.length,
                ),
              ),
            ],
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
          isEdit ? 'Edit A Workout' : 'Create A Workout',
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
        child: Form(
          key: _formKey3,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: (_mediaQuery.size.height - _appBarHeight) * 0.01,
                ),
                WorkoutImagePicker(
                    _pickImage, workout!.bannerImageLink, workout!.bannerImage),
                buildWorkoutName(),
                buildAddExercises(),
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
                      child: _isLoading
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
                      onPressed: _isLoading == true
                          ? () {}
                          : () {
                              isEdit
                                  ? showDialog(
                                      context: context,
                                      builder: (context) => CustomDialogBox(
                                          'Updating Workout...',
                                          'When you update a workout it will be pending again are you okay with that?',
                                          'assets/images/teen_fit_logo_white_withpeople_withbackground.png',
                                          'pending',
                                          _submit))
                                  : _submit();
                            },
                    ),
                  ),
                ),
                SizedBox(
                  height: _mediaQuery.size.height * 0.08,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
