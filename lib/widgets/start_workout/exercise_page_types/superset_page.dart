import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '/providers/exercise.dart';

class SuperSetPage extends StatefulWidget {
  final Exercise? exercise;
  final Function? goToNext;
  final Function? goToPrevious;

  SuperSetPage(
    this.exercise,
    this.goToNext,
    this.goToPrevious,
  );

  @override
  State<SuperSetPage> createState() => _SuperSetPageState();
}

class _SuperSetPageState extends State<SuperSetPage> {
  CarouselController _carouselController = CarouselController();
  bool isFirstImage = true;

  void goToNext() {
    _carouselController.nextPage();
  }

  void goToPrevious() {
    _carouselController.previousPage();
  }

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
                  isFirstImage == true
                      ? widget.exercise!.name
                      : widget.exercise!.name2 ?? '',
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
          Container(
            width: _mediaQuery.size.width,
            height: (_mediaQuery.size.height - _appBarHeight) * 0.66,
            child: CarouselSlider(
              options: CarouselOptions(
                onPageChanged: (index, _) {
                  setState(() {
                    if (isFirstImage == true) {
                      isFirstImage = false;
                    } else {
                      isFirstImage = true;
                    }
                  });
                },
                viewportFraction: 1,
                height: (_mediaQuery.size.height - _appBarHeight),
                initialPage: 0,
                enableInfiniteScroll: false,
                autoPlay: false,
                reverse: false,
                enlargeCenterPage: false,
              ),
              carouselController: _carouselController,
              items: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        height:
                            (_mediaQuery.size.height - _appBarHeight) * 0.63,
                        width: _mediaQuery.size.width * 0.75,
                        child: widget.exercise!.exerciseImageLink == null
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
                                    FileImage(widget.exercise!.exerciseImage!),
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
                                    widget.exercise!.exerciseImageLink!),
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                    Container(
                      height: _mediaQuery.size.width * 0.25,
                      width: _mediaQuery.size.width * 0.25,
                      child: IconButton(
                        onPressed: () {
                          goToNext();
                        },
                        icon: Icon(Icons.arrow_circle_right_outlined),
                        color: _theme.primaryColor,
                        alignment: Alignment.center,
                        iconSize: _mediaQuery.size.height * 0.1,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: _mediaQuery.size.width * 0.25,
                      width: _mediaQuery.size.width * 0.25,
                      child: IconButton(
                        onPressed: () {
                          goToPrevious();
                        },
                        icon: Icon(Icons.arrow_circle_left_outlined),
                        alignment: Alignment.center,
                        color: _theme.primaryColor,
                        iconSize: _mediaQuery.size.height * 0.1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        height:
                            (_mediaQuery.size.height - _appBarHeight) * 0.63,
                        width: _mediaQuery.size.width * 0.75,
                        child: widget.exercise!.exerciseImageLink2 == null
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
                                    FileImage(widget.exercise!.exerciseImage2!),
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
                                    widget.exercise!.exerciseImageLink2!),
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  ],
                ),
              ],
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
                      '${widget.exercise!.sets} sets',
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
                      isFirstImage
                          ? '${widget.exercise!.reps} reps'
                          : '${widget.exercise!.reps2} reps',
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
                        widget.goToPrevious!();
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
                        widget.goToNext!();
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
