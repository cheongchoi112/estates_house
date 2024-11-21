import 'package:flutter/material.dart';

class PropertySearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final String? selectedCity;
  final String? selectedPropertyType;
  final String? selectedListingType;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String?> onPropertyTypeChanged;
  final ValueChanged<String?> onListingTypeChanged;
  final VoidCallback onSearch;
  final VoidCallback onClearFilters;

  const PropertySearchBar({
    super.key,
    required this.searchController,
    required this.selectedCity,
    required this.selectedPropertyType,
    required this.selectedListingType,
    required this.onCityChanged,
    required this.onPropertyTypeChanged,
    required this.onListingTypeChanged,
    required this.onSearch,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500, // Fixed width or adjust as needed
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search properties...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                DropdownButton<String>(
                  alignment: Alignment.center,
                  underline: const SizedBox(),
                  hint: const Text('City', textAlign: TextAlign.center),
                  value: selectedCity,
                  items: ['Toronto', 'Hamilton']
                      .map(
                        (city) => DropdownMenuItem(
                          value: city,
                          child: Text(city, textAlign: TextAlign.center),
                        ),
                      )
                      .toList(),
                  onChanged: onCityChanged,
                ),
                DropdownButton<String>(
                  alignment: Alignment.center,
                  underline: const SizedBox(),
                  hint:
                      const Text('Property Type', textAlign: TextAlign.center),
                  value: selectedPropertyType,
                  items: ['House', 'Condo']
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type, textAlign: TextAlign.center),
                        ),
                      )
                      .toList(),
                  onChanged: onPropertyTypeChanged,
                ),
                DropdownButton<String>(
                  alignment: Alignment.center,
                  underline: const SizedBox(),
                  hint: const Text('Listing Type', textAlign: TextAlign.center),
                  value: selectedListingType,
                  items: ['For Sale', 'For Rent']
                      .map(
                        (listing) => DropdownMenuItem(
                          value: listing,
                          child: Text(listing, textAlign: TextAlign.center),
                        ),
                      )
                      .toList(),
                  onChanged: onListingTypeChanged,
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClearFilters,
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: onSearch,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
