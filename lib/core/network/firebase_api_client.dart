import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// A client for making HTTP requests to the Firebase backend.
///
/// This class implements the Singleton design pattern to ensure that
/// only one instance of the `FirebaseApiClient` exists throughout the
/// application. It initializes the Dio instance and sets up interceptors
/// for handling authentication tokens.
class FirebaseApiClient {
  static final FirebaseApiClient _instance =
      FirebaseApiClient._privateConstructor();

  /// Factory constructor that returns the singleton instance.
  factory FirebaseApiClient() => _instance;

  final Dio _dio = Dio();
  Dio get dio => _dio;

  // Initialize the Dio instance and interceptors
  FirebaseApiClient._privateConstructor() {
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
}
