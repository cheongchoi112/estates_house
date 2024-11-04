class UserSingleton {
  static final UserSingleton _instance = UserSingleton._internal();
  factory UserSingleton() => _instance;
  UserSingleton._internal();

  String? _token;
  String? _email;
  static const String baseUrl =
      'http://127.0.0.1:5001/house-platform-78131/us-central1';

  String? get token => _token;
  String? get email => _email;

  void setUserData(String? token, String? email) {
    _token = token;
    _email = email;
  }

  void clearUserData() {
    _token = null;
    _email = null;
  }
}
