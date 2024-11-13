import 'package:dio/dio.dart';
import 'package:estates_house/core/network/firebase_api_client.dart';
import 'package:estates_house/domain/entities/property.dart';
import 'package:estates_house/domain/services/i_property_service.dart';
import 'package:get_it/get_it.dart';
import 'package:estates_house/domain/services/i_user_session_service.dart';
import 'package:estates_house/domain/factory/property_factory.dart';

class PropertyService implements IPropertyService {
  final Dio dio;
  final IUserSessionService _userSessionService =
      GetIt.instance<IUserSessionService>();
  final IPropertyFactory _propertyFactory = GetIt.instance<IPropertyFactory>();

  PropertyService() : dio = FirebaseApiClient().dio;

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
