import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/course_model.dart';

class RemoteCourseSource {
  Future<List<CourseModel>> fetchCourses() async {
    final jsonString =
    await rootBundle.loadString('assets/courses.json');

    final List<dynamic> decoded = jsonDecode(jsonString);

    return decoded
        .map(
          (item) => CourseModel.fromJson(
        item as Map<String, dynamic>,
      ),
    )
        .toList();
  }
}