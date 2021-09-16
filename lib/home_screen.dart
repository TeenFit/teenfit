import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/providers/workout.dart';
import 'package:teenfit/providers/workouts.dart';
import 'package:teenfit/widgets/main_drawer.dart';
import 'package:teenfit/widgets/search_result_workouts.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FloatingSearchBarController controller;

  @override
  void didChangeDependencies() {
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(null);
    workouts = Provider.of<Workouts>(context).workouts;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  late List<Workout> workouts;

  static const historyLength = 3;

  List<String> _searchHistory = [
    'fuchsia',
    'flutter',
    'widgets',
    'resocoder',
  ];

  late List<String> filteredSearchHistory;

  String? selectedTerm;

  List<String> filterSearchTerms(
    String? filter,
  ) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.where((term) => term.startsWith(filter)).toList();
    } else {
      return _searchHistory.toList();
    }
  }

  void addSearchTerm(String term) {
    //removes duplicates
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }
    _searchHistory.insert(0, term);

    //reduces lenght of search history
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }
    // Changes in _searchHistory mean that we have to update the filteredSearchHistory
    filteredSearchHistory = filterSearchTerms(null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   controller = FloatingSearchBarController();
  //   filteredSearchHistory = filterSearchTerms(null);
  // }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    return Scaffold(
      drawer: MainDrawer(),
      backgroundColor: _theme.primaryColor,
      body: FloatingSearchBar(
        actions: [FloatingSearchBarAction.searchToClear()],
        transition: CircularFloatingSearchBarTransition(),
        physics: BouncingScrollPhysics(),
        title: Text(
          selectedTerm ?? 'Search...',
          style: Theme.of(context).textTheme.headline6,
        ),
        hint: 'Search...',
        controller: controller,
        body: FloatingSearchBarScrollNotifier(
          child: SearchResultWorkouts(
            null,
          ),
        ),
        onQueryChanged: (query) {
          setState(() {
            filteredSearchHistory = filterSearchTerms(query);
          });
        },
        onSubmitted: (query) {
          setState(() {
            addSearchTerm(query);
            selectedTerm = query;
          });
          controller.close();
        },
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: Colors.accents.map((color) {
                  return Container(height: 112, color: color);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
