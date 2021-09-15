import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/providers/searchbar.dart';
import 'package:teenfit/widgets/main_drawer.dart';
import 'package:teenfit/widgets/search_result_workouts.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   Provider.of<SearchBarFunctions>(context).filteredSearchHistory =
  //       Provider.of<SearchBarFunctions>(context).filterSearchTerms(null);
  // }

  //search bar

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    // var searchBarFunctions = Provider.of<SearchBarFunctions>(context);

    return Scaffold(
      drawer: MainDrawer(),
      backgroundColor: _theme.primaryColor,
      body: SearchResultWorkouts(null),
    );
  }
}
