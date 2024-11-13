import '../entities/property.dart';
import 'package:intl/intl.dart';

abstract class IPropertyFactory {
  Property createFromJson(Map<String, dynamic> json);
}

class PropertyFactory implements IPropertyFactory {
  @override
  Property createFromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      description: json['description'],
      price: json['price'].toDouble(),
      streetAddress: json['street_address'],
      city: json['city'],
      propertyType: json['property_type'],
      listingType: json['listing_type'],
      ownerUserId: json['owner_user_id'],
      ownerEmail: json['owner_email'],
      createdAt:
          DateFormat('EEE, dd MMM yyyy HH:mm:ss z').parse(json['created_at']),
      updatedAt:
          DateFormat('EEE, dd MMM yyyy HH:mm:ss z').parse(json['updated_at']),
    );
  }
}