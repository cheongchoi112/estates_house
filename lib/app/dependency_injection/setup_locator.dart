import 'package:dio/dio.dart';
import 'package:estates_house/core/network/firebase_api_client.dart';
import 'package:estates_house/features/property_listing/data/services/property_service.dart';
import 'package:estates_house/data/services/user_session_service.dart';

import 'package:estates_house/features/property_listing/domain/factory/property_factory.dart';
import 'package:estates_house/features/property_listing/domain/interfaces/i_property_service.dart';
import 'package:estates_house/features/user_management/domain/services/i_user_session_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

/// Configures the service locator and registers services.
///
/// This file uses the Dependency Injection (DI) pattern to register
/// the implementations of the service interfaces for dependency injection
/// throughout the application. It ensures that the application components
/// can access the required services without tightly coupling to their
/// concrete implementations.
void setupLocator() {
  // Register FirebaseApiClient and Dio first
  final firebaseApiClient = FirebaseApiClient();
  getIt.registerLazySingleton<Dio>(() => firebaseApiClient.dio);

  // Register factories and services
  getIt.registerLazySingleton<IPropertyFactory>(() => PropertyFactory());
  getIt.registerLazySingleton<IUserSessionService>(() => UserSessionService());

  // Register PropertyService after its dependencies
  getIt.registerLazySingleton<IPropertyService>(() => PropertyService(
        getIt<IUserSessionService>(),
        getIt<IPropertyFactory>(),
        getIt<Dio>(),
      ));

  // Register other services
}
