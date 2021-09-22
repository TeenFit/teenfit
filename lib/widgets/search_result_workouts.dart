import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/providers/workouts.dart';
import 'package:teenfit/widgets/workout_tile.dart';

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
                    return WorkoutTile(workoutprovider.workouts[index]);
                  } else if (workoutprovider
                      .findByName(searchTerm!)
                      .toList()
                      .isEmpty) {
                    return Container(
                      height: _mediaQuery.size.height * 0.03,
                      width: _mediaQuery.size.width,
                      child: Center(
                        child: Container(
                          height:
                              (_mediaQuery.size.height - _appBarHieght) * 0.5,
                          width: double.infinity,
                          child: Text(
                            'No Search Results Available',
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
                    );
                  } else {
                    return WorkoutTile(
                        Provider.of<Workouts>(context, listen: false)
                            .findByName(searchTerm!)[index]);
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
