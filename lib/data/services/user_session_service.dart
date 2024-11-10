class UserSessionService {
  static final UserSessionService _instance = UserSessionService._internal();
  factory UserSessionService() => _instance;
  UserSessionService._internal();

  String? _token;
  String? _email;

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
