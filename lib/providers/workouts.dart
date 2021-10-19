import 'package:flutter/cupertino.dart';

import './exercise.dart';
import './workout.dart';

class Workouts with ChangeNotifier {
  List<Workout> get workouts {
    return [..._workouts];
  }

  List<Workout> _workouts = [
    Workout(
      creatorName: 'Muqeeth Khan',
      workoutId: 'w1',
      creatorId: 'uid',
      workoutName: 'Body Weight Workout',
      instagram: 'https://www.instagram.com/teenfittest/',
      facebook: '',
      tumblrPageLink: '',
      bannerImage: 'assets/images/BannerImageUnavailable.png',
      exercises: [
        Exercise(
          exerciseId: 'e1',
          name: 'Wide Pushups',
          reps: 10,
          sets: 3,
          restTime: 15,
          exerciseImageLink:
              'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
        ),
        Exercise(
          exerciseId: 'e2',
          name: 'Wide Pushups',
          reps: 10,
          sets: 3,
          restTime: 15,
          exerciseImageLink:
              'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
        ),
        Exercise(
          exerciseId: 'e3',
          name: 'Wide Pushups',
          reps: 10,
          sets: 3,
          restTime: 15,
          exerciseImageLink:
              'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
        ),
        Exercise(
          exerciseId: 'e4',
          name: 'Wide Pushups',
          reps: 10,
          sets: 3,
          restTime: 15,
          exerciseImageLink:
              'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
        ),
        Exercise(
          exerciseId: 'e5',
          name: 'Wide Pushups',
          reps: 10,
          sets: 3,
          restTime: 15,
          exerciseImageLink:
              'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
        ),
      ],
    ),
    Workout(
      creatorName: 'Muqeeth Khan',
      workoutId: 'w2',
      creatorId: 'UID',
      workoutName: 'Dumbell Workout',
      instagram: '',
      facebook: '',
      tumblrPageLink: '',
      bannerImage: '',
      exercises: [
        Exercise(
          exerciseId: 'e1',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseImageLink:
              'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
        ),
        Exercise(
          exerciseId: 'e2',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseImageLink:
              'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
        ),
        Exercise(
          exerciseId: 'e3',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseImageLink:
              'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
        ),
        Exercise(
          exerciseId: 'e4',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseImageLink:
              'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
        ),
        Exercise(
          exerciseId: 'e5',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseImageLink:
              'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
        ),
      ],
    ),
  ];

  List<Workout> findByName(String name) {
    return workouts
        .where(
          (workout) =>
              workout.workoutName.contains(name) ||
              workout.workoutName.toLowerCase().contains(name) ||
              workout.workoutName.toUpperCase().contains(name) ||
              workout.workoutName.characters.contains(name),
        )
        .toList();
  }

  List<Workout> findByCreatorId(String creatorId) {
    return workouts.where((workout) => workout.creatorId == creatorId).toList();
  }

  Future<void> addWorkout(Workout workout) async {
    _workouts.insert(0, workout);
    notifyListeners();
  }

  Future<void> deleteWorkout(String workoutId) async {
    _workouts.removeWhere((workout) => workout.workoutId == workoutId);
    notifyListeners();
  }
}
