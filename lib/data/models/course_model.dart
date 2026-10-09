import '../../domain/entities/course.dart';
import '../../domain/entities/lesson.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.instructor,
    required super.lessons,
    required super.initialProgress,
    super.progressFromLessons = false,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int,
      title: json['title'] as String,
      instructor: json['instructor'] as String,
      initialProgress: json['progress'] as int? ?? 0,
      lessons: (json['lessons'] as List<dynamic>)
          .map(
            (item) => Lesson(
          id: item['id'] as int,
          title: item['title'] as String,
          isCompleted: item['isCompleted'] as bool? ?? false,
        ),
      )
          .toList(),
    );
  }

  factory CourseModel.fromEntity(Course course) {
    return CourseModel(
      id: course.id,
      title: course.title,
      instructor: course.instructor,
      lessons: course.lessons,
      initialProgress: course.initialProgress,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'instructor': instructor,
    'progress': initialProgress,
    'lessons': lessons
        .map(
          (lesson) => {
        'id': lesson.id,
        'title': lesson.title,
        'isCompleted': lesson.isCompleted,
      },
    )
        .toList(),
  };
}