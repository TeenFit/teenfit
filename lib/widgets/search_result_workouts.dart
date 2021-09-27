import 'package:flutter/material.dart';
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

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: _appBarHieght,
            width: _mediaQuery.size.width,
          ),
          Container(
            height: _mediaQuery.size.height - _appBarHieght,
            width: _mediaQuery.size.width,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  if (searchTerm == null) {
                    return WorkoutTile(workoutprovider.workouts[index], false);
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
                  } else {
                    return WorkoutTile(
                      Provider.of<Workouts>(context, listen: false)
                          .findByName(searchTerm!)[index],
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
        ],
      ),
    );
  }
}
