import 'package:flutter/material.dart';

import 'package:teenfit/auth/login_screen.dart';

import '../screens/home_screen.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup-screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool hidePass = true;
  bool confirmPassHide = true;
  bool isLoading = false;
  TextEditingController textEditingController = TextEditingController();
  final GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    String _email = 'email';
    String _password = 'password';

    void _submit() async {
      String _errorMessage = '';

      _formkey1.currentState!.save();
      print(_email);
      print(_password);

      Navigator.of(context).pushNamed(HomeScreen.routeName);
    }

    Widget buildEmailField() {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (_mediaQuery.size.width * 0.09),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          height: (_mediaQuery.size.height - _appBarHieght) * 0.075,
          width: _mediaQuery.size.width,
          child: TextFormField(
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              errorMaxLines: 1,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              labelText: ' Email',
              labelStyle: TextStyle(
                fontSize: _mediaQuery.size.height * 0.03,
                fontWeight: FontWeight.w800,
              ),
            ),
            style: TextStyle(
              fontSize: _mediaQuery.size.height * 0.028,
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().isEmpty) {
                return 'Email is Required';
              } else if (!value.toString().contains('@')) {
                return 'Invalid Email';
              } else if (value.toString().contains(' ')) {
                return 'Please Remove Spaces';
              }
              return null;
            },
            onSaved: (value) {
              _email = value.toString();
            },
          ),
        ),
      );
    }

    Widget buildPasswordField() {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (_mediaQuery.size.width * 0.09),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          height: (_mediaQuery.size.height - _appBarHieght) * 0.075,
          width: _mediaQuery.size.width,
          child: TextFormField(
            controller: textEditingController,
            obscureText: hidePass,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(hidePass ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  if (hidePass == true) {
                    setState(() {
                      hidePass = false;
                    });
                  } else {
                    setState(() {
                      hidePass = true;
                    });
                  }
                },
              ),
              fillColor: Colors.white,
              filled: true,
              errorMaxLines: 1,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              labelText: ' Password',
              labelStyle: TextStyle(
                  fontSize: _mediaQuery.size.height * 0.03,
                  fontWeight: FontWeight.w800),
            ),
            style: TextStyle(
              fontSize: _mediaQuery.size.height * 0.028,
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().isEmpty) {
                return 'Password is Required';
              } else if (value.toString().contains(' ')) {
                return 'Please Remove Spaces';
              }
              return null;
            },
            onSaved: (value) {
              _password = value.toString();
            },
          ),
        ),
      );
    }

    Widget buildConfirmPasswordField() {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (_mediaQuery.size.width * 0.09),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          height: (_mediaQuery.size.height - _appBarHieght) * 0.075,
          width: _mediaQuery.size.width,
          child: TextFormField(
            controller: textEditingController,
            obscureText: hidePass,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(hidePass ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  if (confirmPassHide == true) {
                    setState(() {
                      confirmPassHide = false;
                    });
                  } else {
                    setState(() {
                      confirmPassHide = true;
                    });
                  }
                },
              ),
              fillColor: Colors.white,
              filled: true,
              errorMaxLines: 1,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              labelText: ' Confirm Password',
              labelStyle: TextStyle(
                  fontSize: _mediaQuery.size.height * 0.03,
                  fontWeight: FontWeight.w800),
            ),
            style: TextStyle(
              fontSize: _mediaQuery.size.height * 0.028,
            ),
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value.toString() != textEditingController.text) {
                return 'Password do Not Match';
              }
              return null;
            },
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: _mediaQuery.size.height,
              width: _mediaQuery.size.width,
              child: Image.asset(
                'assets/images/SignUp.png',
                fit: BoxFit.fill,
              ),
            ),
            Form(
              key: _formkey1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: _mediaQuery.size.width,
                    height: _appBarHieght,
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      iconSize: _appBarHieght * 0.4,
                    ),
                  ),
                  SizedBox(
                    height: (_mediaQuery.size.height - _appBarHieght) * 0.29,
                  ),
                  buildEmailField(),
                  SizedBox(
                    height: (_mediaQuery.size.height - _appBarHieght) * 0.05,
                  ),
                  buildPasswordField(),
                  SizedBox(
                    height: (_mediaQuery.size.height - _appBarHieght) * 0.05,
                  ),
                  buildConfirmPasswordField(),
                  SizedBox(
                    height: (_mediaQuery.size.height - _appBarHieght) * 0.05,
                  ),
                  //SignUp Btn
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: _mediaQuery.size.width * 0.09),
                    child: Container(
                      height: (_mediaQuery.size.height - _appBarHieght) * 0.08,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(_theme.primaryColor),
                          elevation: MaterialStateProperty.all(5),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        child: isLoading
                            ? CircularProgressIndicator()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: (_mediaQuery.size.height -
                                                _appBarHieght) *
                                            0.03,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: _mediaQuery.size.width * 0.02,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: (_mediaQuery.size.height -
                                            _appBarHieght) *
                                        0.04,
                                  ),
                                ],
                              ),
                        onPressed: () {
                          _submit();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: (_mediaQuery.size.height - _appBarHieght) * 0.15,
                  ),
                  //switch screens
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: _mediaQuery.size.width * 0.09),
                    child: Container(
                        height:
                            (_mediaQuery.size.height - _appBarHieght) * 0.08,
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: TextButton(
                            child: Row(
                              children: [
                                Text(
                                  'Already Have An Account? | ',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontFamily: 'Roboto',
                                      fontSize: (_mediaQuery.size.height -
                                              _appBarHieght) *
                                          0.015,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Roboto',
                                      fontSize: (_mediaQuery.size.height -
                                              _appBarHieght) *
                                          0.015,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(LoginScreen.routeName);
                            },
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
