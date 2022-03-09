import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:app_review/app_review.dart';
import '../Custom/custom_dialog.dart';
import '../screens/create_workout.dart';
import '../screens/workout_page.dart';
import '../providers/workout.dart';

// ignore: must_be_immutable
class WorkoutTile extends StatefulWidget {
  final Workout workout;
  bool isDeletable;
  bool isAdmin;

  WorkoutTile(this.workout, this.isDeletable, this.isAdmin);

  @override
  State<WorkoutTile> createState() => _WorkoutTileState();
}

class _WorkoutTileState extends State<WorkoutTile> {
  late int daysLeft;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final date = widget.workout.date;
    final timeNow = DateTime.now();

    int difference = timeNow.difference(date).inDays;

    daysLeft = 15 - difference;
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        alignment: widget.isDeletable ? Alignment.centerLeft : Alignment.center,
        children: [
          Container(
            height: (_mediaQuery.size.height - _appBarHieght) * 0.3,
            width: double.infinity,
            child: widget.workout.bannerImageLink == null
                ? widget.workout.bannerImage == null
                    ? Image.asset(
                        'assets/images/BannerImageUnavailable.png',
                        fit: BoxFit.cover,
                      )
                    : FadeInImage(
                        placeholder:
                            AssetImage('assets/images/loading-gif.gif'),
                        placeholderErrorBuilder: (context, _, __) =>
                            Image.asset(
                          'assets/images/loading-gif.gif',
                          fit: BoxFit.contain,
                        ),
                        fit: BoxFit.cover,
                        //change
                        image: FileImage(widget.workout.bannerImage!),
                        imageErrorBuilder: (image, _, __) => Image.asset(
                          'assets/images/ImageUploadError.png',
                          fit: BoxFit.cover,
                        ),
                      )
                : FadeInImage(
                    placeholder: AssetImage('assets/images/loading-gif.gif'),
                    placeholderErrorBuilder: (context, _, __) => Image.asset(
                      'assets/images/loading-gif.gif',
                      fit: BoxFit.contain,
                    ),
                    fit: BoxFit.cover,
                    //change
                    image: CachedNetworkImageProvider(
                        widget.workout.bannerImageLink!),
                    imageErrorBuilder: (image, _, __) => Image.asset(
                      'assets/images/ImageUploadError.png',
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          Container(
            height: (_mediaQuery.size.height - _appBarHieght) * 0.3,
            width: double.infinity,
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () {
                Navigator.of(context).pushNamed(
                  WorkoutPage.routeName,
                  arguments: Workout(
                    failed: false,
                    pending: widget.workout.pending,
                    date: widget.workout.date,
                    creatorName: widget.workout.creatorName,
                    creatorId: widget.workout.creatorId,
                    workoutId: widget.workout.workoutId,
                    workoutName: widget.workout.workoutName,
                    instagram: widget.workout.instagram,
                    facebook: widget.workout.facebook,
                    tiktokLink: widget.workout.tiktokLink,
                    bannerImage: widget.workout.bannerImage,
                    bannerImageLink: widget.workout.bannerImageLink,
                    exercises: widget.workout.exercises,
                  ),
                );
              },
            ),
          ),
          widget.isDeletable
              ? Container(
                  width: double.infinity,
                  height: (_mediaQuery.size.height - _appBarHieght) * 0.3,
                  child: Row(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: Container(
                          width: _mediaQuery.size.width * 0.6,
                          height:
                              (_mediaQuery.size.height - _appBarHieght) * 0.25,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.workout.workoutName,
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize:
                                  (_mediaQuery.size.height - _appBarHieght) *
                                      0.06,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(3.0, 3.0),
                                  blurRadius: 1.0,
                                  color: Color.fromARGB(255, 128, 128, 128),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              AddWorkoutScreen.routeName,
                              arguments: {
                                'workout': widget.workout,
                                'isEdit': true
                              });
                        },
                        icon: Icon(Icons.edit),
                        color: Colors.grey[100],
                        iconSize: (_mediaQuery.size.height * 0.06),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => CustomDialogBox(
                                'Are You Sure?',
                                'This action will delete the workout and it can never be recoverd',
                                'assets/images/trash.png',
                                'pop',
                                widget.workout),
                          );
                        },
                        icon: Icon(Icons.delete_outline),
                        color: Colors.red[300],
                        iconSize: (_mediaQuery.size.height * 0.06),
                      ),
                    ],
                  ),
                )
              : widget.isAdmin
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => CustomDialogBox(
                                        'Accept Workout?',
                                        'Does The Workout Meet Standards?',
                                        'assets/images/teen_fit_logo_white_withpeople_withbackground.png',
                                        'accept-workout',
                                        widget.workout));
                              },
                              icon: Icon(
                                Icons.check_box,
                                color: Colors.green,
                              ),
                              iconSize: (_mediaQuery.size.height * 0.06)),
                          Container(
                            width: _mediaQuery.size.width * 0.55,
                            height: (_mediaQuery.size.height - _appBarHieght) *
                                0.25,
                            alignment: Alignment.center,
                            child: Text(
                              widget.workout.workoutName,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize:
                                    (_mediaQuery.size.height - _appBarHieght) *
                                        0.06,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(3.0, 3.0),
                                    blurRadius: 1.0,
                                    color: Color.fromARGB(255, 128, 128, 128),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => CustomDialogBox(
                                        'Delete Workout?',
                                        'Does The Workout Not Meet Standards?',
                                        'assets/images/teen_fit_logo_white_withpeople_withbackground.png',
                                        'fail-workout',
                                        widget.workout));
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red[300],
                              ),
                              iconSize: (_mediaQuery.size.height * 0.06)),
                        ],
                      ),
                    )
                  : Container(
                      height: (_mediaQuery.size.height - _appBarHieght) * 0.3,
                      width: double.infinity,
                      child: InkWell(
                        onTap: () async {
                          if (Platform.isIOS) {
                            await AppReview.requestReview
                                .onError((error, stackTrace) => null);
                          }
                          Navigator.of(context).pushNamed(
                            WorkoutPage.routeName,
                            arguments: Workout(
                              failed: false,
                              pending: widget.workout.pending,
                              date: widget.workout.date,
                              creatorName: widget.workout.creatorName,
                              creatorId: widget.workout.creatorId,
                              workoutId: widget.workout.workoutId,
                              workoutName: widget.workout.workoutName,
                              instagram: widget.workout.instagram,
                              facebook: widget.workout.facebook,
                              tiktokLink: widget.workout.tiktokLink,
                              bannerImage: widget.workout.bannerImage,
                              bannerImageLink: widget.workout.bannerImageLink,
                              exercises: widget.workout.exercises,
                            ),
                          );
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: _mediaQuery.size.width * 0.8,
                              height:
                                  (_mediaQuery.size.height - _appBarHieght) *
                                      0.25,
                              alignment: Alignment.center,
                              child: Text(
                                widget.workout.workoutName,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: (_mediaQuery.size.height -
                                          _appBarHieght) *
                                      0.06,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(3.0, 3.0),
                                      blurRadius: 1.0,
                                      color: Color.fromARGB(255, 128, 128, 128),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
          widget.isAdmin
              ? SizedBox()
              : widget.workout.pending
                  ? Stack(children: [
                      Container(
                        height: (_mediaQuery.size.height - _appBarHieght) * 0.3,
                        width: double.infinity,
                        child: Image.asset(
                          'assets/images/pending.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: (_mediaQuery.size.height - _appBarHieght) * 0.3,
                        width: double.infinity,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              WorkoutPage.routeName,
                              arguments: Workout(
                                failed: false,
                                pending: widget.workout.pending,
                                date: widget.workout.date,
                                creatorName: widget.workout.creatorName,
                                creatorId: widget.workout.creatorId,
                                workoutId: widget.workout.workoutId,
                                workoutName: widget.workout.workoutName,
                                instagram: widget.workout.instagram,
                                facebook: widget.workout.facebook,
                                tiktokLink: widget.workout.tiktokLink,
                                bannerImage: widget.workout.bannerImage,
                                bannerImageLink: widget.workout.bannerImageLink,
                                exercises: widget.workout.exercises,
                              ),
                            );
                          },
                        ),
                      ),
                    ])
                  : SizedBox(),
          widget.workout.failed
              ? Container(
                  width: double.infinity,
                  height: (_mediaQuery.size.height - _appBarHieght) * 0.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: _mediaQuery.size.height * 0.08,
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.red[400]),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'Failed | ${daysLeft.toString()} ${daysLeft == 1 ? 'day' : 'days'} left untill deleted',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _mediaQuery.size.height * 0.03,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
