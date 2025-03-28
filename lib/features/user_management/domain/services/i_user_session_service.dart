/// Interface for managing user sessions.
///
/// This interface is part of the domain layer and defines the contract for
/// managing user authentication state. It is implemented by the
/// `UserSessionService` class in the data layer.
abstract interface class IUserSessionService {
  void setUserData(String? token, String? email);
  void clearUserData();
  String? get token;
  String? get email;
}
