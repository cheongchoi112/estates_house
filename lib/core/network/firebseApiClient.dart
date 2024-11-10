import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseApiClient {
  FirebaseApiClient._privateConstructor();

  static final FirebaseApiClient _instance =
      FirebaseApiClient._privateConstructor1();

  factory FirebaseApiClient() => _instance;

  final Dio _dio = Dio();
  Dio get dio => _dio;

  // Initialize the Dio instance and interceptors
  FirebaseApiClient._privateConstructor1() {
    if (kDebugMode) {
      _dio.options.baseUrl =
          'http://127.0.0.1:5001/house-platform-78131/us-central1';
    } else {
      _dio.options.baseUrl =
          'https://us-central1-house-platform-78131.cloudfunctions.net';
    }
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await _getBearerToken();
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // Unauthorized
          try {
            // Refresh the token
            await FirebaseAuth.instance.currentUser?.getIdToken(true);
            // Retry the request
            return handler.resolve(await _dio.fetch(e.requestOptions));
          } catch (e) {
            debugPrint('Error refreshing token: $e');
            return handler.next(e as DioException);
          }
        }
        return handler.next(e);
      },
    ));
  }

  Future<String?> _getBearerToken() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? token = await user.getIdToken();
        return token;
      }
    } catch (e) {
      debugPrint('Error getting token: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchData() async {
    try {
      Response response = await _dio.get('YOUR_FIREBASE_FUNCTION_URL');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        debugPrint('Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  // Add more methods for other API endpoints (e.g., POST, PUT, DELETE)
}
