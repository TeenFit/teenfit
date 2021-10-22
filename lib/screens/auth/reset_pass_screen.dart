import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

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
      backgroundColor: Colors.yellow.shade900,
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
      _showToast('Could not Reset Password, Connect To Servers');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildEmailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        errorMaxLines: 1,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        labelText: 'Email',
        hintText: 'example@gmail.com',
        labelStyle: TextStyle(fontSize: 15),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Password Reset',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: _appBarHieght * 0.45,
            letterSpacing: 1,
            fontFamily: 'Anton',
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: _theme.primaryColor,
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        height: (_mediaQuery.size.height - _appBarHieght) + 100,
        width: _mediaQuery.size.width,
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: (_mediaQuery.size.height - _appBarHieght) * 0.03,
                ),
                Container(
                  height: (_mediaQuery.size.height - _appBarHieght) * 0.3,
                  child: Image.asset(
                    'assets/images/forgot_pass.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: (_mediaQuery.size.height - _appBarHieght) * 0.02,
                ),
                Text(
                  'Enter Your Email And We Will Send You Instructions.',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: (_mediaQuery.size.height - _appBarHieght) * 0.04,
                  ),
                ),
                SizedBox(
                  height: (_mediaQuery.size.height - _appBarHieght) * 0.1,
                ),
                Container(
                  height: (_mediaQuery.size.height - _appBarHieght) * 0.1,
                  child: _buildEmailField(),
                ),
                SizedBox(
                  height: (_mediaQuery.size.height - _appBarHieght) * 0.05,
                ),

                //Login Btn
                Container(
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
                        ? CircularProgressIndicator()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.email,
                                color: Colors.white,
                                size:
                                    (_mediaQuery.size.height - _appBarHieght) *
                                        0.04,
                              ),
                              SizedBox(
                                width: _mediaQuery.size.width * 0.02,
                              ),
                              Text(
                                'Send Instructions',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: (_mediaQuery.size.height -
                                            _appBarHieght) *
                                        0.03,
                                    letterSpacing: 1),
                              ),
                            ],
                          ),
                    onPressed: () {
                      _submit();
                    },
                  ),
                ),
                SizedBox(
                  height: (_mediaQuery.size.height - _appBarHieght) * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
