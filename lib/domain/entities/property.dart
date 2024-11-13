import 'package:json_annotation/json_annotation.dart';

/// Represents a price range with minimum and maximum values.
///
/// This class is used as part of the `SearchCriteria` to filter properties
/// based on their price range.
/// TODO: This is not implemented in the current version of the app.
@JsonSerializable()
class PriceRange {
  final double minPrice;
  final double maxPrice;

  PriceRange({required this.minPrice, required this.maxPrice});

  Map<String, dynamic> toJson() => {
        'min_price': minPrice,
        'max_price': maxPrice,
      };
}

/// Represents the criteria for searching properties.
///
/// This class is used to encapsulate the search filters such as city,
/// price range, property type, listing type, and keyword.
@JsonSerializable()
class SearchCriteria {
  final String? city;
  final PriceRange? priceRange;
  final String? propertyType;
  final String? listingType;
  final String? keyword;

  SearchCriteria({
    this.city,
    this.priceRange,
    this.propertyType,
    this.listingType,
    this.keyword,
  });

  Map<String, dynamic> toJson() => {
        'city': city,
        'price_range': priceRange?.toJson(),
        'property_type': propertyType,
        'listing_type': listingType,
        'keyword': keyword,
      };
}

/// Represents a property entity in the application.
///
/// This class is part of the domain layer and encapsulates the core data
/// related to a property, such as its description, price, address, and owner
/// information.
@JsonSerializable()
class Property {
  final String id;
  final String description;
  final double price;
  final String streetAddress;
  final String city;
  final String propertyType;
  final String listingType;
  final String ownerUserId;
  final String ownerEmail;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String imageUrl =
      'https://plus.unsplash.com/premium_photo-1661954372617-15780178eb2e?q=80&w=3860&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

  Property({
    required this.id,
    required this.description,
    required this.price,
    required this.streetAddress,
    required this.city,
    required this.propertyType,
    required this.listingType,
    required this.ownerUserId,
    required this.ownerEmail,
    required this.createdAt,
    required this.updatedAt,
  });
}
