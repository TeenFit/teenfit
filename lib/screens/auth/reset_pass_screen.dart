import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '/Custom/custom_dialog.dart';
import '/providers/auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const routeName = '/reset-pass-screen';

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String? _email;
  bool _isLoading = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  void _showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 10,
      webShowClose: true,
      textColor: Colors.white,
      backgroundColor: Colors.grey.shade700,
    );
  }

  Future<void> _submit() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    _formkey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .passwordReset(_email!)
          .then((_) => _showToast('Password Reset Email Sent'))
          .then((_) => Navigator.of(context).pop());
    } catch (e) {
      _showToast('Could Not Send Reset Password');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

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
          if (value.toString().isEmpty) {
            return 'Email is Required';
          } else if (!value.toString().contains('@')) {
            return 'Invalid Email';
          } else if (value.toString().contains(' ')) {
            return 'Please Remove Spaces';
          }
          return null;
        },
        onSaved: (input) {
          _email = input.toString();
        },
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
              'assets/images/reset_password.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            height: (_mediaQuery.size.height),
            width: _mediaQuery.size.width,
            child: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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

                    SizedBox(
                      height: (_mediaQuery.size.height - _appBarHieght) * 0.1,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: (_mediaQuery.size.width * 0.09),
                      ),
                      child: Container(
                        height: (_mediaQuery.size.height) * 0.1,
                        width: (_mediaQuery.size.width),
                        child: buildEmailField(),
                      ),
                    ),
                    SizedBox(
                      height: (_mediaQuery.size.height - _appBarHieght) * 0.05,
                    ),

                    //Forgot Pass
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: (_mediaQuery.size.width * 0.09),
                      ),
                      child: Container(
                        height:
                            (_mediaQuery.size.height - _appBarHieght) * 0.08,
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
                              : Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: (_mediaQuery.size.height -
                                              _appBarHieght) *
                                          0.03,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold),
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
                    SizedBox(
                      height: (_mediaQuery.size.height - _appBarHieght) * 0.11,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: _mediaQuery.size.width * 0.09),
                      child: Container(
                        height:
                            (_mediaQuery.size.height - _appBarHieght) * 0.06,
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: TextButton(
                            child: Row(
                              children: [
                                Text(
                                  'Contact Us? | ',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontFamily: 'Roboto',
                                      fontSize: (_mediaQuery.size.height -
                                              _appBarHieght) *
                                          0.01,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Click Here',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Roboto',
                                      fontSize: (_mediaQuery.size.height -
                                              _appBarHieght) *
                                          0.01,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => CustomDialogBox(
                                    'Contact Us',
                                    '''Email us at teenfitness.fit@gmail.com
or Dm us @teenfittest on instagram''',
                                    'assets/images/Phone-Icon.jpg',
                                    'contact-us',
                                    ''),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
