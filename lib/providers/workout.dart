import 'package:teenfit/providers/exercise.dart';

class Workout {
  final String creatorName;
  final String workoutUiD;
  final String workoutName;
  final String instagramLink;
  final String facebookLink;
  final String tumblrLink;
  final String bannerImage;
  final List<Exercise> exercises;

  Workout({
    required this.creatorName,
    required this.workoutUiD,
    required this.workoutName,
    required this.instagramLink,
    required this.facebookLink,
    required this.tumblrLink,
    required this.bannerImage,
    required this.exercises
  });
}
