import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

import '/widgets/start_workout/rest_page.dart';

import '/providers/exercise.dart';

class ExercisePage extends StatefulWidget {
  final Exercise exercise;
  final Function goToNext;
  final Function goToPrevious;

  ExercisePage(
    this.exercise,
    this.goToNext,
    this.goToPrevious,
  );

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  CountDownController _countDownController = CountDownController();
  CountDownController _restCountDownController = CountDownController();
  bool isRest = false;

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    return widget.exercise.restTime != null &&
            widget.exercise.timeSeconds != null
        ? isRest == true
            ? RestPage(
                widget.exercise,
                widget.goToNext,
                _restCountDownController,
              )
            : Container(
                height: _mediaQuery.size.height,
                width: _mediaQuery.size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        height:
                            (_mediaQuery.size.height - _appBarHeight) * 0.11,
                        width: _mediaQuery.size.width,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            widget.exercise.name,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Roboto',
                              fontSize: _mediaQuery.size.height * 0.05,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        height:
                            (_mediaQuery.size.height - _appBarHeight) * 0.51,
                        width: _mediaQuery.size.width,
                        child: widget.exercise.exerciseImageLink == null
                            ? FadeInImage(
                                imageErrorBuilder: (context, image, _) =>
                                    Image.asset(
                                  'assets/images/ImageUploadError.png',
                                  fit: BoxFit.cover,
                                ),
                                placeholderErrorBuilder: (context, image, _) =>
                                    Image.asset(
                                  'assets/images/ImageUploadError.png',
                                  fit: BoxFit.cover,
                                ),
                                placeholder:
                                    AssetImage('assets/images/loading-gif.gif'),
                                image:
                                    FileImage(widget.exercise.exerciseImage!),
                                fit: BoxFit.contain,
                              )
                            : FadeInImage(
                                imageErrorBuilder: (context, image, _) =>
                                    Image.asset(
                                  'assets/images/ImageUploadError.png',
                                  fit: BoxFit.cover,
                                ),
                                placeholderErrorBuilder: (context, image, _) =>
                                    Image.asset(
                                  'assets/images/ImageUploadError.png',
                                  fit: BoxFit.cover,
                                ),
                                placeholder:
                                    AssetImage('assets/images/loading-gif.gif'),
                                image: CachedNetworkImageProvider(
                                    widget.exercise.exerciseImageLink!),
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                    SizedBox(
                      height: (_mediaQuery.size.height - _appBarHeight) * 0.01,
                    ),
                    Container(
                      height: (_mediaQuery.size.height - _appBarHeight) * 0.25,
                      width: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              iconSize:
                                  (_mediaQuery.size.height - _appBarHeight) *
                                      0.18,
                              onPressed: () {
                                _countDownController.pause();
                              },
                              icon: Icon(Icons.pause),
                              color: _theme.primaryColor,
                            ),
                            CircularCountDownTimer(
                              initialDuration: 0,
                              autoStart: true,
                              controller: _countDownController,
                              width: (_mediaQuery.size.height - _appBarHeight) *
                                  0.15,
                              height:
                                  (_mediaQuery.size.height - _appBarHeight) *
                                      0.15,
                              duration: widget.exercise.timeSeconds!.toInt(),
                              backgroundColor: _theme.cardColor,
                              fillColor: _theme.primaryColor,
                              ringColor: _theme.highlightColor,
                              strokeWidth: _mediaQuery.size.width * 0.06,
                              onComplete: () {
                                setState(() {
                                  isRest = true;
                                });
                              },
                              isReverse: true,
                              isReverseAnimation: false,
                              strokeCap: StrokeCap.round,
                              textFormat: CountdownTextFormat.S,
                              textStyle: TextStyle(
                                  fontSize: (_mediaQuery.size.height -
                                          _appBarHeight) *
                                      0.06,
                                  color: _theme.shadowColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              iconSize:
                                  (_mediaQuery.size.height - _appBarHeight) *
                                      0.18,
                              onPressed: () {
                                _countDownController.restart();
                              },
                              icon: Icon(Icons.play_arrow),
                              color: _theme.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: (_mediaQuery.size.height - _appBarHeight) * 0.01,
                    ),
                  ],
                ),
              )
        : Container(
            height: (_mediaQuery.size.height),
            width: _mediaQuery.size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: (_mediaQuery.size.height - _appBarHeight) * 0.1,
                    width: _mediaQuery.size.width,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        widget.exercise.name,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto',
                          fontSize: _mediaQuery.size.height * 0.045,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: (_mediaQuery.size.height - _appBarHeight) * 0.63,
                    width: _mediaQuery.size.width,
                    child: widget.exercise.exerciseImageLink == null
                        ? FadeInImage(
                            imageErrorBuilder: (context, image, _) =>
                                Image.asset(
                              'assets/images/ImageUploadError.png',
                              fit: BoxFit.cover,
                            ),
                            placeholderErrorBuilder: (context, image, _) =>
                                Image.asset(
                              'assets/images/ImageUploadError.png',
                              fit: BoxFit.cover,
                            ),
                            placeholder:
                                AssetImage('assets/images/loading-gif.gif'),
                            image: FileImage(widget.exercise.exerciseImage!),
                            fit: BoxFit.contain,
                          )
                        : FadeInImage(
                            imageErrorBuilder: (context, image, _) =>
                                Image.asset(
                              'assets/images/ImageUploadError.png',
                              fit: BoxFit.cover,
                            ),
                            placeholderErrorBuilder: (context, image, _) =>
                                Image.asset(
                              'assets/images/ImageUploadError.png',
                              fit: BoxFit.cover,
                            ),
                            placeholder:
                                AssetImage('assets/images/loading-gif.gif'),
                            image: CachedNetworkImageProvider(
                                widget.exercise.exerciseImageLink!),
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
                SizedBox(
                  height: (_mediaQuery.size.height - _appBarHeight) * 0.01,
                ),
                Container(
                  height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: _mediaQuery.size.width * 0.5,
                        height:
                            (_mediaQuery.size.height - _appBarHeight) * 0.08,
                        decoration: BoxDecoration(
                          color: _theme.shadowColor,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(25)),
                        ),
                        child: Center(
                          child: Text(
                            '${widget.exercise.sets} sets',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _theme.cardColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'PTSans',
                              fontSize: _mediaQuery.size.height * 0.035,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: _mediaQuery.size.width * 0.5,
                        height:
                            (_mediaQuery.size.height - _appBarHeight) * 0.08,
                        decoration: BoxDecoration(
                          color: _theme.shadowColor,
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(25)),
                        ),
                        child: Center(
                          child: Text(
                            '${widget.exercise.reps} reps',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _theme.cardColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'PTSans',
                              fontSize: _mediaQuery.size.height * 0.035,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: _mediaQuery.size.width * 0.5,
                        height:
                            (_mediaQuery.size.height - _appBarHeight) * 0.08,
                        decoration: BoxDecoration(
                          color: _theme.shadowColor,
                        ),
                        child: TextButton(
                            style: TextButton.styleFrom(
                              primary: _theme.cardColor,
                            ),
                            onPressed: () {
                              widget.goToPrevious();
                            },
                            child: Text(
                              '<- Back',
                              style: TextStyle(
                                color: _theme.cardColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PTSans',
                                fontSize: _mediaQuery.size.height * 0.035,
                                letterSpacing: 1,
                              ),
                            )),
                      ),
                      Container(
                        width: _mediaQuery.size.width * 0.5,
                        height:
                            (_mediaQuery.size.height - _appBarHeight) * 0.08,
                        decoration: BoxDecoration(
                          color: _theme.shadowColor,
                        ),
                        child: TextButton(
                            style: TextButton.styleFrom(
                              primary: _theme.cardColor,
                            ),
                            onPressed: () {
                              widget.goToNext();
                            },
                            child: Text(
                              'Next ->',
                              style: TextStyle(
                                color: _theme.cardColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PTSans',
                                fontSize: _mediaQuery.size.height * 0.035,
                                letterSpacing: 1,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
