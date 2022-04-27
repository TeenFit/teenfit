import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:teenfit/Custom/custom_dialog.dart';
import 'package:teenfit/providers/user.dart';
import 'package:teenfit/providers/userProv.dart';
import 'package:teenfit/screens/exercise_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:teenfit/screens/my_workouts.dart';

import '../providers/exercise.dart';
import '../providers/workouts.dart';
import '../widgets/exercise_tiles.dart';
import '../providers/workout.dart';
import 'create_workout.dart';

class WorkoutPage extends StatefulWidget {
  static const routeName = '/workout-page';

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  bool isInit = false;
  bool isDeletable = false;
  User? user;
  var prov;
  Workout? workout;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (isInit == false) {
      prov = ModalRoute.of(context)!.settings.arguments as Map;

      var workoutId = prov['workoutId'];

      if (workoutId != null) {
        var workoutDoc = await FirebaseFirestore.instance
            .collection('workouts')
            .doc(workoutId)
            .get();

        workout = Workout(
          views: workoutDoc.data()!['views'],
          searchTerms: workoutDoc.data()!['searchTerms'],
          failed: workoutDoc.data()!['failed'],
          pending: workoutDoc.data()!['pending'],
          date: DateTime.parse(workoutDoc.data()!['date']),
          creatorId: workoutDoc.data()!['creatorId'],
          workoutId: workoutDoc.data()!['workoutId'],
          workoutName: workoutDoc.data()!['workoutName'],
          bannerImage: null,
          bannerImageLink: workoutDoc.data()!['bannerImage'],
          exercises: (workoutDoc.data()!['exercises'] as List)
              .toList()
              .map(
                (e) => Exercise(
                  name2: e['name2'],
                  exerciseId: e['exerciseId'],
                  name: e['name'],
                  exerciseImageLink: e['exerciseImage'],
                  exerciseImageLink2: e['exerciseImage2'],
                  reps2: e['reps2'],
                  reps: e['reps'],
                  sets: e['sets'],
                  restTime: e['restTime'],
                  timeSeconds: e['timeSeconds'],
                ),
              )
              .toList(),
        );
      } else {
        workout = prov['workout'];
      }

      isDeletable = prov['isDeletable'];

      user = await Provider.of<UserProv>(context, listen: false)
          .fetchAUser(context, workout!.creatorId);

      setState(() {
        isInit = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    Widget _getFAB() {
      return SpeedDial(
        animatedIcon: AnimatedIcons.list_view,
        animatedIconTheme: IconThemeData(size: 22),
        backgroundColor: _theme.secondaryHeaderColor,
        visible: true,
        curve: Curves.bounceIn,
        children: [
          // FAB 1
          SpeedDialChild(
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              backgroundColor: _theme.secondaryHeaderColor,
              onTap: () {
                Navigator.of(context).pushNamed(AddWorkoutScreen.routeName,
                    arguments: {'workout': workout, 'isEdit': true});
              },
              label: 'Edit',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: _theme.secondaryHeaderColor),
          // FAB 2
          SpeedDialChild(
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              backgroundColor: _theme.secondaryHeaderColor,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => CustomDialogBox(
                      'Are You Sure?',
                      'This action will delete the workout and it can never be recoverd',
                      'assets/images/trash.png',
                      'pop',
                      workout),
                );
              },
              label: 'Delete',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: _theme.secondaryHeaderColor)
        ],
      );
    }

    return Scaffold(
      backgroundColor: _theme.primaryColor,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      floatingActionButton: isDeletable == true ? _getFAB() : SizedBox(),
      appBar: AppBar(
        actions: [
          SizedBox(
            width: _mediaQuery.size.width * 0.14,
          ),
          Container(
            width: _mediaQuery.size.width * 0.86,
            height: _appBarHeight,
            child: isInit == false
                ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      backgroundColor: _theme.shadowColor,
                      color: Colors.white,
                    ),
                  )
                : InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              CreateWorkout(true, user!.uid)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: _appBarHeight * 0.5,
                          width: _appBarHeight * 0.5,
                          child: user!.profilePic == null
                              ? Image.asset(
                                  'assets/images/no_profile_pic.png',
                                  fit: BoxFit.fitHeight,
                                )
                              : AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: ClipOval(
                                    child: FadeInImage(
                                        placeholder: AssetImage(
                                            'assets/images/loading-gif.gif'),
                                        placeholderErrorBuilder:
                                            (context, _, __) => Image.asset(
                                                  'assets/images/loading-gif.gif',
                                                  fit: BoxFit.contain,
                                                ),
                                        fit: BoxFit.contain,
                                        image: CachedNetworkImageProvider(
                                            user!.profilePic!),
                                        imageErrorBuilder: (image, _, __) =>
                                            Image.asset(
                                              'assets/images/ImageUploadError.png',
                                              fit: BoxFit.contain,
                                            )),
                                  ),
                                ),
                        ),
                        SizedBox(
                          width: _mediaQuery.size.width * 0.05,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: _appBarHeight,
                          width: _mediaQuery.size.width * 0.65,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              '@' + user!.name!,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: _appBarHeight * 0.23),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          )
        ],
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
      ),
      body: isInit == false
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                backgroundColor: _theme.shadowColor,
                color: Colors.white,
              ),
            )
          : Container(
              height: _mediaQuery.size.height,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: _mediaQuery.padding.top),
                      height: _mediaQuery.size.height * 0.35,
                      width: _mediaQuery.size.width,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          workout!.bannerImageLink == null
                              ? workout!.bannerImage == null
                                  ? Container(
                                      height: _mediaQuery.size.height * 0.35,
                                      width: _mediaQuery.size.width,
                                      child: Image.asset(
                                        'assets/images/BannerImageUnavailable.png',
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      height: _mediaQuery.size.height * 0.35,
                                      width: _mediaQuery.size.width,
                                      margin: EdgeInsets.zero,
                                      padding: EdgeInsets.zero,
                                      child: FadeInImage(
                                        placeholder: AssetImage(
                                            'assets/images/loading-gif.gif'),
                                        placeholderErrorBuilder:
                                            (context, _, __) => Image.asset(
                                          'assets/images/loading-gif.gif',
                                          fit: BoxFit.cover,
                                        ),
                                        image: FileImage(workout!.bannerImage!),
                                        fit: BoxFit.cover,
                                        imageErrorBuilder: (image, _, __) =>
                                            Image.asset(
                                          'assets/images/ImageUploadError.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    )
                              : FadeInImage(
                                  placeholder: AssetImage(
                                      'assets/images/loading-gif.gif'),
                                  placeholderErrorBuilder: (context, _, __) =>
                                      Image.asset(
                                    'assets/images/loading-gif.gif',
                                    fit: BoxFit.cover,
                                  ),
                                  image: CachedNetworkImageProvider(
                                      workout!.bannerImageLink!),
                                  fit: BoxFit.cover,
                                  imageErrorBuilder: (image, _, __) =>
                                      Image.asset(
                                    'assets/images/ImageUploadError.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Container(
                              height: _mediaQuery.size.height * 0.35,
                              width: _mediaQuery.size.width,
                              child: Container(
                                height: _mediaQuery.size.height * 0.28,
                                width: _mediaQuery.size.width,
                                child: Center(
                                  child: Text(
                                    workout!.workoutName,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      fontSize: _mediaQuery.size.height * 0.07,
                                      letterSpacing: 1,
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(2.5, 2.5),
                                          blurRadius: 1.0,
                                          color: Color.fromARGB(
                                              255, 128, 128, 128),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: _mediaQuery.size.width,
                        height: _mediaQuery.size.height * 0.05,
                        color: _theme.primaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.remove_red_eye,
                              color: Colors.black,
                              size: _mediaQuery.size.height * 0.04,
                            ),
                            SizedBox(
                              width: _mediaQuery.size.width * 0.04,
                            ),
                            Text(
                              workout!.views.toString(),
                              style: TextStyle(
                                  fontFamily: 'PTSans',
                                  fontSize: _mediaQuery.size.height * 0.02),
                            ),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Container(
                        height: _mediaQuery.size.height * 0.07,
                        width: _mediaQuery.size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              primary: _theme.secondaryHeaderColor),
                          child: Text(
                            'Start Workout',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PTSans',
                                fontSize: _mediaQuery.size.height * 0.035),
                          ),
                          onPressed: () async {
                            await Provider.of<Workouts>(context, listen: false)
                                .incrementView(workout!.creatorId,
                                    workout!.workoutId, context);
                            showDialog(
                                context: context,
                                builder: (ctx) => CustomDialogBox(
                                    'Are You Ready?',
                                    'Grab a water bottle, warmup, lets do this',
                                    'assets/images/water_bottle.jpg',
                                    ExerciseScreen.routeName,
                                    workout!.exercises));
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        height: _mediaQuery.size.height * 0.51,
                        width: _mediaQuery.size.width,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemBuilder: (ctx, index) => ExerciseTiles(
                            key: ValueKey(workout!.exercises[index].exerciseId),
                            exercise: workout!.exercises[index],
                            size: _mediaQuery.size.width,
                            isDeleteable: false,
                            addExercise: () {},
                            delete: () {},
                            updateExercise: () {},
                          ),
                          itemCount: workout!.exercises.length,
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
