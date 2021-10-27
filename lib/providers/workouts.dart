import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teenfit/Custom/http_execption.dart';

import './exercise.dart';
import './workout.dart';

class Workouts with ChangeNotifier {
  List<Workout> get workouts {
    return [..._workouts];
  }

  List<Workout> _workouts = [
    Workout(
      isPending: false,
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
          name: 'Pushups',
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
          name: 'Diamond Pushups',
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
      isPending: false,
      creatorName: 'Muqeeth Khan',
      workoutId: 'w2',
      creatorId: 'uid',
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
    CollectionReference workoutsCollection =
        FirebaseFirestore.instance.collection('workouts/${workout.workoutId}');
    try {
      await workoutsCollection
          .add(workout)
          .then((value) => _workouts.insert(0, workout));
    } catch (_) {
      throw HttpException('Unable To Create Workout, Try Again Later');
    }
    notifyListeners();
  }

  Future<void> updateWorkout(Workout workout) async {
    int index = _workouts
        .indexWhere((workouT) => workouT.workoutId == workout.workoutId);
    _workouts.removeWhere((workouT) => workouT.workoutId == workout.workoutId);
    _workouts.insert(index, workout);
    notifyListeners();
  }

  Future<void> deleteWorkout(String workoutId) async {
    CollectionReference workoutsCollection =
        FirebaseFirestore.instance.collection('workouts/$workoutId');

    try {
      await workoutsCollection.doc().delete();
      _workouts.removeWhere((workout) => workout.workoutId == workoutId);
    } catch (_) {
      throw HttpException('Unable To Delete Workout, Try Again Later');
    }
    notifyListeners();
  }
}
