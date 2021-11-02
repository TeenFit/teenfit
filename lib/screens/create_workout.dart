import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
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

  List<Exercise>? exerciseEditList;

  @override
  void didChangeDependencies() {
    workoutProv = ModalRoute.of(context)!.settings.arguments;

    workout = workoutProv['workout'];
    isEdit = workoutProv['isEdit'];

    exerciseEditList =
        workout!.exercises == [] ? [] : workout!.exercises;

    newWorkout = Workout(
      date: workout!.date,
      creatorName: workout!.creatorName,
      creatorId: workout!.creatorId,
      workoutId: workout!.workoutId,
      workoutName: workout!.workoutName,
      instagram: workout!.instagram,
      facebook: workout!.facebook,
      tumblrPageLink: workout!.tumblrPageLink,
      bannerImage: workout!.bannerImage,
      exercises: exerciseEditList!,
    );

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
      setState(() {});
    }

    void addExercise(Exercise exercisE) {
      exerciseEditList!.insert(
        0,
        Exercise(
            exerciseId: exercisE.exerciseId,
            name: exercisE.name,
            exerciseImageLink: exercisE.exerciseImageLink,
            reps: exercisE.reps,
            sets: exercisE.sets,
            restTime: exercisE.restTime,
            timeSeconds: exercisE.timeSeconds),
      );

      Navigator.of(context).pop();
      setState(() {});
    }

    void updateExercise(Exercise exercisE) {
      int index = exerciseEditList!
          .indexWhere((element) => element.exerciseId == exercisE.exerciseId);
      exerciseEditList!.removeAt(index);
      exerciseEditList!.insert(index, exercisE);

      Navigator.of(context).pop();
      setState(() {});
    }

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

    Future<void> _submit() async {
      if (!_formKey3.currentState!.validate()) {
        return;
      }

      _formKey3.currentState!.save();

      newWorkout = Workout(
        date: newWorkout!.date,
        creatorName: newWorkout!.creatorName,
        creatorId: newWorkout!.creatorId,
        workoutId: newWorkout!.workoutId,
        workoutName: newWorkout!.workoutName,
        instagram: newWorkout!.instagram,
        facebook: newWorkout!.facebook,
        tumblrPageLink: newWorkout!.tumblrPageLink,
        bannerImage: newWorkout!.bannerImage,
        exercises: newWorkout!.exercises,
      );

      setState(() {
        _isLoading = true;
      });

      try {
        isEdit
            ? await Provider.of<Workouts>(context, listen: false)
                .updateWorkout(newWorkout!)
                .then((_) => Navigator.of(context).pop())
            : await Provider.of<Workouts>(context, listen: false)
                .addWorkout(newWorkout!)
                .then((_) => Navigator.of(context).pop());
      } catch (e) {
        _showToast('Unable To Add Workout');
      }

      setState(() {
        _isLoading = false;
      });
    }

    Widget buildAddImage() {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.4,
          width: _mediaQuery.size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: _mediaQuery.size.height * 0.28,
                  width: _mediaQuery.size.width,
                  child: Image.asset('assets/images/UploadImage.png')),
              Container(
                width: double.infinity,
                height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
                child: TextFormField(
                  initialValue: newWorkout!.bannerImage,
                  decoration: InputDecoration(
                    hintText: 'Image URL',
                    hintStyle:
                        TextStyle(fontSize: _mediaQuery.size.height * 0.02),
                  ),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    setState(() {});
                  },
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return 'URL is Required';
                    } else if (value.toString().contains(' ')) {
                      return 'Please Remove Spaces';
                    }
                    return null;
                  },
                  onSaved: (input) {
                    newWorkout = Workout(
                      date: newWorkout!.date,
                      creatorName: newWorkout!.creatorName,
                      creatorId: newWorkout!.creatorId,
                      workoutId: newWorkout!.workoutId,
                      workoutName: newWorkout!.workoutName,
                      instagram: newWorkout!.instagram,
                      facebook: newWorkout!.facebook,
                      tumblrPageLink: newWorkout!.tumblrPageLink,
                      bannerImage: input.toString(),
                      exercises: newWorkout!.exercises,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildCreatorName() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
          width: _mediaQuery.size.width,
          child: TextFormField(
            initialValue: workout!.creatorName,
            decoration: InputDecoration(
              hintText: 'Creator Name',
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
              } else if (value.toString().length > 10) {
                return 'Stay Under 10 Characters Please';
              }
              return null;
            },
            onSaved: (input) {
              newWorkout = Workout(
                date: newWorkout!.date,
                creatorName: input.toString(),
                creatorId: newWorkout!.creatorId,
                workoutId: newWorkout!.workoutId,
                workoutName: newWorkout!.workoutName,
                instagram: newWorkout!.instagram,
                facebook: newWorkout!.facebook,
                tumblrPageLink: newWorkout!.tumblrPageLink,
                bannerImage: newWorkout!.bannerImage,
                exercises: newWorkout!.exercises,
              );
            },
          ),
        ),
      );
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
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().isEmpty) {
                return 'Name is Required';
              } else if (value.toString().length > 25) {
                return 'Stay Under 25 Characters Please';
              }
              return null;
            },
            onSaved: (input) {
              newWorkout = Workout(
                date: newWorkout!.date,
                creatorName: newWorkout!.creatorName,
                creatorId: newWorkout!.creatorId,
                workoutId: newWorkout!.workoutId,
                workoutName: input.toString(),
                instagram: newWorkout!.instagram,
                facebook: newWorkout!.facebook,
                tumblrPageLink: newWorkout!.tumblrPageLink,
                bannerImage: newWorkout!.bannerImage,
                exercises: newWorkout!.exercises,
              );
            },
          ),
        ),
      );
    }

    Widget buildInstagramLink() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
          width: _mediaQuery.size.width,
          child: TextFormField(
            initialValue: workout!.instagram,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Instagram Link (optional)',
              hintStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
            ),
            style: TextStyle(
              fontSize: 20,
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().contains(' ')) {
                return 'Please Remove Spaces';
              }

              return null;
            },
            onSaved: (input) {
              newWorkout = Workout(
                date: newWorkout!.date,
                creatorName: newWorkout!.creatorName,
                creatorId: newWorkout!.creatorId,
                workoutId: newWorkout!.workoutId,
                workoutName: newWorkout!.workoutName,
                instagram: input.toString().isEmpty ? '' : input.toString(),
                facebook: newWorkout!.facebook,
                tumblrPageLink: newWorkout!.tumblrPageLink,
                bannerImage: newWorkout!.bannerImage,
                exercises: newWorkout!.exercises,
              );
            },
          ),
        ),
      );
    }

    Widget buildTumblrLink() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
          width: _mediaQuery.size.width,
          child: TextFormField(
            initialValue: workout!.tumblrPageLink,
            decoration: InputDecoration(
              hintText: 'Tumblr Link (optional)',
              hintStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
            ),
            style: TextStyle(
              fontSize: 20,
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().contains(' ')) {
                return 'Please Remove Spaces';
              }
              return null;
            },
            onSaved: (input) {
              newWorkout = Workout(
                date: newWorkout!.date,
                creatorName: newWorkout!.creatorName,
                creatorId: newWorkout!.creatorId,
                workoutId: newWorkout!.workoutId,
                workoutName: newWorkout!.workoutName,
                instagram: newWorkout!.instagram,
                facebook: newWorkout!.facebook,
                tumblrPageLink:
                    input.toString().isEmpty ? '' : input.toString(),
                bannerImage: newWorkout!.bannerImage,
                exercises: newWorkout!.exercises,
              );
            },
          ),
        ),
      );
    }

    Widget buildFacebookLink() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
          width: _mediaQuery.size.width,
          child: TextFormField(
            initialValue: workout!.facebook,
            decoration: InputDecoration(
              hintText: 'Facebook Link (Optional)',
              hintStyle: TextStyle(fontSize: _mediaQuery.size.height * 0.02),
            ),
            style: TextStyle(
              fontSize: 20,
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value.toString().contains(' ')) {
                return 'Please Remove Spaces';
              }
              return null;
            },
            onSaved: (input) {
              newWorkout = Workout(
                date: newWorkout!.date,
                creatorName: newWorkout!.creatorName,
                creatorId: newWorkout!.creatorId,
                workoutId: newWorkout!.workoutId,
                workoutName: newWorkout!.workoutName,
                instagram: newWorkout!.instagram,
                facebook: input.toString().isEmpty ? '' : input.toString(),
                tumblrPageLink: newWorkout!.tumblrPageLink,
                bannerImage: newWorkout!.bannerImage,
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
                      primary: _theme.cardColor,
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
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AddExerciseScreen.routeName,
                        arguments: {
                          'addExercise': addExercise,
                          'updateExercise': updateExercise,
                          'edit': false,
                          'exercise': Exercise(
                            exerciseId: uuid.v1(),
                            name: '',
                            reps: null,
                            sets: null,
                            timeSeconds: null,
                            restTime: null,
                            exerciseImageLink: '',
                          ),
                        },
                      );
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
                    color: _theme.cardColor,
                    width: 10,
                  ),
                ),
                child: ListView.builder(
                  itemBuilder: (ctx, index) => ExerciseTiles(
                    isDeleteable: true,
                    addExercise: addExercise,
                    updateExercise: updateExercise,
                    delete: deleteExercise,
                    exercise: newWorkout!.exercises[index],
                    size: _mediaQuery.size.width * 0.9,
                  ),
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
      backgroundColor: _theme.highlightColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          isEdit ? 'Edit A Workout' : 'Create A Workout',
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
          key: _formKey3,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: (_mediaQuery.size.height - _appBarHeight) * 0.01,
                ),
                buildAddImage(),
                buildCreatorName(),
                buildWorkoutName(),
                buildInstagramLink(),
                buildTumblrLink(),
                buildFacebookLink(),
                buildAddExercises(),
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
