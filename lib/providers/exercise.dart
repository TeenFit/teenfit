import 'dart:io';

class Exercise {
  final String name;
  final int? timeSeconds;
  final int? restTime;
  final int? reps;
  final int? sets;
  final File? exerciseImage;
  final String exerciseId;

  Exercise({
    required this.exerciseId,
    required this.name,
    this.reps,
    this.sets,
    this.timeSeconds,
    this.restTime,
    required this.exerciseImage,
  });
}
