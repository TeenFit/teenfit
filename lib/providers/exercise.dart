class Exercise {
  final String name;
  final int timeSeconds;
  final int restTime;
  final String? reps;
  final String? sets;
  final String exerciseImageLink;
  final String exerciseId;

  Exercise({
    required this.exerciseId,
    required this.name,
    this.reps,
    this.sets,
    required this.timeSeconds,
    required this.restTime,
    required this.exerciseImageLink,
  });
}
