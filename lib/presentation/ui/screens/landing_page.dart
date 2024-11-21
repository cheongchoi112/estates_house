import 'package:estates_house/domain/entities/property.dart';
import 'package:estates_house/domain/services/i_property_service.dart';
import 'package:estates_house/domain/services/i_user_session_service.dart';
import 'package:estates_house/presentation/ui/widgets/property_list.dart';
import 'package:estates_house/presentation/ui/widgets/property_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// The main landing page where users can search for properties.
///
/// This screen uses `IPropertyService` and `IUserSessionService` for fetching
/// property data and managing user sessions. It utilizes `PropertyList` and
/// `PropertyCard` for displaying properties.
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
        properties = [];
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
              child: PropertySearchBar(
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
