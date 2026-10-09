import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/local_course_source.dart';
import '../data/datasources/remote_course_source.dart';
import '../data/repositories/course_repository_impl.dart';
import '../domain/entities/course.dart';
import '../domain/repositories/course_repository.dart';
import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';


final dioClientProvider = Provider<Dio>((ref) {
  return DioClient().dio;
});

final remoteCourseSourceProvider = Provider<RemoteCourseSource>(
      (ref) => RemoteCourseSource(),
);

final localCourseSourceProvider = Provider<LocalCourseSource>(
      (ref) => LocalCourseSource(),
);

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepositoryImpl(
    remote: ref.watch(remoteCourseSourceProvider),
    local: ref.watch(localCourseSourceProvider),
  );
});

final coursesProvider =
AsyncNotifierProvider<CoursesController, List<Course>>(
  CoursesController.new,
);

class CoursesController extends AsyncNotifier<List<Course>> {
  @override
  Future<List<Course>> build() async {
    return ref.read(courseRepositoryProvider).getCourses();
  }

  Future<void> refreshCourses() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
          () => ref.read(courseRepositoryProvider).getCourses(),
    );
  }

  Future<void> completeLesson({
    required int courseId,
    required int lessonId,
    required bool completed,
  }) async {
    final repository = ref.read(courseRepositoryProvider);

    try {
      await repository.updateLesson(
        courseId: courseId,
        lessonId: lessonId,
        isCompleted: completed,
      );

      // Reload the persisted data so the dashboard and details stay in sync.
      state = AsyncData(await repository.getCourses());
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}