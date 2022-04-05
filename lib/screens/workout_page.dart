import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/Custom/custom_dialog.dart';
import 'package:teenfit/screens/exercise_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/workouts.dart';
import '../widgets/exercise_tiles.dart';
import '../Custom/my_flutter_app_icons.dart';
import '../providers/workout.dart';

class WorkoutPage extends StatelessWidget {
  static const routeName = '/workout-page';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);
    final _statusBarHeight = _mediaQuery.padding.top;

    final Workout workout =
        ModalRoute.of(context)!.settings.arguments as Workout;

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

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: _theme.primaryColor,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: _mediaQuery.size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: _mediaQuery.size.height * 0.35,
              width: _mediaQuery.size.width,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  workout.bannerImageLink == null
                      ? workout.bannerImage == null
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
                              child: FadeInImage(
                                placeholder:
                                    AssetImage('assets/images/loading-gif.gif'),
                                placeholderErrorBuilder: (context, _, __) =>
                                    Image.asset(
                                  'assets/images/loading-gif.gif',
                                  fit: BoxFit.cover,
                                ),
                                image: FileImage(workout.bannerImage!),
                                fit: BoxFit.fill,
                                imageErrorBuilder: (image, _, __) =>
                                    Image.asset(
                                  'assets/images/ImageUploadError.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                      : FadeInImage(
                          placeholder:
                              AssetImage('assets/images/loading-gif.gif'),
                          placeholderErrorBuilder: (context, _, __) =>
                              Image.asset(
                            'assets/images/loading-gif.gif',
                            fit: BoxFit.cover,
                          ),
                          image: CachedNetworkImageProvider(
                              workout.bannerImageLink!),
                          fit: BoxFit.fill,
                          imageErrorBuilder: (image, _, __) => Image.asset(
                            'assets/images/ImageUploadError.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                  FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: _mediaQuery.size.height * 0.35,
                          width: _mediaQuery.size.width * 0.1,
                          child: Column(
                            children: [
                              SizedBox(
                                height: _statusBarHeight,
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.arrow_back),
                                iconSize: _appBarHeight * 0.55,
                                color: Colors.white,
                              ),
                              SizedBox()
                            ],
                          ),
                        ),
                        Container(
                          height: _mediaQuery.size.height * 0.35,
                          width: _mediaQuery.size.width * 0.9,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: _statusBarHeight,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  _mediaQuery.size.width * 0.02,
                                  0,
                                  _mediaQuery.size.width * 0.03,
                                  _mediaQuery.size.width * 0.008,
                                ),
                                child: Text(
                                  workout.workoutName,
                                  maxLines: 2,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontSize: _mediaQuery.size.height * 0.055,
                                    letterSpacing: 1,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(2.5, 2.5),
                                        blurRadius: 1.0,
                                        color:
                                            Color.fromARGB(255, 128, 128, 128),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                width: _mediaQuery.size.width,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    _mediaQuery.size.width * 0.02,
                                    0,
                                    _mediaQuery.size.width * 0.03,
                                    _mediaQuery.size.width * 0.008,
                                  ),
                                  child: Text(
                                    'by: ${workout.creatorName}',
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PTSans',
                                      fontSize: _mediaQuery.size.height * 0.045,
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
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 2),
                                child: Container(
                                  height: (_mediaQuery.size.height -
                                          _appBarHeight) *
                                      0.13,
                                  width: _mediaQuery.size.width * 0.55,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        workout.instagram.isEmpty
                                            ? SizedBox()
                                            : IconButton(
                                                onPressed: () {
                                                  try {
                                                    launch(workout.instagram)
                                                        .catchError((e) {
                                                      _showToast(
                                                          'Link Not Available');
                                                    });
                                                  } catch (e) {
                                                    _showToast(
                                                        'Link Not Available');
                                                  }
                                                },
                                                icon: Icon(
                                                  MyFlutterApp.instagram_1,
                                                  size:
                                                      _mediaQuery.size.height *
                                                          0.045,
                                                  color: Colors.red,
                                                ),
                                              ),
                                        workout.facebook.isEmpty
                                            ? SizedBox()
                                            : IconButton(
                                                onPressed: () {
                                                  try {
                                                    launch(workout.facebook)
                                                        .catchError((e) {
                                                      _showToast(
                                                          'Link Not Available');
                                                    });
                                                  } catch (e) {
                                                    _showToast(
                                                        'Link Not Available');
                                                  }
                                                },
                                                icon: Icon(
                                                  MyFlutterApp.facebook_squared,
                                                  size:
                                                      _mediaQuery.size.height *
                                                          0.045,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                        workout.tiktokLink.isEmpty
                                            ? SizedBox()
                                            : IconButton(
                                                onPressed: () {
                                                  try {
                                                    launch(workout.tiktokLink)
                                                        .catchError((e) {
                                                      _showToast(
                                                          'Link Not Available');
                                                    });
                                                  } catch (e) {
                                                    _showToast(
                                                        'Link Not Available');
                                                  }
                                                },
                                                icon: Icon(
                                                  MyFlutterApp.unknown,
                                                  color: Colors.black,
                                                  size:
                                                      _mediaQuery.size.height *
                                                          0.045,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                      workout.views.toString(),
                      style: TextStyle(
                          fontFamily: 'PTSans',
                          fontSize: _mediaQuery.size.height * 0.02),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                        .incrementView(
                            workout.creatorId, workout.workoutId, context);
                    showDialog(
                        context: context,
                        builder: (ctx) => CustomDialogBox(
                            'Are You Ready?',
                            'Grab a water bottle, warmup, lets do this',
                            'assets/images/water_bottle.jpg',
                            ExerciseScreen.routeName,
                            workout.exercises));
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Container(
                  height: _mediaQuery.size.height * 0.47,
                  width: _mediaQuery.size.width,
                  child: ListView.builder(
                    itemBuilder: (ctx, index) => ExerciseTiles(
                      key: ValueKey(workout.exercises[index].exerciseId),
                      exercise: workout.exercises[index],
                      size: _mediaQuery.size.width,
                      isDeleteable: false,
                      addExercise: () {},
                      delete: () {},
                      updateExercise: () {},
                    ),
                    itemCount: workout.exercises.length,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
