import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/dashboard/dashboard_screen.dart';
import '../../presentation/course_details/course_details_screen.dart';
import '../../presentation/login/login_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/course/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);

          return CourseDetailsScreen(courseId: id);
        },
      ),
    ],
  );
});