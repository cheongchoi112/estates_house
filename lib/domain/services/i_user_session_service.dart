abstract interface class IUserSessionService {
  void setUserData(String? token, String? email);
  void clearUserData();
  String? get token;
  String? get email;
}
