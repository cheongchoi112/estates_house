import 'package:flutter/material.dart';
import '../../../domain/entities/property.dart';
import 'property_card.dart';

class PropertyList extends StatelessWidget {
  final List<Property> properties;
  final bool allowDelete;
  final Function(String)? onDelete;

  const PropertyList({
    Key? key,
    required this.properties,
    this.allowDelete = false,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return properties.isEmpty
        ? const Center(child: Text('No properties found.'))
        : LayoutBuilder(
            builder: (context, constraints) {
              // Calculate the number of items per row based on the screen width
              int crossAxisCount = (constraints.maxWidth / 400).ceil();
              if (crossAxisCount > 6) crossAxisCount = 6; //

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
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
