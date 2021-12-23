import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:teenfit/screens/home_screen.dart';

// import '../auth/login_screen.dart';
// import '../auth/signup_screen.dart';

class IntroPage extends StatefulWidget {
  static const routeName = '/intro-page';

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  CarouselController _carouselController = CarouselController();
  int pageIndex = 0;

  @override
  void didChangeDependencies() async {
    try {
      precacheImage(AssetImage('assets/images/IntroCarouselBG1.png'), context);
      precacheImage(AssetImage('assets/images/IntroCarouselBG2.png'), context);
      precacheImage(AssetImage('assets/images/IntroCarouselBG3.png'), context);
    } catch (e) {}
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    Widget _carouselPage1() {
      return Container(
        height: _mediaQuery.size.height,
        width: _mediaQuery.size.width,
        child: Image.asset(
          'assets/images/IntroCarouselBG1.png',
          fit: BoxFit.fill,
        ),
      );
    }

    Widget _carouselPage2() {
      return Container(
        height: _mediaQuery.size.height,
        width: _mediaQuery.size.width,
        child: Image.asset(
          'assets/images/IntroCarouselBG2.png',
          fit: BoxFit.fill,
        ),
      );
    }

    Widget _carouselPage3() {
      return Stack(
        children: [
          Container(
            height: _mediaQuery.size.height,
            width: _mediaQuery.size.width,
            child: Image.asset(
              'assets/images/IntroCarouselBG3.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            height: _mediaQuery.size.height,
            width: _mediaQuery.size.width,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: _mediaQuery.size.height * 0.07,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                            fontSize: _mediaQuery.size.height * 0.028,
                            letterSpacing: 1,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold),
                        primary: Colors.white,
                        onPrimary: Colors.black87,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                      ),
                      child: Text('Get Started'),
                      onPressed: () {
                        Navigator.of(context).pushNamed(HomeScreen.routeName);
                      },
                    ),
                  ),
                  SizedBox(height: _mediaQuery.size.height * 0.05),
                  Container(
                    width: double.infinity,
                    height: _mediaQuery.size.height * 0.07,
                    // child: TextButton(
                    //   style: TextButton.styleFrom(
                    //     textStyle: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: _mediaQuery.size.height * 0.028,
                    //       letterSpacing: 1,
                    //       fontFamily: 'Poppins',
                    //     ),
                    //     primary: Colors.white,
                    //     shape: const RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.all(
                    //         Radius.circular(15),
                    //       ),
                    //     ),
                    //   ),
                    //   child: Text('LOGIN'),
                    //   onPressed: () {
                    //     Navigator.of(context).pushNamed(LoginScreen.routeName);
                    //   },
                    // ),
                  ),
                  SizedBox(
                    height: _mediaQuery.size.height * 0.08,
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: _theme.primaryColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: _mediaQuery.size.height,
            width: _mediaQuery.size.width,
            child: CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                onPageChanged: (index, _) {
                  setState(() {
                    pageIndex = index;
                  });
                },
                autoPlayCurve: Curves.ease,
                viewportFraction: 1,
                height: _mediaQuery.size.height,
                initialPage: 0,
                enableInfiniteScroll: false,
                autoPlay: pageIndex == 2 ? false : true,
                reverse: false,
                enlargeCenterPage: false,
                autoPlayAnimationDuration: Duration(seconds: 4),
              ),
              items: [
                _carouselPage1(),
                _carouselPage2(),
                _carouselPage3(),
              ],
            ),
          ),
          Container(
            height: _mediaQuery.size.height,
            width: _mediaQuery.size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(_mediaQuery.size.height * 0.04),
                  child: AnimatedSmoothIndicator(
                    activeIndex: pageIndex,
                    count: 3,
                    effect: WormEffect(
                      activeDotColor: Colors.white,
                      dotColor: _theme.disabledColor,
                      dotHeight:
                          (_mediaQuery.size.height - _appBarHieght) * 0.025,
                      dotWidth:
                          (_mediaQuery.size.height - _appBarHieght) * 0.025,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
