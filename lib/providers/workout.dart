import 'dart:io';
import 'package:teenfit/providers/exercise.dart';

class Workout {
  final int views;
  final String creatorId;
  final String workoutId;
  final String workoutName;
  final File? bannerImage;
  final String? bannerImageLink;
  final List<Exercise> exercises;
  final DateTime date;
  final bool pending;
  final bool failed;
  final List? searchTerms;

  const Workout({
    required this.views,
    this.searchTerms,
    required this.date,
    required this.creatorId,
    required this.workoutId,
    required this.workoutName,
    this.bannerImage,
    this.bannerImageLink,
    required this.pending,
    required this.exercises,
    required this.failed,
  });

  Workout.fromJson(Map<String, dynamic> e)
      : this(
          views: e['views'],
          searchTerms: e['searchTerms'],
          failed: e['failed'],
          pending: e['pending'],
          date: DateTime.parse(e['date']),
          creatorId: e['creatorId'],
          workoutId: e['workoutId'],
          workoutName: e['workoutName'],
          bannerImage: null,
          bannerImageLink: e['bannerImage'],
          exercises: (e['exercises'] as List)
              .toList()
              .map(
                (e) => Exercise(
                  name2: e['name2'],
                  exerciseId: e['exerciseId'],
                  name: e['name'],
                  exerciseImageLink: e['exerciseImage'],
                  exerciseImageLink2: e['exerciseImage2'],
                  reps2: e['reps2'],
                  reps: e['reps'],
                  sets: e['sets'],
                  restTime: e['restTime'],
                  timeSeconds: e['timeSeconds'],
                ),
              )
              .toList(),
        );

  Map<String, Object?> toJson() => {
        'views': views,
        'searchTerms': searchTerms,
        'failed': failed,
        'pending': pending,
        'date': date.toString(),
        'creatorId': creatorId,
        'workoutId': workoutId,
        'workoutName': workoutName,
        'bannerImage': bannerImageLink,
        'exercises': (exercises)
            .map(
              (e) => {
                'exerciseId': e.exerciseId,
                'name': e.name,
                'name2': e.name2,
                'exerciseImage': e.exerciseImageLink,
                'exerciseImage2': e.exerciseImageLink2,
                'reps2': e.reps2,
                'reps': e.reps,
                'sets': e.sets,
                'restTime': e.restTime,
                'timeSeconds': e.timeSeconds,
              },
            )
            .toList(),
      };
}
