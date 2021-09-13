import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/auth/login_screen.dart';
import 'package:teenfit/auth/signup_screen.dart';
import 'package:teenfit/home_screen.dart';

import './auth/intro_page.dart';

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
    return /* MultiProvider(
      providers: [],
      child:*/
        MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TeenFit',
      theme: ThemeData(
          primaryColor: Color(0xffF0A037),
          primaryColorDark: Color(0xffAE7E3F),
          disabledColor: Color(0xffA4B1BA),
          accentColor: Color(0xffD3D3D3)),
      home: HomeScreen(),
      routes: {
        IntroPage.routeName: (ctx) => IntroPage(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        SignupScreen.routeName: (ctx) => SignupScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen()
      },
      //),
    );
  }
}
