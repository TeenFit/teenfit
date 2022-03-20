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
  // void _showToast(String msg) {
  //   Fluttertoast.showToast(
  //     msg: msg,
  //     gravity: ToastGravity.CENTER,
  //     timeInSecForIosWeb: 10,
  //     webShowClose: true,
  //     textColor: Colors.white,
  //     backgroundColor: Colors.grey.shade700,
  //   );
  // }

  // Future<void> _refreshWorkouts(BuildContext context) async {
  //   setState(() {
  //     isLoading = true;
  //   });

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

    final fsb = FloatingSearchBar.of(context);

    final queryWorkout = widget.searchTerm == null
        ? FirebaseFirestore.instance
            .collection('/workouts')
            .where('pending', isEqualTo: false)
            .orderBy('date', descending: true)
            .withConverter<Workout>(
                fromFirestore: (snapshot, _) =>
                    Workout.fromJson(snapshot.data()!),
                toFirestore: (worKout, _) => worKout.toJson())
        : FirebaseFirestore.instance
            .collection('/workouts')
            .where('pending', isEqualTo: false)
            .where('searchTerms', arrayContains: widget.searchTerm.toString())
            .orderBy('date', descending: true)
            .withConverter<Workout>(
                fromFirestore: (snapshot, _) =>
                    Workout.fromJson(snapshot.data()!),
                toFirestore: (worKout, _) => worKout.toJson());

    return SingleChildScrollView(
      child: Container(
        height: _mediaQuery.size.height,
        width: _mediaQuery.size.width,
        // child: isLoading
        //     ? Center(
        //         child: CircularProgressIndicator(
        //           strokeWidth: 4,
        //           backgroundColor: _theme.shadowColor,
        //           color: Colors.white,
        //         ),
        //       )
        //     : RefreshIndicator(
        //         onRefresh: () async {
        //           // return await _refreshWorkouts(context);
        //         },
        child: Padding(
          padding: EdgeInsets.all(15),
          child: FirestoreListView<Workout>(
            padding: EdgeInsets.only(
                top: fsb!.value.height + fsb.value.margins.vertical),
            query: queryWorkout,
            pageSize: 5,
            itemBuilder: (context, snapshot) {
              final workout = snapshot.data();
              return WorkoutTile(
                workout,
                false,
                false,
              );
            },
          ),
          // child: ListView.builder(
          //   padding: EdgeInsets.only(
          //       top: fsb!.value.height + fsb.value.margins.vertical),
          //   itemBuilder: (ctx, index) {
          //     if (widget.searchTerm == null) {
          //       return WorkoutTile(
          //         workoutprovider.isNotPendingWorkouts()[index],
          //         false,
          //         false,
          //       );
          //     } else if (workoutprovider
          //         .findByName(widget.searchTerm!)
          //         .toList()
          //         .isEmpty) {
          //       return Container(
          //         height: (_mediaQuery.size.height - _appBarHieght),
          //         width: _mediaQuery.size.width,
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             SizedBox(
          //               height:
          //                   (_mediaQuery.size.height - _appBarHieght) *
          //                       0.05,
          //             ),
          //             Container(
          //               height:
          //                   (_mediaQuery.size.height - _appBarHieght) *
          //                       0.05,
          //               width: _mediaQuery.size.width * 0.8,
          //               child: FittedBox(
          //                 fit: BoxFit.fitWidth,
          //                 child: Text(
          //                   'No Search Results Available...',
          //                   textAlign: TextAlign.center,
          //                   style: TextStyle(
          //                     color: Colors.white,
          //                     fontSize: _mediaQuery.size.height * 0.025,
          //                     fontWeight: FontWeight.bold,
          //                     fontFamily: 'Roboto',
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       );
          //     } else {
          //       return WorkoutTile(
          //         workoutprovider.findByName(widget.searchTerm!)[index],
          //         false,
          //         false,
          //       );
          //     }
          //   },
          //   itemCount: widget.searchTerm != null
          //       ? workoutprovider
          //               .findByName(widget.searchTerm!)
          //               .toList()
          //               .isEmpty
          //           ? 1
          //           : workoutprovider
          //               .findByName(widget.searchTerm!)
          //               .length
          //       : workoutprovider.isNotPendingWorkouts().length,
          // ),
        ),
      ),
      // ),
    );
  }
}
