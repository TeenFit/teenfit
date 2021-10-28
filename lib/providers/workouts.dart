import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '/Custom/http_execption.dart';
import './exercise.dart';
import './workout.dart';

class Workouts with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Workout> get workouts {
    return [..._workouts];
  }

  List<Workout> _workouts = [
    Workout(
      creatorName: 'Muqeeth Khan',
      workoutId: 'w1',
      creatorId: 'FiGK0HauiQd1xv3FV3FXMF1uAw83',
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
    CollectionReference workouts =
        FirebaseFirestore.instance.collection('workouts');

    try {
      await workouts.doc('${workout.workoutId}').collection('workouts').add(workout as Map<String, dynamic>);
      _workouts.insert(0, workout);
    } catch (e) {
      throw HttpException('');
    }
    notifyListeners();
  }

  Future<void> updateWorkout(Workout workout) async {
    

    try {
      int index = _workouts
          .indexWhere((workouT) => workouT.workoutId == workout.workoutId);
      _workouts
          .removeWhere((workouT) => workouT.workoutId == workout.workoutId);
      _workouts.insert(index, workout);
    } catch (_) {
      throw HttpException('');
    }

    notifyListeners();
  }

  Future<void> deleteWorkout(String workoutId) async {
    _workouts.removeWhere((workout) => workout.workoutId == workoutId);
    notifyListeners();
  }
}
