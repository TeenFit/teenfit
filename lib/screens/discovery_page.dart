import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/adState.dart';
import '../providers/auth.dart';
import '../providers/workout.dart';
import '../widgets/search_result_workouts.dart';
import 'create_workout.dart';

class DiscoveryPage extends StatefulWidget {
  static const routeName = 'discovery-page';

  @override
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  FloatingSearchBarController controller2 = FloatingSearchBarController();
  bool? isPlanning;
  String? day;

  static const historyLength = 3;

  List<String> _searchHistory = [
    'Body Weight Workout',
    'Dumbell Workout',
    'Advanced Body Weight'
  ];

  late List<String> filteredSearchHistory;

  String? selectedTerm;
  Query<Workout>? queryWorkout = FirebaseFirestore.instance
      .collection('/workouts')
      .where('pending', isEqualTo: false)
      .where('failed', isEqualTo: false)
      .orderBy('date', descending: true)
      .withConverter<Workout>(
          fromFirestore: (snapshot, _) => Workout.fromJson(snapshot.data()!),
          toFirestore: (worKout, _) => worKout.toJson());

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
    Map? prov = ModalRoute.of(context)!.settings.arguments as Map?;
    var adProv = Provider.of<AdState>(context);

    if (this.mounted) {
      if (!Provider.of<Auth>(context, listen: false).isAdmin() &&
          !adProv.isAdLoaded) {
        adProv.initAd(context);
      }

      setState(() {
        isPlanning = prov == null || prov['isPlanning'] == null
            ? false
            : prov['isPlanning'];

        day = prov == null || prov['day'] == null ? null : prov['day'];

        filteredSearchHistory = filterSearchTerms(null);
      });
    }

    super.didChangeDependencies();
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
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);

    var uuid = Uuid();

    var auth = Provider.of<Auth>(context, listen: false);

    return Scaffold(
      body: FloatingSearchBar(
        backgroundColor: Colors.white,
        borderRadius: BorderRadius.circular(20),
        margins: EdgeInsets.fromLTRB(
          20,
          _mediaQuery.padding.top * 1.3,
          20,
          0,
        ),
        automaticallyImplyBackButton: false,
        autocorrect: true,
        leadingActions: [
          isPlanning!
              ? IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                )
              : SizedBox()
        ],
        actions: [
          FloatingSearchBarAction.searchToClear(),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
          //   child:
          auth.isAuth() && isPlanning != true
              ? IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AddWorkoutScreen.routeName,
                      arguments: {
                        'workout': Workout(
                          views: 0,
                          searchTerms: [],
                          failed: false,
                          pending: true,
                          date: DateTime.now(),
                          creatorId: auth.userId!,
                          workoutId: uuid.v4(),
                          workoutName: '',
                          bannerImage: null,
                          bannerImageLink: null,
                          exercises: [],
                        ),
                        'isEdit': false
                      },
                    );
                  },
                  icon: Icon(
                    Icons.add_box_outlined,
                    color: Colors.black,
                  ),
                )
              : SizedBox(),
          // ),
        ],
        transition: CircularFloatingSearchBarTransition(),
        physics: BouncingScrollPhysics(),
        title: Text(
          selectedTerm ?? 'Search...',
          style: Theme.of(context).textTheme.headline6,
        ),
        hint: 'Search...',
        controller: controller2,
        body: FloatingSearchBarScrollNotifier(
          child: SearchResultWorkouts(
            queryWorkout,
            isPlanning!,
            day,
          ),
        ),
        onSubmitted: (query) {
          setState(() {
            addSearchTerm(query);
            selectedTerm = query;
            queryWorkout = selectedTerm == null
                ? FirebaseFirestore.instance
                    .collection('/workouts')
                    .where('pending', isEqualTo: false)
                    .where('failed', isEqualTo: false)
                    .orderBy('date', descending: true)
                    .withConverter<Workout>(
                        fromFirestore: (snapshot, _) =>
                            Workout.fromJson(snapshot.data()!),
                        toFirestore: (worKout, _) => worKout.toJson())
                : FirebaseFirestore.instance
                    .collection('/workouts')
                    .where('pending', isEqualTo: false)
                    .where('failed', isEqualTo: false)
                    .where('searchTerms',
                        arrayContains:
                            selectedTerm.toString().trim().toLowerCase())
                    .orderBy('date', descending: true)
                    .withConverter<Workout>(
                        fromFirestore: (snapshot, _) =>
                            Workout.fromJson(snapshot.data()!),
                        toFirestore: (worKout, _) => worKout.toJson());
          });
          controller2.close();
        },
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: _theme.primaryColor,
              elevation: 0,
              child: Builder(
                builder: (context) {
                  if (filteredSearchHistory.isEmpty &&
                      controller2.query.isEmpty) {
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
                                  primary: _theme.secondaryHeaderColor),
                              onPressed: () {
                                setState(() {
                                  selectedTerm = null;
                                  queryWorkout = FirebaseFirestore.instance
                                      .collection('/workouts')
                                      .where('pending', isEqualTo: false)
                                      .where('failed', isEqualTo: false)
                                      .orderBy('date', descending: true)
                                      .withConverter<Workout>(
                                          fromFirestore: (snapshot, _) =>
                                              Workout.fromJson(
                                                  snapshot.data()!),
                                          toFirestore: (worKout, _) =>
                                              worKout.toJson());

                                  controller2.close();
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Clear Search',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: _mediaQuery.size.height * 0.028,
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
                      title: Text(controller2.query),
                      leading: const Icon(Icons.search),
                      onTap: () {
                        setState(() {
                          addSearchTerm(controller2.query);
                          selectedTerm = controller2.query;
                          queryWorkout = FirebaseFirestore.instance
                              .collection('/workouts')
                              .where('pending', isEqualTo: false)
                              .where('failed', isEqualTo: false)
                              .where('searchTerms',
                                  arrayContains: controller2.query
                                      .toString()
                                      .trim()
                                      .toLowerCase())
                              .orderBy('date', descending: true)
                              .withConverter<Workout>(
                                  fromFirestore: (snapshot, _) =>
                                      Workout.fromJson(snapshot.data()!),
                                  toFirestore: (worKout, _) =>
                                      worKout.toJson());
                        });
                        controller2.close();
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
                                    queryWorkout = FirebaseFirestore.instance
                                        .collection('/workouts')
                                        .where('pending', isEqualTo: false)
                                        .where('failed', isEqualTo: false)
                                        .where('searchTerms',
                                            arrayContains: term
                                                .toString()
                                                .trim()
                                                .toLowerCase())
                                        .orderBy('date', descending: true)
                                        .withConverter<Workout>(
                                            fromFirestore: (snapshot, _) =>
                                                Workout.fromJson(
                                                    snapshot.data()!),
                                            toFirestore: (worKout, _) =>
                                                worKout.toJson());
                                  });
                                  controller2.close();
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
                                  primary: _theme.secondaryHeaderColor),
                              onPressed: () {
                                setState(() {
                                  selectedTerm = null;
                                  queryWorkout = FirebaseFirestore.instance
                                      .collection('/workouts')
                                      .where('pending', isEqualTo: false)
                                      .where('failed', isEqualTo: false)
                                      .orderBy('date', descending: true)
                                      .withConverter<Workout>(
                                          fromFirestore: (snapshot, _) =>
                                              Workout.fromJson(
                                                  snapshot.data()!),
                                          toFirestore: (worKout, _) =>
                                              worKout.toJson());
                                });
                                controller2.close();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Clear Search',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: _mediaQuery.size.height * 0.028,
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
