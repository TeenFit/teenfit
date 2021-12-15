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

  Workout({
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
}
