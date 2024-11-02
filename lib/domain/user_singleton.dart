class UserSingleton {
  static final UserSingleton _instance = UserSingleton._internal();
  factory UserSingleton() => _instance;
  UserSingleton._internal();

  String? _token;
  String? _email;
  static const String baseUrl =
      'http://127.0.0.1:5001/house-platform-78131/us-central1';

  String? get token =>
      'eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.eyJuYW1lIjoiSm9lIiwicGljdHVyZSI6IiIsImVtYWlsIjoiam9lQGpvZS5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImF1dGhfdGltZSI6MTczMDQ0NTQwNiwidXNlcl9pZCI6IjlTNEpYQkNqZW1FM3BhTWM3RkVYSDd1NFhKd1kiLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbImpvZUBqb2UuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifSwiaWF0IjoxNzMwNDQ1NDA2LCJleHAiOjE3MzA0NDkwMDYsImF1ZCI6ImhvdXNlLXBsYXRmb3JtLTc4MTMxIiwiaXNzIjoiaHR0cHM6Ly9zZWN1cmV0b2tlbi5nb29nbGUuY29tL2hvdXNlLXBsYXRmb3JtLTc4MTMxIiwic3ViIjoiOVM0SlhCQ2plbUUzcGFNYzdGRVhIN3U0WEp3WSJ9.';
  String? get email => _email;

  void setUserData(String token, String email) {
    _token = 'token';
    _email = email;
  }

  void clearUserData() {
    _token = null;
    _email = null;
  }
}
