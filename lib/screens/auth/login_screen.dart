import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '/screens/auth/reset_pass_screen.dart';
import '/Custom/http_execption.dart';
import '/providers/auth.dart';
import '../auth/signup_screen.dart';
// import '/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hidePass = true;

  bool _isLoading = false;
  final _formkey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() async {
    await Provider.of<Auth>(context, listen: false).updateToken();
    super.didChangeDependencies();
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 10,
      webShowClose: true,
      textColor: Colors.white,
      backgroundColor: Colors.grey.shade700,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    String _email = 'email';
    String _password = 'password';

    void _submit() async {
      if (!_formkey.currentState!.validate()) {
        return;
      }

      _formkey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        await Provider.of<Auth>(context, listen: false)
            .login(_email, _password, context)
            .then((_) => setState(() {
                  _isLoading = false;
                }));
      } on HttpException catch (error) {
        var errorMessage = 'Could Not Login, Try Again Later';
        if (error.toString().contains('user-not-found')) {
          errorMessage = ('This Account Does Not Exist');
        } else if (error.toString().contains('wrong-password')) {
          errorMessage = ('Wrong password or Email Provided');
        }
        _showToast(errorMessage);
      } catch (_) {
        _showToast('Could Not Login, Try Again Later');
      }
      setState(() {
        _isLoading = false;
      });
    }

    Widget buildEmailField() {
      return TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          helperText: ' ',
          contentPadding: EdgeInsets.symmetric(
            vertical: _mediaQuery.size.height * 0.05,
            horizontal: _mediaQuery.size.height * 0.015,
          ),
          fillColor: Colors.white,
          filled: true,
          errorMaxLines: 1,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          labelText: ' Email',
          labelStyle: TextStyle(
              fontSize: _mediaQuery.size.height * 0.023,
              fontWeight: FontWeight.w800),
          errorStyle: TextStyle(
              fontSize: _mediaQuery.size.height * 0.016,
              fontWeight: FontWeight.w800),
        ),
        style: TextStyle(
          fontSize: _mediaQuery.size.height * 0.023,
        ),
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value.toString().trim().isEmpty) {
            return 'Email is Required';
          } else if (!value.toString().trim().contains('@')) {
            return 'Invalid Email';
          }

          return null;
        },
        onSaved: (input) {
          _email = input.toString().trim();
        },
      );
    }

    Widget buildPasswordField() {
      return TextFormField(
        obscureText: hidePass,
        decoration: InputDecoration(
          helperText: ' ',
          contentPadding: EdgeInsets.symmetric(
            vertical: _mediaQuery.size.height * 0.05,
            horizontal: _mediaQuery.size.height * 0.015,
          ),
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
              fontSize: _mediaQuery.size.height * 0.023,
              fontWeight: FontWeight.w800),
          errorStyle: TextStyle(
              fontSize: _mediaQuery.size.height * 0.016,
              fontWeight: FontWeight.w800),
        ),
        style: TextStyle(
          fontSize: _mediaQuery.size.height * 0.023,
        ),
        textInputAction: TextInputAction.done,
        validator: (value) {
          if (value.toString().trim().isEmpty) {
            return 'Password is Required';
          }
          return null;
        },
        onSaved: (input) {
          _password = input.toString().trim();
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  ),
                  SizedBox(
                    height: (_mediaQuery.size.height - _appBarHieght) * 0.26,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: (_mediaQuery.size.width * 0.09),
                    ),
                    child: Container(
                      height: (_mediaQuery.size.height - _appBarHieght) * 0.1,
                      width: _mediaQuery.size.width,
                      child: buildEmailField(),
                    ),
                  ),
                  SizedBox(
                    height: (_mediaQuery.size.height - _appBarHieght) * 0.025,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: (_mediaQuery.size.width * 0.09),
                    ),
                    child: Container(
                      height: (_mediaQuery.size.height - _appBarHieght) * 0.1,
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
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(ResetPasswordScreen.routeName);
                      },
                    ),
                  ),
                  SizedBox(
                    height: (_mediaQuery.size.height - _appBarHieght) * 0.045,
                  ),
                  //Login Btn
                  _isLoading
                      ? CircularProgressIndicator(
                          strokeWidth: 4,
                          backgroundColor: _theme.shadowColor,
                          color: Colors.white,
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: _mediaQuery.size.width * 0.09),
                          child: Container(
                            height: (_mediaQuery.size.height - _appBarHieght) *
                                0.08,
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      _theme.secondaryHeaderColor),
                                  elevation: MaterialStateProperty.all(5),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                child: _isLoading
                                    ? CircularProgressIndicator()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'LOGIN',
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize:
                                                    (_mediaQuery.size.height -
                                                            _appBarHieght) *
                                                        0.03,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width:
                                                _mediaQuery.size.width * 0.02,
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
                    height: (_mediaQuery.size.height - _appBarHieght) * 0.1,
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
                                  .pushNamed(SignupScreen.routeName);
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
