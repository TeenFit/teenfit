import 'package:flutter/cupertino.dart';
import 'package:teenfit/providers/workout.dart';

class Workouts with ChangeNotifier {
  List get workouts {
    return [..._workouts];
  }

  List<Workout> _workouts = [
    Workout(
      creatorName: 'Muqeeth Khan',
      workoutUiD: 'w1:uid',
      workoutName: 'Body Weight Workout',
      instagramLink: '',
      facebookLink: '',
      tumblrLink: '',
      bannerImage: '',
    ),
  ];
}
