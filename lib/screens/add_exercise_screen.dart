import 'package:flutter/material.dart';
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
  List<Exercise>? exercises;
  Map? exerciseProv;

  Exercise? _exercise;
  Exercise? exercise;

  @override
  void didChangeDependencies() {
    exerciseProv = ModalRoute.of(context)!.settings.arguments as Map;

    exercises = exerciseProv!['exercises'];

    _exercise = exerciseProv!['exercise'];

    exercise = exerciseProv!['edit']
        ? Exercise(
            exerciseId: _exercise!.exerciseId,
            name: _exercise!.name,
            timeSeconds: _exercise!.timeSeconds,
            restTime: _exercise!.restTime,
            exerciseImageLink: _imageUrlController.text =
                _exercise!.exerciseImageLink,
          )
        : Exercise(
            exerciseId: uuid.v1(),
            name: '',
            reps: null,
            sets: null,
            timeSeconds: null,
            restTime: null,
            exerciseImageLink: '',
          );
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

    bool isEdit = exerciseProv!['edit'];

    void addExercise() {
      exercises!.insert(0, exercise!);
      Navigator.of(context).pop();
    }

    void updateExercise() {
      int index =
          exercises!.indexWhere((element) => element.exerciseId == exercise!.exerciseId);
      exercises!.removeAt(index);
      exercises!.insert(index, exercise!);
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
                child: isEdit == false
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
                  initialValue: isEdit ? _exercise!.exerciseImageLink : '',
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
                    exercise = Exercise(
                      exerciseId: exercise!.exerciseId,
                      name: exercise!.name,
                      timeSeconds: exercise!.timeSeconds,
                      restTime: exercise!.restTime,
                      exerciseImageLink: input.toString(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
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
                exerciseId: exercise!.exerciseId,
                name: input.toString(),
                timeSeconds: exercise!.timeSeconds,
                restTime: exercise!.restTime,
                exerciseImageLink: exercise!.exerciseImageLink,
              );
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
                buildAddImage(),
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
