import 'package:estates_house/data/datasources/firebseApiClient.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../widgets/property_card.dart';
import '../../../domain/user_singleton.dart';
import '../../../domain/entities/property.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Property> properties = [];
  String? selectedCity;
  String? selectedPropertyType;
  String? selectedListingType;
  final dio = Dio();

  Future<void> _search() async {
    final criteria = SearchCriteria(
      city: selectedCity,
      propertyType: selectedPropertyType,
      listingType: selectedListingType,
    );

    try {
      FirebaseApiClient apiClient = FirebaseApiClient();
      final response = await apiClient.dio.post(
        '/handle_property_search',
        data: criteria.toJson(),
      );

      setState(() {
        final responseData = response.data as Map<String, dynamic>;

        final propertiesList =
            List<Map<String, dynamic>>.from(responseData['data']);

        properties = propertiesList
            .map((propertyJson) => Property.fromJson(propertyJson))
            .toList();
      });
    } catch (e) {
      debugPrint(e.toString());
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/login'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search properties...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _search,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    DropdownButton<String>(
                      hint: const Text('City'),
                      value: selectedCity,
                      items: ['Toronto', 'Hamilton']
                          .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedCity = value),
                    ),
                    // Add other filter dropdowns similarly
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: properties.length,
              itemBuilder: (context, index) => PropertyCard(
                property: properties[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
