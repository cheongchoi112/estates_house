import 'package:estates_house/domain/entities/property.dart';
import 'package:estates_house/domain/services/i_property_service.dart';
import 'package:estates_house/domain/services/i_user_session_service.dart';
import 'package:estates_house/presentation/ui/widgets/property_list.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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

  final IPropertyService _propertyService = GetIt.instance<IPropertyService>();
  final IUserSessionService _userSessionService =
      GetIt.instance<IUserSessionService>();

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
      final searchResults = await _propertyService.searchProperties(criteria);
      setState(() {
        properties = searchResults;
      });
    } catch (e) {
      debugPrint(e.toString());
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
        title: const Text('Property Connect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              final token = _userSessionService.token;
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
              child: SearchBar(
                searchController: _searchController,
                selectedCity: selectedCity,
                selectedPropertyType: selectedPropertyType,
                selectedListingType: selectedListingType,
                onCityChanged: (value) => setState(() => selectedCity = value),
                onPropertyTypeChanged: (value) =>
                    setState(() => selectedPropertyType = value),
                onListingTypeChanged: (value) =>
                    setState(() => selectedListingType = value),
                onSearch: _search,
                onClearFilters: _clearFilters,
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

class SearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final String? selectedCity;
  final String? selectedPropertyType;
  final String? selectedListingType;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String?> onPropertyTypeChanged;
  final ValueChanged<String?> onListingTypeChanged;
  final VoidCallback onSearch;
  final VoidCallback onClearFilters;

  const SearchBar({
    Key? key,
    required this.searchController,
    required this.selectedCity,
    required this.selectedPropertyType,
    required this.selectedListingType,
    required this.onCityChanged,
    required this.onPropertyTypeChanged,
    required this.onListingTypeChanged,
    required this.onSearch,
    required this.onClearFilters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center the search bar on the screen
      child: Container(
        width: 500,
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Expanded(
            //   child: TextField(
            //     controller: searchController,
            //     decoration: const InputDecoration(
            //       hintText: 'Search properties...',
            //       border: InputBorder.none,
            //     ),
            //   ),
            // ),
            const SizedBox(width: 8), // Spacer between controls
            DropdownButton<String>(
              alignment: Alignment.center, // Center the text
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
            const SizedBox(width: 8),
            DropdownButton<String>(
              alignment: Alignment.center,
              underline: const SizedBox(),
              hint: const Text('Property Type', textAlign: TextAlign.center),
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
            const SizedBox(width: 8),
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
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: onClearFilters,
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: onSearch,
            ),
          ],
        ),
      ),
    );
  }
}
