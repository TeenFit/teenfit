import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:teenfit/providers/workout.dart';

import '/providers/workouts.dart';
import '../widgets/main_drawer.dart';
import '../widgets/search_result_workouts.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FloatingSearchBarController controller = FloatingSearchBarController();
  bool isLoading = false;

  bool connected = true;

  static const historyLength = 3;

  List<String> _searchHistory = [
    'Body Weight Workout',
    'Dumbell Workout',
    'Advanced Body Weight'
  ];

  late List<String> filteredSearchHistory;

  String? selectedTerm;
  bool isInit = false;

  List<String> filterSearchTerms(
    String? filter,
  ) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.where((term) => term.startsWith(filter)).toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  @override
  void didChangeDependencies() async {
    setState(() {
      filteredSearchHistory = filterSearchTerms(null);
    });

    if (isInit == false) {
      setState(() {
        isLoading = true;
      });

      try {
        await Provider.of<Workouts>(context)
            .fetchAndSetWorkout()
            .onError((error, stackTrace) =>
                _showToast('Unable To Load New Workouts, Try Again Later'))
            .then((_) => Future.delayed(Duration(seconds: 2)));
      } catch (e) {
        _showToast('Unable To Load New Workouts, Try Again Later');
      }

      if (this.mounted) {
        setState(() {
          isLoading = false;
          isInit = true;
        });
      }
    }

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (this.mounted) {
        setState(() {
          connected = false;
        });
      }
    } else if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet ||
        connectivityResult == ConnectivityResult.mobile) {
      if (this.mounted) {
        setState(() {
          connected = true;
        });
      }
    }

    Connectivity().onConnectivityChanged.listen((event) async {
      if (this.mounted) {
        await Phoenix.rebirth(context);
      }
    });

    super.didChangeDependencies();
  }

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

  void addSearchTerm(String term) {
    //removes duplicates
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }
    _searchHistory.add(term);

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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);

    return Scaffold(
      drawer: MainDrawer(connected),
      backgroundColor: _theme.primaryColor,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                backgroundColor: _theme.shadowColor,
                color: Colors.white,
              ),
            )
          : FloatingSearchBar(
              backgroundColor: Colors.white,
              borderRadius: BorderRadius.circular(20),
              margins: EdgeInsets.fromLTRB(
                20,
                _mediaQuery.size.height * 0.05,
                20,
                0,
              ),
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
                  selectedTerm,
                ),
              ),
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
                    elevation: 4,
                    child: Builder(
                      builder: (context) {
                        if (filteredSearchHistory.isEmpty &&
                            controller.query.isEmpty) {
                          return Column(
                            children: [
                              Container(
                                height: 56,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text(
                                  'Start searching',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: _mediaQuery.size.height * 0.02,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  width: double.infinity,
                                  height: _mediaQuery.size.height * 0.05,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: _theme.primaryColor),
                                    onPressed: () {
                                      setState(() {
                                        selectedTerm = null;
                                      });
                                      controller.close();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Clear Search',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                _mediaQuery.size.height * 0.028,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                        Icon(Icons.clear),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        } else if (filteredSearchHistory.isEmpty) {
                          return ListTile(
                            title: Text(controller.query),
                            leading: const Icon(Icons.search),
                            onTap: () {
                              setState(() {
                                addSearchTerm(controller.query);
                                selectedTerm = controller.query;
                              });
                              controller.close();
                            },
                          );
                        } else {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ...filteredSearchHistory
                                  .map(
                                    (term) => ListTile(
                                      title: Text(
                                        term,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      leading: const Icon(Icons.history),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          setState(() {
                                            deleteSearchTerm(term);
                                          });
                                        },
                                      ),
                                      onTap: () {
                                        setState(() {
                                          putSearchTermFirst(term);
                                          selectedTerm = term;
                                        });
                                        controller.close();
                                      },
                                    ),
                                  )
                                  .toList(),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  width: double.infinity,
                                  height: _mediaQuery.size.height * 0.05,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: _theme.primaryColor),
                                    onPressed: () {
                                      setState(() {
                                        selectedTerm = null;
                                      });
                                      controller.close();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Clear Search',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                _mediaQuery.size.height * 0.028,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                        Icon(Icons.clear),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
