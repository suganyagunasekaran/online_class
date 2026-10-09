import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            tooltip: 'Refresh courses',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(coursesProvider.notifier).refreshCourses();
            },
          ),
        ],
      ),
      body: coursesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off, size: 48),
                const SizedBox(height: 12),
                const Text('Unable to load courses.'),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    ref.read(coursesProvider.notifier).refreshCourses();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (courses) {
          if (courses.isEmpty) {
            return const Center(
              child: Text('No courses available yet.'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref
                .read(coursesProvider.notifier)
                .refreshCourses(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge,
                        ),
                        const SizedBox(height: 6),
                        Text('Instructor: ${course.instructor}'),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: course.progress / 100,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${course.progress}% completed'
                              ' • ${course.totalLessons} lessons',
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.tonal(
                            onPressed: () {
                              context.go('/course/${course.id}');
                            },
                            child: const Text('Continue'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}