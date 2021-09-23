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
      workoutUiD: 'w1:uid',
      workoutName: 'Body Weight Workout',
      instagram: 'teenfittest',
      facebook: '',
      tumblrPageLink: '',
      bannerImage: '',
      exercises: [
        Exercise(
          exerciseId: 'w1:uid:e1',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseLink:
              'https://drive.google.com/uc?export=view&id=1aoR5jEnERbFzY7zPIQ6XUNirjoRX8Rbg',
        ),
        Exercise(
          exerciseId: 'w1:uid:e1',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseLink:
              'https://drive.google.com/uc?export=view&id=1aoR5jEnERbFzY7zPIQ6XUNirjoRX8Rbg',
        ),
        Exercise(
          exerciseId: 'w1:uid:e1',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseLink:
              'https://drive.google.com/uc?export=view&id=1aoR5jEnERbFzY7zPIQ6XUNirjoRX8Rbg',
        ),
        Exercise(
          exerciseId: 'w1:uid:e1',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseLink:
              'https://drive.google.com/uc?export=view&id=1aoR5jEnERbFzY7zPIQ6XUNirjoRX8Rbg',
        ),
        Exercise(
          exerciseId: 'w1:uid:e1',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseLink:
              'https://drive.google.com/uc?export=view&id=1aoR5jEnERbFzY7zPIQ6XUNirjoRX8Rbg',
        ),
      ],
    ),
    Workout(
      creatorName: 'Muqeeth Khan',
      workoutUiD: 'w1:uid',
      workoutName: 'Dumbell Workout',
      instagram: '',
      facebook: '',
      tumblrPageLink: '',
      bannerImage: '',
      exercises: [
        Exercise(
          exerciseId: 'w1:uid:e1',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseLink:
              'https://drive.google.com/uc?export=view&id=1aoR5jEnERbFzY7zPIQ6XUNirjoRX8Rbg',
        ),
        Exercise(
          exerciseId: 'w1:uid:e1',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseLink:
              'https://drive.google.com/uc?export=view&id=1aoR5jEnERbFzY7zPIQ6XUNirjoRX8Rbg',
        ),
        Exercise(
          exerciseId: 'w1:uid:e1',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseLink:
              'https://drive.google.com/uc?export=view&id=1aoR5jEnERbFzY7zPIQ6XUNirjoRX8Rbg',
        ),
        Exercise(
          exerciseId: 'w1:uid:e1',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseLink:
              'https://drive.google.com/uc?export=view&id=1aoR5jEnERbFzY7zPIQ6XUNirjoRX8Rbg',
        ),
        Exercise(
          exerciseId: 'w1:uid:e1',
          name: 'Wide Pushups',
          timeSeconds: 30,
          restTime: 15,
          exerciseLink:
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
}
