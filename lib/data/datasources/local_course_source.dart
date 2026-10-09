import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/course_model.dart';

class LocalCourseSource {
  static const _cacheKey = 'cached_courses';

  Future<void> saveCourses(List<CourseModel> courses) async {
    final preferences = await SharedPreferences.getInstance();

    final jsonString = jsonEncode(
      courses.map((course) => course.toJson()).toList(),
    );

    final saved = await preferences.setString(_cacheKey, jsonString);

    if (!saved) {
      throw Exception('Unable to save course cache');
    }
  }

  Future<List<CourseModel>> getCachedCourses() async {
    final preferences = await SharedPreferences.getInstance();
    final jsonString = preferences.getString(_cacheKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

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