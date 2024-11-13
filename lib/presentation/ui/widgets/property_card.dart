import 'package:flutter/material.dart';
import '../../../domain/entities/property.dart';

/// A widget that represents an individual property card.
///
/// This widget is used in the presentation layer to display the details of a
/// property, such as its image, description, price, and owner information.
/// It also provides an option to delete the property if the `onDelete` callback
/// is provided.
class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback? onDelete;

  const PropertyCard({
    super.key,
    required this.property,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property Image
              AspectRatio(
                aspectRatio: 4 / 3,
                child: property.imageUrl.isNotEmpty
                    ? Image.network(
                        property.imageUrl,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: colorScheme.onSurface.withOpacity(0.1),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                          ),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Property Type and City
                    Text(
                      '${property.propertyType} • ${property.city}',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Listing Type
                    Text(
                      'Listing Type: ${property.listingType}',
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 4),
                    // Description
                    Text(
                      property.description,
                      style: textTheme.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Address
                    Text(
                      'Address: ${property.streetAddress}',
                      style: textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Owner
                    Text(
                      'Owner: ${property.ownerEmail}',
                      style: textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    // Price aligned to the right
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '\$${property.price.toStringAsFixed(2)}',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (onDelete != null)
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                backgroundColor: Colors.white70,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
