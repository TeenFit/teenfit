import 'package:flutter/material.dart';
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

    return SingleChildScrollView(
      child: Container(
        height: _mediaQuery.size.height,
        width: _mediaQuery.size.width,
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
    );
  }
}
