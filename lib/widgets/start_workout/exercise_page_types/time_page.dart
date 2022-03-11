import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:teenfit/widgets/start_workout/exercise_page_types/rest_page.dart';

import 'rest_page.dart';

import '/providers/exercise.dart';

class TimePage extends StatefulWidget {
  final Exercise exercise;
  final Function goToNext;
  final Function goToPrevious;

  TimePage(
    this.exercise,
    this.goToNext,
    this.goToPrevious,
  );

  @override
  State<TimePage> createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  CountDownController _countDownController = CountDownController();
  CountDownController _restCountDownController = CountDownController();
  bool isRest = false;

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    return isRest == true
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
                    height: (_mediaQuery.size.height - _appBarHeight) * 0.11,
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
                    height: (_mediaQuery.size.height - _appBarHeight) * 0.51,
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
                              (_mediaQuery.size.height - _appBarHeight) * 0.18,
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
                          width:
                              (_mediaQuery.size.height - _appBarHeight) * 0.15,
                          height:
                              (_mediaQuery.size.height - _appBarHeight) * 0.15,
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
                              fontSize:
                                  (_mediaQuery.size.height - _appBarHeight) *
                                      0.06,
                              color: _theme.shadowColor,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          iconSize:
                              (_mediaQuery.size.height - _appBarHeight) * 0.18,
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
          );
  }
}
