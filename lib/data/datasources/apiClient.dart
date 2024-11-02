import 'package:dio/dio.dart';
import '../../../domain/user_singleton.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    _dio.options.baseUrl =
        'http://127.0.0.1:5001/house-platform-78131/us-central1';
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Authorization'] = 'Bearer ${UserSingleton().token}';

    // Enable CORS and add Bearer token using an interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = UserSingleton().token;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        } else {
          print('Error: Bearer token is null');
        }
        options.headers['Access-Control-Allow-Origin'] =
            '*'; // Or your specific domain
        options.headers['Access-Control-Allow-Methods'] =
            'GET, POST, PUT, DELETE, OPTIONS';
        options.headers['Access-Control-Allow-Headers'] =
            'Origin, Content-Type, Authorization';
        return handler.next(options);
      },
    ));
  }

  final Dio _dio = Dio();

  Dio get dio => _dio;

  Future<Response> post(String path, {dynamic data}) async {
    final response = await _dio.post(path,
        data: data,
        options: Options(headers: {
          'Authorization': 'Bearer ${UserSingleton().token}',
        }));
    return response;
  }
}
