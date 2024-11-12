import 'package:estates_house/domain/services/i_user_session_service.dart';

class UserSessionService implements IUserSessionService {
  String? _token;
  String? _email;

  @override
  String? get token => _token;

  @override
  String? get email => _email;

  @override
  void setUserData(String? token, String? email) {
    _token = token;
    _email = email;
  }

  @override
  void clearUserData() {
    _token = null;
    _email = null;
  }
}
