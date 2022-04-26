import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/providers/auth.dart';
import 'package:teenfit/providers/userProv.dart';
import 'package:teenfit/screens/auth/login_screen.dart';
import 'package:teenfit/screens/discovery_page.dart';
import 'package:teenfit/screens/my_workouts.dart';
import 'package:teenfit/screens/user_screen.dart';
import 'package:teenfit/screens/workout_page.dart';

import '../providers/exercise.dart';
import '../providers/workout.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isInit = false;
  Widget? pageView;
  NotificationSettings? settings;

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'newWorkout') {
      Navigator.of(context).pushNamed(WorkoutPage.routeName, arguments: {
        'workout': Workout(
          views: message.data['views'],
          searchTerms: message.data['searchTerms'],
          failed: message.data['failed'],
          pending: message.data['pending'],
          date: DateTime.parse(message.data['date']),
          creatorId: message.data['creatorId'],
          workoutId: message.data['workoutId'],
          workoutName: message.data['workoutName'],
          bannerImage: null,
          bannerImageLink: message.data['bannerImage'],
          exercises: (message.data['exercises'] as List)
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
        ),
        'isDeletable': false,
      });
    }
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    await FirebaseMessaging.instance.subscribeToTopic("newWorkout");
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit == false) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: true,
        sound: true,
      );

      if (settings!.authorizationStatus == AuthorizationStatus.authorized) {
        await setupInteractedMessage();
      }

      bool isAuth = Provider.of<Auth>(context, listen: false).isAuth();

      if (isAuth) {
        Provider.of<UserProv>(context, listen: false).fetchAndSetUser(context);
      }

      pageView = PageView(
        controller: pageController,
        children: [
          DiscoveryPage(),
          isAuth == true ? CreateWorkout(false, null) : LoginScreen(),
          UserScreen(),
        ],
      );

      setState(() {
        isInit = true;
      });
    }
  }

  int _selectedIndex = 0;
  PageController pageController = PageController();

  void onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 800), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _theme.primaryColor,
      body: isInit == false
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                backgroundColor: _theme.shadowColor,
                color: Colors.white,
              ),
            )
          : pageView,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded), label: 'Find'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        elevation: 5,
        currentIndex: _selectedIndex,
        selectedItemColor: _theme.secondaryHeaderColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        backgroundColor: _theme.primaryColor,
        selectedLabelStyle: TextStyle(
          color: _theme.cardColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'PTSans',
          letterSpacing: 1,
        ),
        unselectedLabelStyle: TextStyle(
          color: _theme.cardColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'PTSans',
          letterSpacing: 1,
        ),
        onTap: onTap,
        iconSize: _mediaQuery.size.height * 0.05,
      ),
    );
  }
}
