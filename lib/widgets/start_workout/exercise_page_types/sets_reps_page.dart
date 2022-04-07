import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '/providers/exercise.dart';

class SetsAndRepsPage extends StatelessWidget {
  final Exercise? exercise;
  final Function? goToPage;
  final int index;

  SetsAndRepsPage(
    this.exercise,
    this.goToPage,
    this.index,
  );

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    return Container(
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
                  exercise!.name,
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
              child: exercise!.exerciseImageLink == null
                  ? FadeInImage(
                      imageErrorBuilder: (context, image, _) => Image.asset(
                        'assets/images/ImageUploadError.png',
                        fit: BoxFit.cover,
                      ),
                      placeholderErrorBuilder: (context, image, _) =>
                          Image.asset(
                        'assets/images/ImageUploadError.png',
                        fit: BoxFit.cover,
                      ),
                      placeholder: AssetImage('assets/images/loading-gif.gif'),
                      image: FileImage(exercise!.exerciseImage!),
                      fit: BoxFit.contain,
                    )
                  : FadeInImage(
                      imageErrorBuilder: (context, image, _) => Image.asset(
                        'assets/images/ImageUploadError.png',
                        fit: BoxFit.cover,
                      ),
                      placeholderErrorBuilder: (context, image, _) =>
                          Image.asset(
                        'assets/images/ImageUploadError.png',
                        fit: BoxFit.cover,
                      ),
                      placeholder: AssetImage('assets/images/loading-gif.gif'),
                      image: CachedNetworkImageProvider(
                          exercise!.exerciseImageLink!),
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
                  height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
                  decoration: BoxDecoration(
                    color: _theme.shadowColor,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(25)),
                  ),
                  child: Center(
                    child: Text(
                      '${exercise!.sets} sets',
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
                  height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
                  decoration: BoxDecoration(
                    color: _theme.shadowColor,
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(25)),
                  ),
                  child: Center(
                    child: Text(
                      '${exercise!.reps} reps',
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
                  height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
                  decoration: BoxDecoration(
                    color: _theme.shadowColor,
                  ),
                  child: TextButton(
                      style: TextButton.styleFrom(
                        primary: _theme.cardColor,
                      ),
                      onPressed: () {
                        goToPage!(index - 1);
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
                  height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
                  decoration: BoxDecoration(
                    color: _theme.shadowColor,
                  ),
                  child: TextButton(
                      style: TextButton.styleFrom(
                        primary: _theme.cardColor,
                      ),
                      onPressed: () {
                        goToPage!(index + 1);
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
