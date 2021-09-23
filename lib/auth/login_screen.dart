import 'package:flutter/material.dart';
import 'package:teenfit/auth/signup_screen.dart';
import 'package:teenfit/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hidePass = true;
  bool isLoading = false;
  final _formkey = GlobalKey<FormState>();

  void _submit() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).pushNamed(HomeScreen.routeName);
  }

  Widget buildEmailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        errorMaxLines: 1,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        labelText: ' Email',
        labelStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
      ),
      style: TextStyle(
        fontSize: 20,
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
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
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
        labelStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
      ),
      style: TextStyle(
        fontSize: 20,
      ),
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value.toString().isEmpty) {
          return 'Password is Required';
        } else if (value.toString().contains(' ')) {
          return 'Please Remove Spaces';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: _mediaQuery.size.height,
              width: _mediaQuery.size.width,
              child: Image.asset(
                'assets/images/LoginPage.png',
                fit: BoxFit.fill,
              ),
            ),
            Form(
              key: _formkey,
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: (_mediaQuery.size.width * 0.09),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      height: (_mediaQuery.size.height - _appBarHieght) * 0.075,
                      width: _mediaQuery.size.width,
                      child: buildEmailField(),
                    ),
                  ),
                  SizedBox(
                    height: (_mediaQuery.size.height - _appBarHieght) * 0.05,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: (_mediaQuery.size.width * 0.09),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      height: (_mediaQuery.size.height - _appBarHieght) * 0.075,
                      width: _mediaQuery.size.width,
                      child: buildPasswordField(),
                    ),
                  ),
                  //reset pass
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: _mediaQuery.size.width * 0.09),
                    child: TextButton(
                      clipBehavior: Clip.hardEdge,
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          'Forgot Your Password?',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                (_mediaQuery.size.height - _appBarHieght) *
                                    0.023,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    height: (_mediaQuery.size.height - _appBarHieght) * 0.05,
                  ),
                  //Login Btn
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
                                      'LOGIN',
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
                          onPressed: _submit),
                    ),
                  ),
                  SizedBox(
                    height: (_mediaQuery.size.height - _appBarHieght) * 0.21,
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
                                  'Don\'t Have An Account? | ',
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
                                  'Sign Up',
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
                                  .pushReplacementNamed(SignupScreen.routeName);
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
