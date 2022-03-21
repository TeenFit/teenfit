import 'dart:io';

class Exercise {
  final String name;
  final int? timeSeconds;
  final int? restTime;
  final int? reps;
  final int? sets;
  final int? reps2;
  final File? exerciseImage;
  final File? exerciseImage2;
  final String? exerciseImageLink;
  final String? exerciseImageLink2;
  final String exerciseId;
  final String? name2;

  Exercise({
    required this.exerciseId,
    required this.name,
    this.name2,
    this.reps2,
    this.reps,
    this.sets,
    this.timeSeconds,
    this.restTime,
    this.exerciseImage,
    this.exerciseImage2,
    this.exerciseImageLink,
    this.exerciseImageLink2,
  });
}
