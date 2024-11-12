import 'package:estates_house/data/services/property_service.dart';
import 'package:estates_house/data/services/user_session_service.dart';
import 'package:estates_house/domain/services/i_property_service.dart';
import 'package:estates_house/domain/services/i_user_session_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<IPropertyService>(() => PropertyService());
  getIt.registerLazySingleton<IUserSessionService>(() => UserSessionService());
}
