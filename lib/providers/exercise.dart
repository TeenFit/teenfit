import 'dart:io';

class Exercise {
  final String name;
  final int? timeSeconds;
  final int? restTime;
  final int? reps;
  final int? sets;
  final File? exerciseImage;
  final String? exerciseImageLink;
  final String exerciseId;
  final File? exerciseVideo;

  Exercise({
    this.exerciseVideo,
    required this.exerciseId,
    required this.name,
    this.reps,
    this.sets,
    this.timeSeconds,
    this.restTime,
    this.exerciseImage,
    this.exerciseImageLink,
  });
}
