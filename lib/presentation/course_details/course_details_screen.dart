import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class CourseDetailsScreen extends ConsumerWidget {
  final int courseId;

  const CourseDetailsScreen({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Course Details')),
      body: coursesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Unable to load course: $error'),
        ),
        data: (courses) {
          final matches =
          courses.where((course) => course.id == courseId);

          if (matches.isEmpty) {
            return const Center(child: Text('Course not found.'));
          }

          final course = matches.first;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                course.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text('Instructor: ${course.instructor}'),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: course.progress / 100,
              ),
              const SizedBox(height: 8),
              Text(
                '${course.progress}% complete'
                    ' (${course.completedLessons}/${course.totalLessons} lessons)',
              ),
              const SizedBox(height: 20),
              Text(
                'Lessons',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              ...course.lessons.map(
                    (lesson) => Card(
                  child: CheckboxListTile(
                    value: lesson.isCompleted,
                    title: Text(lesson.title),
                    subtitle: Text(
                      lesson.isCompleted ? 'Completed' : 'Pending',
                    ),
                    onChanged: (completed) async {
                      if (completed == null) return;

                      try {
                        await ref
                            .read(coursesProvider.notifier)
                            .completeLesson(
                          courseId: course.id,
                          lessonId: lesson.id,
                          completed: completed,
                        );
                      } catch (_) {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Could not save lesson progress.',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}