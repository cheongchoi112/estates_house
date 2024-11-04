import 'package:estates_house/core/network/firebseApiClient.dart';
import 'package:estates_house/domain/user_singleton.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../widgets/property_card.dart';
import '../widgets/property_list.dart';
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

  @override
  void initState() {
    super.initState();
  }

  Future<void> _search() async {
    final criteria = SearchCriteria(
      keyword: _searchController.text,
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
        properties = [];
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

  void _clearFilters() {
    setState(() {
      selectedCity = null;
      selectedPropertyType = null;
      selectedListingType = null;
      _searchController.clear();
      setState(() {
        properties = []; // Empty the listing before loading new properties
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Landing Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              final token = UserSingleton().token;
              if (token != null) {
                Navigator.pushNamed(context, '/dashboard');
              } else {
                Navigator.pushNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    runSpacing: 8,
                    children: [
                      DropdownButton<String>(
                        hint: const Text('City'),
                        value: selectedCity,
                        items: ['Toronto', 'Hamilton']
                            .map((c) =>
                                DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedCity = value),
                      ),
                      DropdownButton<String>(
                        hint: const Text('Property Type'),
                        value: selectedPropertyType,
                        items: ['House', 'Condo']
                            .map((type) => DropdownMenuItem(
                                value: type, child: Text(type)))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedPropertyType = value),
                      ),
                      DropdownButton<String>(
                        hint: const Text('Listing Type'),
                        value: selectedListingType,
                        items: ['For Sale', 'For Rent']
                            .map((type) => DropdownMenuItem(
                                value: type, child: Text(type)))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedListingType = value),
                      ),
                      ElevatedButton.icon(
                        onPressed: _clearFilters,
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear Filters'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            PropertyList(
              properties: properties,
            ),
          ],
        ),
      ),
    );
  }
}
