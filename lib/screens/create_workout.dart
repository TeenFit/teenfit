import 'package:flutter/material.dart';
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
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  var uuid = Uuid();
  Workout? newWorkout;
  Workout? workout;
  bool isEdit = false;
  var workoutProv;

  List<Exercise>? exerciseEditList;

  @override
  void didChangeDependencies() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    workoutProv = ModalRoute.of(context)!.settings.arguments;

    workout = workoutProv['workout'];
    isEdit = workoutProv['isEdit'];

    newWorkout = Workout(
      creatorName: workout!.creatorName,
      creatorId: workout!.creatorId,
      workoutId: workout!.workoutId,
      workoutName: workout!.workoutName,
      instagram: workout!.instagram,
      facebook: workout!.facebook,
      tumblrPageLink: workout!.tumblrPageLink,
      bannerImage: _imageUrlController.text = workout!.bannerImage,
      exercises: workout!.exercises,
    );

    exerciseEditList = [...newWorkout!.exercises];

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

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    void deleteExercise(String exerciseId) {
      exerciseEditList!
          .removeWhere((exercise) => exercise.exerciseId == exerciseId);
      setState(() {});
    }

    void addExercise(Exercise exercise) {
      exerciseEditList!.add(exercise);
      setState(() {});
      Navigator.of(context).pop();
    }

    void updateExercise(Exercise exercise) {
      int index = exerciseEditList!
          .indexWhere((element) => element.exerciseId == exercise.exerciseId);
      exerciseEditList!.removeAt(index);
      exerciseEditList!.insert(index, exercise);
      setState(() {});
      Navigator.of(context).pop();
    }

    Future<void> _submit() async {
      if (!_formKey3.currentState!.validate()) {
        return;
      }

      _formKey3.currentState!.save();

      newWorkout = Workout(
        creatorName: newWorkout!.creatorName,
        creatorId: newWorkout!.creatorId,
        workoutId: newWorkout!.workoutId,
        workoutName: newWorkout!.workoutName,
        instagram: newWorkout!.instagram,
        facebook: newWorkout!.facebook,
        tumblrPageLink: newWorkout!.tumblrPageLink,
        bannerImage: newWorkout!.bannerImage,
        exercises: exerciseEditList!,
      );

      isEdit
          ? await Provider.of<Workouts>(context, listen: false)
              .updateWorkout(newWorkout!)
              .then((_) => Navigator.of(context).pop())
          : await Provider.of<Workouts>(context, listen: false)
              .addWorkout(newWorkout!)
              .then((_) => Navigator.of(context).pop());
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
                child: _imageUrlController.text.isEmpty
                    ? Image.asset('assets/images/UploadImage.png')
                    : FadeInImage(
                        image: NetworkImage(_imageUrlController.text),
                        placeholderErrorBuilder: (context, _, __) =>
                            Image.asset(
                          'assets/images/loading-gif.gif',
                          fit: BoxFit.cover,
                        ),
                        imageErrorBuilder: (context, image, stackTrace) =>
                            Image.asset(
                          'assets/images/ImageUploadError.png',
                          fit: BoxFit.cover,
                        ),
                        placeholder:
                            AssetImage('assets/images/loading-gif.gif'),
                        fit: BoxFit.contain,
                      ),
              ),
              Container(
                width: double.infinity,
                height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
                child: TextFormField(
                  initialValue: workout!.bannerImage,
                  focusNode: _imageUrlFocusNode,
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
                      creatorName: newWorkout!.creatorName,
                      creatorId: newWorkout!.creatorId,
                      workoutId: newWorkout!.workoutId,
                      workoutName: newWorkout!.workoutName,
                      instagram: newWorkout!.instagram,
                      facebook: newWorkout!.facebook,
                      tumblrPageLink: newWorkout!.tumblrPageLink,
                      bannerImage: input.toString(),
                      exercises: exerciseEditList!,
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
              }
              return null;
            },
            onSaved: (input) {
              newWorkout = Workout(
                creatorName: input.toString(),
                creatorId: newWorkout!.creatorId,
                workoutId: newWorkout!.workoutId,
                workoutName: newWorkout!.workoutName,
                instagram: newWorkout!.instagram,
                facebook: newWorkout!.facebook,
                tumblrPageLink: newWorkout!.tumblrPageLink,
                bannerImage: newWorkout!.bannerImage,
                exercises: exerciseEditList!,
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
              }
              return null;
            },
            onSaved: (input) {
              newWorkout = Workout(
                creatorName: newWorkout!.creatorName,
                creatorId: newWorkout!.creatorId,
                workoutId: newWorkout!.workoutId,
                workoutName: input.toString(),
                instagram: newWorkout!.instagram,
                facebook: newWorkout!.facebook,
                tumblrPageLink: newWorkout!.tumblrPageLink,
                bannerImage: newWorkout!.bannerImage,
                exercises: exerciseEditList!,
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
                creatorName: newWorkout!.creatorName,
                creatorId: newWorkout!.creatorId,
                workoutId: newWorkout!.workoutId,
                workoutName: newWorkout!.workoutName,
                instagram: input.toString(),
                facebook: newWorkout!.facebook,
                tumblrPageLink: newWorkout!.tumblrPageLink,
                bannerImage: newWorkout!.bannerImage,
                exercises: exerciseEditList!,
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
                creatorName: newWorkout!.creatorName,
                creatorId: newWorkout!.creatorId,
                workoutId: newWorkout!.workoutId,
                workoutName: newWorkout!.workoutName,
                instagram: newWorkout!.instagram,
                facebook: newWorkout!.facebook,
                tumblrPageLink: input.toString(),
                bannerImage: newWorkout!.bannerImage,
                exercises: exerciseEditList!,
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
                creatorName: newWorkout!.creatorName,
                creatorId: newWorkout!.creatorId,
                workoutId: newWorkout!.workoutId,
                workoutName: newWorkout!.workoutName,
                instagram: newWorkout!.instagram,
                facebook: input.toString(),
                tumblrPageLink: newWorkout!.tumblrPageLink,
                bannerImage: newWorkout!.bannerImage,
                exercises: exerciseEditList!,
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
                            reps: 0,
                            sets: 0,
                            timeSeconds: 0,
                            restTime: 0,
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
                    exerciseEditList![index],
                    _mediaQuery.size.width * 0.9,
                    true,
                    deleteExercise,
                    addExercise,
                    updateExercise,
                  ),
                  itemCount: exerciseEditList!.length,
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
