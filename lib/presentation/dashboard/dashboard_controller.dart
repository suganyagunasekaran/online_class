
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/course.dart';
import '../providers.dart';

final dashboardControllerProvider =
AsyncNotifierProvider<DashboardController, List<Course>>(
  DashboardController.new,
);

class DashboardController extends AsyncNotifier<List<Course>> {
  @override
  Future<List<Course>> build() async {
    return ref.read(courseRepositoryProvider).getCourses();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
          () => ref.read(courseRepositoryProvider).getCourses(),
    );
  }
}