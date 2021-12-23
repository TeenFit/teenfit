import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/providers/auth.dart';
import 'package:teenfit/screens/admin_screen.dart';

//Add User Screen (Contains, access to saved workouts, privacy policy and logout button)

class UserScreen extends StatefulWidget {
  static const routeName = '/user-screen';

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    var auth = Provider.of<Auth>(context);

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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _theme.primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          'User Controls',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: _appBarHieght * 0.35),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: _mediaQuery.size.height - _appBarHieght,
          width: _mediaQuery.size.width,
          child: Column(
            children: [
              SizedBox(
                height: _mediaQuery.size.height * 0.05,
              ),
              Container(
                width: double.infinity,
                height: (_mediaQuery.size.height - _appBarHieght) * 0.15,
                child: Image.asset(
                  'assets/images/teen_fit_logo_withtext_white.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: _mediaQuery.size.height * 0.05,
              ),
              Divider(
                thickness: 1.3,
                color: Colors.black,
                indent: 20,
                endIndent: 20,
              ),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        backgroundColor: _theme.shadowColor,
                        color: Colors.black,
                      ),
                    )
                  : ListTile(
                      leading: Icon(
                        Icons.logout,
                        size: _mediaQuery.size.height * 0.04,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Log Out?',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w900,
                          fontSize: _mediaQuery.size.height * 0.04,
                        ),
                      ),
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          await auth.logout(context);
                        } catch (e) {
                          _showToast('Unable To Logout Try Again Later');
                        }
                        if (this.mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                    ),
              Divider(
                thickness: 1.3,
                color: Colors.black,
                endIndent: 20,
                indent: 20,
              ),
              auth.isAdmin()
                  ? ListTile(
                      leading: Icon(
                        Icons.logout,
                        size: _mediaQuery.size.height * 0.04,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Admin',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w900,
                          fontSize: _mediaQuery.size.height * 0.04,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(AdminScreen.routeName);
                      },
                    )
                  : SizedBox(),
              auth.isAdmin()
                  ? Divider(
                      thickness: 1.3,
                      color: Colors.black,
                      endIndent: 20,
                      indent: 20,
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
