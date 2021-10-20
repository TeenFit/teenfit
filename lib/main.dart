import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
          home: HomeScreen(),
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
          },
        ),
      ),
    );
  }
}
