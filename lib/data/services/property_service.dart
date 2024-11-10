import 'package:dio/dio.dart';
import 'package:estates_house/core/network/firebseApiClient.dart';
import 'package:estates_house/data/services/user_session_service.dart';
import 'package:estates_house/domain/entities/property.dart';
import 'package:estates_house/domain/services/i_property_service.dart';

class PropertyService implements IPropertyService {
  final Dio dio;

  PropertyService() : dio = FirebaseApiClient().dio;

  @override
  Future<List<Property>> getUserProperties() async {
    final response = await dio.get(
      '/handle_property_crud/user/properties',
      options: Options(
        headers: {'Authorization': 'Bearer ${UserSessionService().token}'},
      ),
    );

    if (response.data is! Map<String, dynamic>) {
      return [];
    }

    final responseData = response.data as Map<String, dynamic>;
    final propertiesList =
        List<Map<String, dynamic>>.from(responseData['data']);

    return propertiesList
        .map((propertyJson) => Property.fromJson(propertyJson))
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
        .map((propertyJson) => Property.fromJson(propertyJson))
        .toList();
  }
}
