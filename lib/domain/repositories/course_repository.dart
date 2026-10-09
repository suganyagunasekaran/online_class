import '../entities/course.dart';

abstract class CourseRepository {
  Future<List<Course>> getCourses();

  Future<void> updateLesson({
    required int courseId,
    required int lessonId,
    required bool isCompleted,
  });
}