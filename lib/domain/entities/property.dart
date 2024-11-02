import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

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

@JsonSerializable()
class SearchCriteria {
  final String? city;
  final PriceRange? priceRange;
  final String? propertyType;
  final String? listingType;

  SearchCriteria({
    this.city,
    this.priceRange,
    this.propertyType,
    this.listingType,
  });

  Map<String, dynamic> toJson() => {
        'city': city,
        'price_range': priceRange?.toJson(),
        'property_type': propertyType,
        'listing_type': listingType,
      };
}

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

  factory Property.fromJson(Map<String, dynamic> json) => Property(
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
        //    updatedAt: DateTime.parse(json['updated_at']),
      );
}
