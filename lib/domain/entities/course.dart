import 'lesson.dart';

class Course {
  final int id;
  final String title;
  final String instructor;
  final List<Lesson> lessons;
  final int initialProgress;
  final bool progressFromLessons;

  const Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.lessons,
    this.initialProgress = 0,
    this.progressFromLessons = false,
  });

  int get totalLessons => lessons.length;

  int get completedLessons =>
      lessons.where((lesson) => lesson.isCompleted).length;

  int get progress {
    if (!progressFromLessons) return initialProgress;
    if (totalLessons == 0) return 0;
    return (completedLessons * 100 / totalLessons).round();
  }

  Course copyWith({
    List<Lesson>? lessons,
    int? initialProgress,
    bool? progressFromLessons,
  }) {
    return Course(
      id: id,
      title: title,
      instructor: instructor,
      lessons: lessons ?? this.lessons,
      initialProgress: initialProgress ?? this.initialProgress,
      progressFromLessons: progressFromLessons ?? this.progressFromLessons,
    );
  }
}