import 'package:dio/dio.dart';

import '../../../user_management/domain/services/i_user_session_service.dart';
import '../../domain/entities/property.dart';
import '../../domain/factory/property_factory.dart';
import '../../domain/interfaces/i_property_service.dart';

/// Implementation of `IPropertyService` for managing property data.
///
/// This class uses the Repository pattern to abstract the data access layer
/// from the domain logic. It depends on `FirebaseApiClient` for making HTTP
/// requests and `IUserSessionService` for including the user's authentication
/// token in requests.
class PropertyService implements IPropertyService {
  final IUserSessionService _userSessionService;
  final IPropertyFactory _propertyFactory;
  final Dio dio;

  PropertyService(this._userSessionService, this._propertyFactory, this.dio);

  @override
  Future<List<Property>> getUserProperties() async {
    final token = _userSessionService.token;
    final response = await dio.get(
      '/handle_property_crud/user/properties',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.data is! Map<String, dynamic>) {
      return [];
    }

    final responseData = response.data as Map<String, dynamic>;
    final propertiesList =
        List<Map<String, dynamic>>.from(responseData['data']);

    return propertiesList
        .map((propertyJson) => _propertyFactory.createFromJson(propertyJson))
        .toList();
  }

  @override
  Future<void> deleteProperty(String id) async {
    await dio.delete(
      '/handle_property_crud/properties/$id',
    );
  }

  @override
  Future<void> addProperty(Map<String, dynamic> newProperty) async {
    await dio.post(
      '/handle_property_crud/properties',
      data: newProperty,
    );
  }

  @override
  Future<List<Property>> searchProperties(SearchCriteria criteria) async {
    final response = await dio.post(
      '/handle_property_search',
      data: criteria.toJson(),
    );

    if (response.data is! Map<String, dynamic>) {
      return [];
    }

    final responseData = response.data as Map<String, dynamic>;
    final propertiesList =
        List<Map<String, dynamic>>.from(responseData['data']);

    return propertiesList
        .map((propertyJson) => _propertyFactory.createFromJson(propertyJson))
        .toList();
  }
}
