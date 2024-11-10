import 'package:estates_house/domain/entities/property.dart';

abstract interface class IPropertyService {
  Future<List<Property>> getUserProperties();
  Future<void> deleteProperty(String id);
  Future<void> addProperty(Map<String, dynamic> newProperty);
  Future<List<Property>> searchProperties(SearchCriteria criteria);
}
