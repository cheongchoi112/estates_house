import 'package:estates_house/domain/entities/property.dart';

/// Interface for property-related operations.
///
/// This interface is part of the domain layer and defines the contract for
/// managing property data. It is implemented by the `PropertyService` class
/// in the data layer.
abstract interface class IPropertyService {
  Future<List<Property>> getUserProperties();
  Future<void> deleteProperty(String id);
  Future<void> addProperty(Map<String, dynamic> newProperty);
  Future<List<Property>> searchProperties(SearchCriteria criteria);
}
