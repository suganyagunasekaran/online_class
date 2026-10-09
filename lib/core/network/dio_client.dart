import 'package:dio/dio.dart';

class DioClient {
  late final Dio dio;

  DioClient({String? baseUrl})
      : dio = Dio(
    BaseOptions(
      baseUrl: baseUrl ?? 'https://api.example.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  ) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: false,
      ),
    );
  }
}