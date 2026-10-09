
import '../../domain/entities/course.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/local_course_source.dart';
import '../datasources/remote_course_source.dart';
import '../models/course_model.dart';

class CourseRepositoryImpl implements CourseRepository {
  final RemoteCourseSource remote;
  final LocalCourseSource local;

  CourseRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<List<Course>> getCourses() async {
    try {
      final courses = await remote.fetchCourses();

      // Cache the latest successful response.
      await local.saveCourses(courses);

      return courses;
    } catch (error) {
      // Remote loading failed: attempt offline fallback.
      final cachedCourses = await local.getCachedCourses();

      if (cachedCourses.isNotEmpty) {
        return cachedCourses;
      }

      // No usable cache exists, so the caller can show an error.
      rethrow;
    }
  }

  @override
  Future<void> updateLesson({
    required int courseId,
    required int lessonId,
    required bool isCompleted,
  }) async {
    final courses = await local.getCachedCourses();

    if (courses.isEmpty) {
      throw StateError(
        'No cached courses. Load courses before updating lessons.',
      );
    }

    final courseIndex =
    courses.indexWhere((course) => course.id == courseId);

    if (courseIndex == -1) {
      throw StateError('Course not found');
    }

    final course = courses[courseIndex];

    final lessonIndex =
    course.lessons.indexWhere((lesson) => lesson.id == lessonId);

    if (lessonIndex == -1) {
      throw StateError('Lesson not found');
    }

    final updatedLessons = List<Lesson>.from(course.lessons);

    updatedLessons[lessonIndex] = updatedLessons[lessonIndex].copyWith(
      isCompleted: isCompleted,
    );

    final updatedCourse = course.copyWith(
      lessons: updatedLessons,
      progressFromLessons: true,
    );
    courses[courseIndex] = CourseModel.fromEntity(updatedCourse);

    await local.saveCourses(courses);
  }
}