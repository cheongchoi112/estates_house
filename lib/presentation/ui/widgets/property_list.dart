import 'package:flutter/material.dart';
import '../../../domain/entities/property.dart';
import 'property_card.dart';

/// A widget that displays a list of properties.
///
/// This widget uses a `GridView` to display the properties in a grid layout.
/// It calculates the number of items per row based on the screen width and
/// allows for deletion of properties if `allowDelete` is set to true.
class PropertyList extends StatelessWidget {
  final List<Property> properties;
  final bool allowDelete;
  final Function(String)? onDelete;

  const PropertyList({
    super.key,
    required this.properties,
    this.allowDelete = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return properties.isEmpty
        ? const Center(child: Text('No properties found.'))
        : LayoutBuilder(
            builder: (context, constraints) {
              // Calculate the number of items per row based on the screen width
              int crossAxisCount = (constraints.maxWidth / 400).floor();
              if (crossAxisCount > 6) crossAxisCount = 6; //

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount == 0 ? 1 : crossAxisCount,
                  childAspectRatio:
                      0.7, // Adjust this ratio to control the height
                ),
                itemCount: properties.length,
                itemBuilder: (context, index) => PropertyCard(
                  property: properties[index],
                  onDelete: allowDelete && onDelete != null
                      ? () => onDelete!(properties[index].id)
                      : null,
                ),
              );
            },
          );
  }
}
