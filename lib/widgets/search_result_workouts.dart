import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:teenfit/providers/workout.dart';

import '../widgets/workout_tile.dart';

class SearchResultWorkouts extends StatefulWidget {
  final String? searchTerm;

  SearchResultWorkouts(this.searchTerm);

  @override
  State<SearchResultWorkouts> createState() => _SearchResultWorkoutsState();
}

class _SearchResultWorkoutsState extends State<SearchResultWorkouts> {
  // bool isInit = false;

  // @override
  // void didChangeDependencies() async {
  //   super.didChangeDependencies();

  //   if (isInit == false) {
  //     final auth = Provider.of<Workouts>(context, listen: false);

  //     FirebaseFirestore.instance
  //         .collection('/workouts')
  //         .where('failed', isEqualTo: true)
  //         .where('date',
  //             isNotEqualTo:
  //                 DateTime.now().subtract(Duration(days: 15)).toString())
  //         .snapshots()
  //         .map(
  //           (snapshot) => snapshot.docs.map((e) =>
  //               //  auth.deleteWorkout(
  //               // e.data()['workoutId'],
  //               _showToast('delete' + e.data()['workoutName'])),
  //         );

  //     setState(() {
  //       isInit = true;
  //     });
  //   }
  // }

  // void _showToast(String msg) {
  //   Fluttertoast.showToast(
  //     toastLength: Toast.LENGTH_LONG,
  //     msg: msg,
  //     gravity: ToastGravity.CENTER,
  //     timeInSecForIosWeb: 10,
  //     webShowClose: true,
  //     textColor: Colors.white,
  //     backgroundColor: Colors.grey.shade700,
  //   );
  // }

  Future<void> _refreshWorkouts(BuildContext context) async {
    setState(() {});
  }

  //   // try {
  //   //   await Provider.of<Workouts>(context, listen: false)
  //   //       .fetchAndSetWorkout()
  //   //       .onError(
  //   //         (error, stackTrace) => _showToast('Unable To Refresh Workouts'),
  //   //       );
  //   // } catch (e) {
  //   //   _showToast('Unable To Refresh Workouts');
  //   // }

  //   if (this.mounted) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    final fsb = FloatingSearchBar.of(context);

    final queryWorkout = widget.searchTerm == null
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
            .where('searchTerms', arrayContains: widget.searchTerm.toString())
            .orderBy('date', descending: true)
            .withConverter<Workout>(
                fromFirestore: (snapshot, _) =>
                    Workout.fromJson(snapshot.data()!),
                toFirestore: (worKout, _) => worKout.toJson());

    return SingleChildScrollView(
      child: Container(
        color: _theme.primaryColor,
        height: _mediaQuery.size.height,
        width: _mediaQuery.size.width,
        child: RefreshIndicator(
          onRefresh: () async {
            return await _refreshWorkouts(context);
          },
          child: Padding(
            padding: EdgeInsets.all(15),
            child: FirestoreListView<Workout>(
              errorBuilder: (context, obj, _) => Container(
                height: (_mediaQuery.size.height - _appBarHieght),
                width: _mediaQuery.size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: (_mediaQuery.size.height - _appBarHieght) * 0.05,
                    ),
                    Container(
                      height: (_mediaQuery.size.height - _appBarHieght) * 0.05,
                      width: _mediaQuery.size.width * 0.8,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          'No Search Results Available...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _mediaQuery.size.height * 0.025,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              padding: EdgeInsets.only(
                  top: fsb!.value.height + fsb.value.margins.vertical,
                  bottom: _mediaQuery.padding.bottom),
              query: queryWorkout,
              pageSize: 5,
              itemBuilder: (context, snapshot) {
                final workout = snapshot.data();
                return snapshot.exists
                    ? WorkoutTile(
                        workout,
                        false,
                        false,
                      )
                    : Container(
                        height: (_mediaQuery.size.height - _appBarHieght),
                        width: _mediaQuery.size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height:
                                  (_mediaQuery.size.height - _appBarHieght) *
                                      0.05,
                            ),
                            Container(
                              height:
                                  (_mediaQuery.size.height - _appBarHieght) *
                                      0.05,
                              width: _mediaQuery.size.width * 0.8,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  'No Search Results Available...',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: _mediaQuery.size.height * 0.025,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
