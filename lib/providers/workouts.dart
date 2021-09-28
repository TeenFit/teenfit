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
      bannerImage: '',
      exercises: [
        Exercise(
          exerciseId: 'e1',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseImageLink:
              'https://drive.google.com/uc?export=view&id=1aoR5jEnERbFzY7zPIQ6XUNirjoRX8Rbg',
        ),
        Exercise(
          exerciseId: 'e2',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseImageLink:
              'https://drive.google.com/uc?export=view&id=1aoR5jEnERbFzY7zPIQ6XUNirjoRX8Rbg',
        ),
        Exercise(
          exerciseId: 'e3',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseImageLink:
              'https://drive.google.com/uc?export=view&id=1aoR5jEnERbFzY7zPIQ6XUNirjoRX8Rbg',
        ),
        Exercise(
          exerciseId: 'e4',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseImageLink:
              'https://drive.google.com/uc?export=view&id=1aoR5jEnERbFzY7zPIQ6XUNirjoRX8Rbg',
        ),
        Exercise(
          exerciseId: 'e5',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseImageLink:
              'https://drive.google.com/uc?export=view&id=1aoR5jEnERbFzY7zPIQ6XUNirjoRX8Rbg',
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
              'https://drive.google.com/uc?export=view&id=1aoR5jEnERbFzY7zPIQ6XUNirjoRX8Rbg',
        ),
        Exercise(
          exerciseId: 'e2',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseImageLink:
              'https://drive.google.com/uc?export=view&id=1aoR5jEnERbFzY7zPIQ6XUNirjoRX8Rbg',
        ),
        Exercise(
          exerciseId: 'e3',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseImageLink:
              'https://drive.google.com/uc?export=view&id=1aoR5jEnERbFzY7zPIQ6XUNirjoRX8Rbg',
        ),
        Exercise(
          exerciseId: 'e4',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseImageLink:
              'https://drive.google.com/uc?export=view&id=1aoR5jEnERbFzY7zPIQ6XUNirjoRX8Rbg',
        ),
        Exercise(
          exerciseId: 'e5',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseImageLink:
              'https://drive.google.com/uc?export=view&id=1aoR5jEnERbFzY7zPIQ6XUNirjoRX8Rbg',
        ),
      ],
    ),
  ];

  List<Workout> findByName(String name) {
    return workouts
        .where((workout) => workout.workoutName.contains(name))
        .toList();
  }

  List<Workout> findByCreatorId(String creatorId) {
    return workouts.where((workout) => workout.creatorId == creatorId).toList();
  }

  Future<void> deleteWorkout(String workoutId) async {
    _workouts.removeWhere((workout) => workout.workoutId == workoutId);
    notifyListeners();
  }
}
