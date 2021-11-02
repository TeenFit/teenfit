import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

import '../providers/workouts.dart';
import '../widgets/workout_tile.dart';

class SearchResultWorkouts extends StatelessWidget {
  final String? searchTerm;

  SearchResultWorkouts(this.searchTerm);

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _appBarHieght = AppBar().preferredSize.height;

    var workoutprovider = Provider.of<Workouts>(context);

    final fsb = FloatingSearchBar.of(context);

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

    Future<void> _refreshWorkouts(BuildContext context) async {
      try {
        await Provider.of<Workouts>(context, listen: false)
            .fetchAndSetWorkout()
            .onError(
              (error, stackTrace) => _showToast('Unable To Refresh Workouts'),
            );
      } catch (e) {
        _showToast('Unable To Refresh Workouts');
      }
    }

    return SingleChildScrollView(
      child: Container(
        height: _mediaQuery.size.height,
        width: _mediaQuery.size.width,
        child: RefreshIndicator(
          onRefresh: () {
            return _refreshWorkouts(context);
          },
          child: Padding(
            padding: EdgeInsets.all(15),
            child: ListView.builder(
              padding: EdgeInsets.only(
                  top: fsb!.value.height + fsb.value.margins.vertical),
              itemBuilder: (ctx, index) {
                if (searchTerm == null) {
                  return WorkoutTile(
                    workoutprovider.workouts[index],
                    false,
                  );
                } else if (workoutprovider
                    .findByName(searchTerm!)
                    .toList()
                    .isEmpty) {
                  return Container(
                    height: (_mediaQuery.size.height - _appBarHieght),
                    width: _mediaQuery.size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height:
                              (_mediaQuery.size.height - _appBarHieght) * 0.05,
                        ),
                        Container(
                          height:
                              (_mediaQuery.size.height - _appBarHieght) * 0.05,
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
                } else {
                  return WorkoutTile(
                    workoutprovider.findByName(searchTerm!)[index],
                    false,
                  );
                }
              },
              itemCount: searchTerm != null
                  ? workoutprovider.findByName(searchTerm!).toList().isEmpty
                      ? 1
                      : workoutprovider.findByName(searchTerm!).length
                  : workoutprovider.workouts.length,
            ),
          ),
        ),
      ),
    );
  }
}
