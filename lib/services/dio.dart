import 'package:dio/dio.dart';

class ApiClient {
  static Dio? dio;

  ApiClient._(); // Private constructor to prevent multiple instances

  static Dio getInstance() {
    if (dio == null) {
      dio = Dio();
      dio!.options.baseUrl = 'http://192.168.100.235:8000/api';
      dio!.options.connectTimeout = const Duration(seconds: 5); // 5 seconds
      dio!.options.receiveTimeout = const Duration(seconds: 3); // 3 seconds
      dio!.options.headers['Content-Type'] = 'application/json';
    } else {
      return dio!;
    }
    return dio!;
  }
}
