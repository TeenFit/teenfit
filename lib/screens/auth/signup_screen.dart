import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '/Custom/http_execption.dart';
import '/providers/auth.dart';
import './login_screen.dart';
// import '../home_screen.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup-screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool hidePass = true;
  bool confirmPassHide = true;
  bool _isLoading = false;

  TextEditingController textEditingController = TextEditingController();
  final GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    Provider.of<Auth>(context).updateToken();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    String _email = 'email';
    String _password = 'password';

    void _showToast(String msg) {
      Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 10,
        webShowClose: true,
        textColor: Colors.white,
        backgroundColor: Colors.grey.shade800,
      );
    }

    void _submit() async {
      if (!_formkey1.currentState!.validate()) {
        return;
      }

      _formkey1.currentState!.save();
      print(_email);
      print(_password);

      setState(() {
        _isLoading = true;
      });

      //signup logic:
      try {
        await Provider.of<Auth>(context, listen: false)
            .signup(_email, _password, context);
      } on HttpException catch (error) {
        var errorMessage = 'Could Not Create Account, Try Again Later';
        if (error.toString().contains('weak-password')) {
          errorMessage = ('This Password Is To Weak');
        } else if (error.toString().contains('email-already-in-use')) {
          errorMessage = ('An Account Already Exists For That Email');
        } else if (error.toString().contains('invalid-email')) {
          errorMessage = 'This Email Address Does Not Exist';
        }
        _showToast(errorMessage);
      } catch (_) {
        _showToast('Could Not Create Account, Try Again Later');
      }

      setState(() {
        _isLoading = false;
      });
    }

    Widget buildEmailField() {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (_mediaQuery.size.width * 0.09),
        ),
        child: Container(
          height: (_mediaQuery.size.height - _appBarHieght) * 0.1,
          width: _mediaQuery.size.width,
          child: TextFormField(
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
                fontWeight: FontWeight.w800,
              ),
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
            onSaved: (value) {
              _email = value.toString().trim();
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
          height: (_mediaQuery.size.height - _appBarHieght) * 0.1,
          width: _mediaQuery.size.width,
          child: TextFormField(
            controller: textEditingController,
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
                  setState(() {
                    hidePass = !hidePass;
                  });
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
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.toString().trim().isEmpty) {
                return 'Password is Required';
              }
              return null;
            },
            onSaved: (value) {
              _password = value.toString().trim();
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
          height: (_mediaQuery.size.height - _appBarHieght) * 0.1,
          width: _mediaQuery.size.width,
          child: TextFormField(
            obscureText: confirmPassHide,
            decoration: InputDecoration(
                helperText: ' ',
                contentPadding: EdgeInsets.symmetric(
                  vertical: _mediaQuery.size.height * 0.05,
                  horizontal: _mediaQuery.size.height * 0.015,
                ),
                suffixIcon: IconButton(
                  icon: Icon(confirmPassHide
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      confirmPassHide = !confirmPassHide;
                    });
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
                    fontSize: _mediaQuery.size.height * 0.023,
                    fontWeight: FontWeight.w800),
                errorStyle: TextStyle(
                    fontSize: _mediaQuery.size.height * 0.016,
                    fontWeight: FontWeight.w800)),
            style: TextStyle(
              fontSize: _mediaQuery.size.height * 0.023,
            ),
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value.toString().trim() !=
                  textEditingController.text.trim()) {
                return 'Password do Not Match';
              }
              return null;
            },
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
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
            child: SingleChildScrollView(
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
                    height: (_mediaQuery.size.height - _appBarHieght) * 0.25,
                  ),
                  buildEmailField(),
                  SizedBox(
                    height: (_mediaQuery.size.height - _appBarHieght) * 0.025,
                  ),
                  buildPasswordField(),
                  SizedBox(
                    height: (_mediaQuery.size.height - _appBarHieght) * 0.025,
                  ),
                  buildConfirmPasswordField(),
                  SizedBox(
                    height: (_mediaQuery.size.height - _appBarHieght) * 0.025,
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
                        child: _isLoading
                            ? CircularProgressIndicator(
                                strokeWidth: 4,
                                backgroundColor: _theme.shadowColor,
                                color: Colors.white,
                              )
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
                    height: (_mediaQuery.size.height - _appBarHieght) * 0.19,
                  ),
                  //switch screens
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: _mediaQuery.size.width * 0.09),
                    child: Container(
                      height: (_mediaQuery.size.height - _appBarHieght) * 0.08,
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
