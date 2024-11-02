import 'package:flutter/material.dart';
import '../../../domain/entities/property.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback? onDelete;

  const PropertyCard({
    Key? key,
    required this.property,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text('${property.propertyType} in ${property.city}'),
        subtitle: Text(property.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('\$${property.price.toStringAsFixed(2)}'),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
