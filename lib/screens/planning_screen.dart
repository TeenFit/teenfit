import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/screens/day_scedule_screen.dart';

import '../providers/adState.dart';
import '../providers/auth.dart';
import '../providers/user.dart';
import '../providers/userProv.dart';

class PlanningScreen extends StatefulWidget {
  final User? userData;

  PlanningScreen(this.userData);

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  User? userData;
  bool isLoading = false;
  bool isInit = false;
  late InterstitialAd _interstitialAd;
  var adProv;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (isInit == false) {
      userData = widget.userData;
      adProv = Provider.of<AdState>(context);
      setState(() {
        isInit = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: _theme.primaryColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_mediaQuery.size.height * 0.07),
        child: AppBar(
          elevation: 5,
          backgroundColor: _theme.secondaryHeaderColor,
          foregroundColor: Colors.white,
          title: Text(
            'Plan Workouts',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: _appBarHieght * 0.3),
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                backgroundColor: _theme.shadowColor,
                color: _theme.secondaryHeaderColor,
              ),
            )
          : Container(
              color: _theme.primaryColor,
              height: _mediaQuery.size.height - _appBarHieght,
              width: _mediaQuery.size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Divider(
                    thickness: 3,
                    color: Colors.black,
                  ),
                  ListTile(
                    title: Text(
                      'MONDAY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w900,
                        fontSize: _mediaQuery.size.height * 0.04,
                      ),
                    ),
                    onTap: () async {
                      if (Provider.of<Auth>(context, listen: false).isAdmin()) {
                        final result = await Navigator.of(context).pushNamed(
                            DaySchedule.routeName,
                            arguments: {'day': 'Monday', 'user': userData});

                        if (result == 'fam') {
                          setState(() {
                            isLoading = true;
                          });

                          final userProv =
                              Provider.of<UserProv>(context, listen: false);
                          await userProv.fetchAndSetUser(context);

                          setState(() {
                            userData = userProv.getUser;
                            isLoading = false;
                          });
                        }
                      } else {
                        // show ads here
                        if (adProv.isAdLoaded == true) {
                          await adProv.interstitialAd.show();
                        }
                        final result = await Navigator.of(context).pushNamed(
                            DaySchedule.routeName,
                            arguments: {'day': 'Monday', 'user': userData});

                        if (result == 'fam') {
                          setState(() {
                            isLoading = true;
                          });

                          final userProv =
                              Provider.of<UserProv>(context, listen: false);
                          await userProv.fetchAndSetUser(context);

                          setState(() {
                            userData = userProv.getUser;
                            isLoading = false;
                          });
                        }
                      }
                    },
                  ),
                  Divider(
                    thickness: 3,
                    color: Colors.black,
                  ),
                  ListTile(
                    title: Text(
                      'TUESDAY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w900,
                        fontSize: _mediaQuery.size.height * 0.04,
                      ),
                    ),
                    onTap: () async {
                      if (Provider.of<Auth>(context, listen: false).isAdmin()) {
                        final result = await Navigator.of(context).pushNamed(
                            DaySchedule.routeName,
                            arguments: {'day': 'Tuesday', 'user': userData});

                        if (result == 'fam') {
                          setState(() {
                            isLoading = true;
                          });

                          final userProv =
                              Provider.of<UserProv>(context, listen: false);
                          await userProv.fetchAndSetUser(context);

                          setState(() {
                            userData = userProv.getUser;
                            isLoading = false;
                          });
                        }
                      } else {
                        // show ads here
                        if (adProv.isAdLoaded == true) {
                          await adProv.interstitialAd.show();
                        }
                        final result = await Navigator.of(context).pushNamed(
                            DaySchedule.routeName,
                            arguments: {'day': 'Tuesday', 'user': userData});

                        if (result == 'fam') {
                          setState(() {
                            isLoading = true;
                          });

                          final userProv =
                              Provider.of<UserProv>(context, listen: false);
                          await userProv.fetchAndSetUser(context);

                          setState(() {
                            userData = userProv.getUser;
                            isLoading = false;
                          });
                        }
                      }
                    },
                  ),
                  Divider(
                    thickness: 3,
                    color: Colors.black,
                  ),
                  ListTile(
                    title: Text(
                      'WEDNESDAY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w900,
                        fontSize: _mediaQuery.size.height * 0.04,
                      ),
                    ),
                    onTap: () async {
                      if (Provider.of<Auth>(context, listen: false).isAdmin()) {
                        final result = await Navigator.of(context).pushNamed(
                            DaySchedule.routeName,
                            arguments: {'day': 'Wednesday', 'user': userData});

                        if (result == 'fam') {
                          setState(() {
                            isLoading = true;
                          });

                          final userProv =
                              Provider.of<UserProv>(context, listen: false);
                          await userProv.fetchAndSetUser(context);

                          setState(() {
                            userData = userProv.getUser;
                            isLoading = false;
                          });
                        }
                      } else {
                        // show ads here
                        if (adProv.isAdLoaded == true) {
                          await adProv.interstitialAd.show();
                        }
                        final result = await Navigator.of(context).pushNamed(
                            DaySchedule.routeName,
                            arguments: {'day': 'Wednesday', 'user': userData});

                        if (result == 'fam') {
                          setState(() {
                            isLoading = true;
                          });

                          final userProv =
                              Provider.of<UserProv>(context, listen: false);
                          await userProv.fetchAndSetUser(context);

                          setState(() {
                            userData = userProv.getUser;
                            isLoading = false;
                          });
                        }
                      }
                    },
                  ),
                  Divider(
                    thickness: 3,
                    color: Colors.black,
                  ),
                  ListTile(
                    title: Text(
                      'THURSDAY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w900,
                        fontSize: _mediaQuery.size.height * 0.04,
                      ),
                    ),
                    onTap: () async {
                      if (Provider.of<Auth>(context, listen: false).isAdmin()) {
                        final result = await Navigator.of(context).pushNamed(
                            DaySchedule.routeName,
                            arguments: {'day': 'Thursday', 'user': userData});

                        if (result == 'fam') {
                          setState(() {
                            isLoading = true;
                          });

                          final userProv =
                              Provider.of<UserProv>(context, listen: false);
                          await userProv.fetchAndSetUser(context);

                          setState(() {
                            userData = userProv.getUser;
                            isLoading = false;
                          });
                        }
                      } else {
                        // show ads here
                        if (adProv.isAdLoaded == true) {
                          await adProv.interstitialAd.show();
                        }
                        final result = await Navigator.of(context).pushNamed(
                            DaySchedule.routeName,
                            arguments: {'day': 'Thursday', 'user': userData});

                        if (result == 'fam') {
                          setState(() {
                            isLoading = true;
                          });

                          final userProv =
                              Provider.of<UserProv>(context, listen: false);
                          await userProv.fetchAndSetUser(context);

                          setState(() {
                            userData = userProv.getUser;
                            isLoading = false;
                          });
                        }
                      }
                    },
                  ),
                  Divider(
                    thickness: 3,
                    color: Colors.black,
                  ),
                  ListTile(
                    title: Text(
                      'FRIDAY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w900,
                        fontSize: _mediaQuery.size.height * 0.04,
                      ),
                    ),
                    onTap: () async {
                      if (Provider.of<Auth>(context, listen: false).isAdmin()) {
                        final result = await Navigator.of(context).pushNamed(
                            DaySchedule.routeName,
                            arguments: {'day': 'Firday', 'user': userData});

                        if (result == 'fam') {
                          setState(() {
                            isLoading = true;
                          });

                          final userProv =
                              Provider.of<UserProv>(context, listen: false);
                          await userProv.fetchAndSetUser(context);

                          setState(() {
                            userData = userProv.getUser;
                            isLoading = false;
                          });
                        }
                      } else {
                        // show ads here
                        if (adProv.isAdLoaded == true) {
                          await adProv.interstitialAd.show();
                        }
                        final result = await Navigator.of(context).pushNamed(
                            DaySchedule.routeName,
                            arguments: {'day': 'Friday', 'user': userData});

                        if (result == 'fam') {
                          setState(() {
                            isLoading = true;
                          });

                          final userProv =
                              Provider.of<UserProv>(context, listen: false);
                          await userProv.fetchAndSetUser(context);

                          setState(() {
                            userData = userProv.getUser;
                            isLoading = false;
                          });
                        }
                      }
                    },
                  ),
                  Divider(
                    thickness: 3,
                    color: Colors.black,
                  ),
                  ListTile(
                    title: Text(
                      'SATURDAY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w900,
                        fontSize: _mediaQuery.size.height * 0.04,
                      ),
                    ),
                    onTap: () async {
                      if (Provider.of<Auth>(context, listen: false).isAdmin()) {
                        final result = await Navigator.of(context).pushNamed(
                            DaySchedule.routeName,
                            arguments: {'day': 'Saturday', 'user': userData});

                        if (result == 'fam') {
                          setState(() {
                            isLoading = true;
                          });

                          final userProv =
                              Provider.of<UserProv>(context, listen: false);
                          await userProv.fetchAndSetUser(context);

                          setState(() {
                            userData = userProv.getUser;
                            isLoading = false;
                          });
                        }
                      } else {
                        // show ads here
                        if (adProv.isAdLoaded == true) {
                          await adProv.interstitialAd.show();
                        }
                        final result = await Navigator.of(context).pushNamed(
                            DaySchedule.routeName,
                            arguments: {'day': 'Saturday', 'user': userData});

                        if (result == 'fam') {
                          setState(() {
                            isLoading = true;
                          });

                          final userProv =
                              Provider.of<UserProv>(context, listen: false);
                          await userProv.fetchAndSetUser(context);

                          setState(() {
                            userData = userProv.getUser;
                            isLoading = false;
                          });
                        }
                      }
                    },
                  ),
                  Divider(
                    thickness: 3,
                    color: Colors.black,
                  ),
                  ListTile(
                    title: Text(
                      'SUNDAY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w900,
                        fontSize: _mediaQuery.size.height * 0.04,
                      ),
                    ),
                    onTap: () async {
                      if (Provider.of<Auth>(context, listen: false).isAdmin()) {
                        final result = await Navigator.of(context).pushNamed(
                            DaySchedule.routeName,
                            arguments: {'day': 'Sunday', 'user': userData});

                        if (result == 'fam') {
                          setState(() {
                            isLoading = true;
                          });

                          final userProv =
                              Provider.of<UserProv>(context, listen: false);
                          await userProv.fetchAndSetUser(context);

                          setState(() {
                            userData = userProv.getUser;
                            isLoading = false;
                          });
                        }
                      } else {
                        // show ads here
                        if (adProv.isAdLoaded == true) {
                          await adProv.interstitialAd.show();
                        }
                        final result = await Navigator.of(context).pushNamed(
                            DaySchedule.routeName,
                            arguments: {'day': 'Sunday', 'user': userData});

                        if (result == 'fam') {
                          setState(() {
                            isLoading = true;
                          });

                          final userProv =
                              Provider.of<UserProv>(context, listen: false);
                          await userProv.fetchAndSetUser(context);

                          setState(() {
                            userData = userProv.getUser;
                            isLoading = false;
                          });
                        }
                      }
                    },
                  ),
                  Divider(
                    thickness: 3,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
    );
  }
}
