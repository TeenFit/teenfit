import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/providers/auth.dart';
import 'package:teenfit/screens/auth/login_screen.dart';
import 'package:teenfit/screens/discovery_page.dart';
import 'package:teenfit/screens/my_workouts.dart';
import 'package:teenfit/screens/user_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isInit = false;
  Widget? pageView;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit == false) {
      bool isAuth = Provider.of<Auth>(context).isAuth();

      pageView = PageView(
        controller: pageController,
        children: [
          DiscoveryPage(),
          isAuth == true ? CreateWorkout() : LoginScreen(),
          UserScreen(),
        ],
      );
      setState(() {
        isInit = true;
      });
    }
  }

  int _selectedIndex = 0;
  PageController pageController = PageController();

  void onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 800), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);

    return Scaffold(
      body: isInit == false
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                backgroundColor: _theme.shadowColor,
                color: Colors.white,
              ),
            )
          : pageView,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded), label: 'Find'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        elevation: 5,
        currentIndex: _selectedIndex,
        selectedItemColor: _theme.secondaryHeaderColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        backgroundColor: _theme.primaryColor,
        selectedLabelStyle: TextStyle(
          color: _theme.cardColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'PTSans',
          letterSpacing: 1,
        ),
        unselectedLabelStyle: TextStyle(
          color: _theme.cardColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'PTSans',
          letterSpacing: 1,
        ),
        onTap: onTap,
        iconSize: _mediaQuery.size.height * 0.05,
      ),
    );
  }
}
