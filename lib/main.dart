import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:teenfit/providers/basic.dart';
import 'package:teenfit/providers/userProv.dart';
import 'package:teenfit/screens/admin_screen.dart';
import 'package:teenfit/screens/edit_profile.dart';
import 'package:teenfit/screens/home_screen.dart';
import 'package:teenfit/screens/privacy_policy_screen.dart';
import 'package:teenfit/screens/user_screen.dart';
import 'package:teenfit/screens/workout_page.dart';

import './screens/auth/reset_pass_screen.dart';
import './providers/auth.dart';
import './screens/auth/error_screen.dart';
import './screens/auth/loading.dart';
import './screens/add_exercise_screen.dart';
import 'screens/create_workout.dart';
import './screens/exercise_screen.dart';
import './screens/auth/signup_screen.dart';
import './providers/workouts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
          ChangeNotifierProvider<UserProv>(
            create: (ctx) => UserProv(),
          ),
          ChangeNotifierProvider<Workouts>(
            create: (ctx) => Workouts(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TeenFit',
          theme: ThemeData(
            primaryColor: Color(0xffF7F4EB),
            primaryColorLight: Color.fromARGB(255, 204, 201, 193),
            secondaryHeaderColor: Color(0xffF0A037),
            splashColor: Colors.transparent,
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
                        return HomeScreen();
                      }
                      // Otherwise, show something whilst waiting for initialization to complete
                      return LoadingScreen();
                    },
                  ),
                ),
          routes: {
            SignupScreen.routeName: (ctx) => SignupScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            ExerciseScreen.routeName: (ctx) => ExerciseScreen(),
            WorkoutPage.routeName: (ctx) => WorkoutPage(),
            AddWorkoutScreen.routeName: (ctx) => AddWorkoutScreen(),
            AddExerciseScreen.routeName: (ctx) => AddExerciseScreen(),
            UserScreen.routeName: (ctx) => UserScreen(),
            ResetPasswordScreen.routeName: (ctx) => ResetPasswordScreen(),
            AdminScreen.routeName: (ctx) => AdminScreen(),
            PrivacyPolicyScreen.routeName: (ctx) => PrivacyPolicyScreen(),
            EditProfile.routeName: (ctx) => EditProfile(),
          },
        ),
      ),
    );
  }
}
