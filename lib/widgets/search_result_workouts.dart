import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:teenfit/providers/workout.dart';
import '../widgets/workout_tile.dart';

class SearchResultWorkouts extends StatefulWidget {
  final Query<Workout>? queryWorkout;
  final bool? isPlanning;
  final String? day;

  SearchResultWorkouts(this.queryWorkout, this.isPlanning, this.day);

  @override
  State<SearchResultWorkouts> createState() => _SearchResultWorkoutsState();
}

class _SearchResultWorkoutsState extends State<SearchResultWorkouts> {
  var searcHTerm;

  Future<void> _refreshWorkouts(BuildContext context) async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    final fsb = FloatingSearchBar.of(context);

    // userQuery = widget.searchTerm != null
    //     ? FirebaseFirestore.instance
    //         .collection('/users')
    //         .where('searchterms',
    //             arrayContains: widget.searchTerm.toString().trim())
    //         .orderBy('date', descending: true)
    //         .withConverter<User>(
    //             fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
    //             toFirestore: (useR, _) => useR.toJson())
    //     : null;

    return Container(
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
              height: (_mediaQuery.size.height),
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
            query: widget.queryWorkout!,
            pageSize: 5,
            itemBuilder: (context, snapshot) {
              final workout = snapshot.data();
              return snapshot.exists
                  ? Container(
                      height: (_mediaQuery.size.height - _appBarHieght) * 0.22,
                      child: WorkoutTile(
                          workout,
                          false,
                          false,
                          false,
                          widget.isPlanning!,
                          false,
                           widget.day,),
                    )
                  : Container(
                      height: (_mediaQuery.size.height - _appBarHieght),
                      width: _mediaQuery.size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: (_mediaQuery.size.height - _appBarHieght) *
                                0.05,
                          ),
                          Container(
                            height: (_mediaQuery.size.height - _appBarHieght) *
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
    );
  }
}
