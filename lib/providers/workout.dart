import './exercise.dart';

class Workout {
  final String creatorName;
  final String creatorId;
  final String workoutId;
  final String workoutName;
  final String instagram;
  final String facebook;
  final String tumblrPageLink;
  final String bannerImage;
  final List<Exercise> exercises;

  Workout(
      {required this.creatorName,
      required this.creatorId,
      required this.workoutId,
      required this.workoutName,
      required this.instagram,
      required this.facebook,
      required this.tumblrPageLink,
      required this.bannerImage,
      required this.exercises});
}
