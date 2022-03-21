import 'dart:io';
import 'package:teenfit/providers/exercise.dart';

class Workout {
  final String creatorName;
  final String creatorId;
  final String workoutId;
  final String workoutName;
  final String instagram;
  final String facebook;
  final String tiktokLink;
  final File? bannerImage;
  final String? bannerImageLink;
  final List<Exercise> exercises;
  final DateTime date;
  final bool pending;
  final bool failed;
  final List? searchTerms;

  const Workout({
    this.searchTerms,
    required this.date,
    required this.creatorName,
    required this.creatorId,
    required this.workoutId,
    required this.workoutName,
    required this.instagram,
    required this.facebook,
    required this.tiktokLink,
    this.bannerImage,
    this.bannerImageLink,
    required this.pending,
    required this.exercises,
    required this.failed,
  });

  Workout.fromJson(Map<String, dynamic> e)
      : this(
          searchTerms: e['searchTerms'],
          failed: e['failed'],
          pending: e['pending'],
          date: DateTime.parse(e['date']),
          creatorName: e['creatorName'],
          creatorId: e['creatorId'],
          workoutId: e['workoutId'],
          workoutName: e['workoutName'],
          instagram: e['instagram'],
          facebook: e['facebook'],
          tiktokLink: e['tiktokLink'],
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
        'searchTerms': searchTerms,
        'failed': failed,
        'pending': pending,
        'date': date.toString(),
        'creatorName': creatorName,
        'creatorId': creatorId,
        'workoutId': workoutId,
        'workoutName': workoutName,
        'instagram': instagram,
        'facebook': facebook,
        'tiktokLink': tiktokLink,
        'bannerImage': bannerImageLink,
        'exercises': (exercises)
            .map(
              (e) => {
                'exerciseId': e.exerciseId,
                'name': e.name,
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
