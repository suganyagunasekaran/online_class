

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/course.dart';
import '../providers.dart';

final courseDetailsControllerProvider =
AsyncNotifierProvider<CourseDetailsController, List<Course>>(
  CourseDetailsController.new,
);

class CourseDetailsController extends AsyncNotifier<List<Course>> {
  @override
  Future<List<Course>> build() async {
    return ref.read(courseRepositoryProvider).getCourses();
  }

  Future<void> toggleLesson({
    required int courseId,
    required int lessonId,
    required bool isCompleted,
  }) async {
    final currentCourses = state.asData?.value;
    if (currentCourses == null) {
      throw StateError('Courses have not loaded yet.');
    }

    final repository = ref.read(courseRepositoryProvider);

    try {
      await repository.updateLesson(
        courseId: courseId,
        lessonId: lessonId,
        isCompleted: isCompleted,
      );

      final updatedCourses = currentCourses.map((course) {
        if (course.id != courseId) return course;

        final updatedLessons = course.lessons.map((lesson) {
          if (lesson.id != lessonId) return lesson;

          return lesson.copyWith(isCompleted: isCompleted);
        }).toList();

        return course.copyWith(
          lessons: updatedLessons,
          progressFromLessons: true,
        );
      }).toList();

      state = AsyncData(updatedCourses);
    } catch (error, stackTrace) {
      // Preserve a visible error state and let the UI show feedback.
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}