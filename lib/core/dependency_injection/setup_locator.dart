import 'package:estates_house/data/services/property_service.dart';
import 'package:estates_house/data/services/user_session_service.dart';
import 'package:estates_house/domain/services/i_property_service.dart';
import 'package:estates_house/domain/services/i_user_session_service.dart';
import 'package:get_it/get_it.dart';
import 'package:estates_house/domain/factory/property_factory.dart';

final getIt = GetIt.instance;

/// Configures the service locator and registers services.
///
/// This file uses the Dependency Injection (DI) pattern to register
/// the implementations of the service interfaces for dependency injection
/// throughout the application. It ensures that the application components
/// can access the required services without tightly coupling to their
/// concrete implementations.
void setupLocator() {
  getIt.registerLazySingleton<IPropertyService>(() => PropertyService());
  getIt.registerLazySingleton<IUserSessionService>(() => UserSessionService());
  getIt.registerLazySingleton<IPropertyFactory>(() => PropertyFactory());
}
