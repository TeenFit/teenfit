import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/providers/auth.dart';
import 'package:teenfit/screens/admin_screen.dart';
import 'package:teenfit/screens/privacy_policy_screen.dart';

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_mediaQuery.size.height * 0.07),
        child: AppBar(
          elevation: 5,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
          backgroundColor: _theme.secondaryHeaderColor,
          foregroundColor: Colors.white,
          title: Text(
            'User Controls',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: _appBarHieght * 0.3),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: _theme.primaryColor,
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
              ListTile(
                leading: Icon(
                  // Icons.person_rounded,
                  Icons.picture_as_pdf,
                  size: _mediaQuery.size.height * 0.04,
                  color: Colors.black,
                ),
                title: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w900,
                    fontSize: _mediaQuery.size.height * 0.04,
                  ),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(PrivacyPolicyScreen.routeName);
                },
              ),
              Divider(
                thickness: 1.3,
                color: Colors.black,
                indent: 20,
                endIndent: 20,
              ),
              auth.isAuth()
                  ? _isLoading
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
                        )
                  : SizedBox(),
              auth.isAuth()
                  ? Divider(
                      thickness: 1.3,
                      color: Colors.black,
                      endIndent: 20,
                      indent: 20,
                    )
                  : SizedBox(),
              auth.isAdmin()
                  ? ListTile(
                      leading: Icon(
                        Icons.check_box,
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
