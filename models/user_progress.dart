class UserProgress {
  final String userId;
  final Map<String, LessonProgress> completedLessons;
  final int totalPoints;
  final int currentStreak;
  final DateTime lastActivity;

  UserProgress({
    required this.userId,
    required this.completedLessons,
    required this.totalPoints,
    required this.currentStreak,
    required this.lastActivity,
  });
}

class LessonProgress {
  final String lessonId;
  final DateTime completedDate;
  final int score;
  final double accuracy;

  LessonProgress({
    required this.lessonId,
    required this.completedDate,
    required this.score,
    required this.accuracy,
  });
}
