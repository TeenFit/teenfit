import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teenfit/providers/basic.dart';
import 'package:teenfit/screens/admin_screen.dart';
import 'package:teenfit/screens/privacy_policy_screen.dart';
import 'package:teenfit/screens/user_screen.dart';

import './screens/auth/reset_pass_screen.dart';
import './providers/auth.dart';
import './screens/auth/error_screen.dart';
import './screens/auth/loading.dart';
import './screens/add_exercise_screen.dart';
import 'screens/create_workout.dart';
import 'screens/my_workouts.dart';
import './screens/exercise_screen.dart';
import './screens/auth/login_screen.dart';
import './screens/auth/signup_screen.dart';
import './screens/home_screen.dart';
import './providers/workouts.dart';
import './screens/workout_page.dart';
import './screens/auth/intro_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isInit = false;
  bool isLoading = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (isInit == false) {
      await Firebase.initializeApp();
      await MobileAds.instance.initialize();
    }
    if (this.mounted) {
      setState(() {
        isInit = true;
        isLoading = false;
      });
    }
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<BasicCommands>(
            create: (ctx) => BasicCommands(),
          ),
          ChangeNotifierProvider<Auth>(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProvider<Workouts>(
            create: (ctx) => Workouts(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TeenFit',
          theme: ThemeData(
            primaryColor: Color(0xffF0A037),
            primaryColorDark: Color(0xffAE7E3F),
            highlightColor: Color(0xffA4B1BA),
            cardColor: Color(0xffD3D3D3),
            shadowColor: Color(0xff878787),
          ),
          home: isLoading
              ? LoadingScreen()
              : Consumer<Auth>(
                  builder: (context, auth, _) => FutureBuilder(
                    // Initialize FlutterFire:
                    future: _initialization,

                    builder: (context, snapshot) {
                      // Check for errors
                      if (snapshot.hasError) {
                        return ErrorScreen();
                      }
                      // Once complete, show your application
                      if (snapshot.connectionState == ConnectionState.done) {
                        return StreamBuilder<User?>(
                          initialData: FirebaseAuth.instance.currentUser,
                          stream: auth.onAuthStateChanged,
                          builder: (BuildContext context,
                              AsyncSnapshot<User?> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              var isAuth = snapshot.data;
                              return Builder(
                                builder: (context) {
                                  return isAuth != null
                                      ? HomeScreen()
                                      : IntroPage();
                                },
                              );
                            } else if (snapshot.hasError) {
                              return ErrorScreen();
                            } else {
                              return LoadingScreen();
                            }
                          },
                        );
                      }
                      // Otherwise, show something whilst waiting for initialization to complete
                      return LoadingScreen();
                    },
                  ),
                ),
          routes: {
            IntroPage.routeName: (ctx) => IntroPage(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            SignupScreen.routeName: (ctx) => SignupScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            WorkoutPage.routeName: (ctx) => WorkoutPage(),
            ExerciseScreen.routeName: (ctx) => ExerciseScreen(),
            CreateWorkout.routeName: (ctx) => CreateWorkout(),
            AddWorkoutScreen.routeName: (ctx) => AddWorkoutScreen(),
            AddExerciseScreen.routeName: (ctx) => AddExerciseScreen(),
            UserScreen.routeName: (ctx) => UserScreen(),
            ResetPasswordScreen.routeName: (ctx) => ResetPasswordScreen(),
            AdminScreen.routeName: (ctx) => AdminScreen(),
            PrivacyPolicyScreen.routeName: (ctx) => PrivacyPolicyScreen(),
          },
        ),
      ),
    );
  }
}
