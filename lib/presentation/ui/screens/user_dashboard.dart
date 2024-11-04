import 'package:estates_house/core/network/firebseApiClient.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../domain/user_singleton.dart';
import '../../../domain/entities/property.dart';
import '../widgets/property_card.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final dio = Dio();
  List<Property> userProperties = [];
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _descriptionController = TextEditingController(text: 'test');
  final _priceController = TextEditingController(text: '111111');
  final _addressController = TextEditingController(text: 'test');
  String? selectedCity;
  String? selectedPropertyType;
  String? selectedListingType;

  @override
  void initState() {
    super.initState();
    _loadUserProperties();
  }

  Future<void> _loadUserProperties() async {
    try {
      FirebaseApiClient apiClient = FirebaseApiClient();

      final response = await apiClient.dio.get(
        '${UserSingleton.baseUrl}/handle_property_crud/user/properties',
        options: Options(
          headers: {'Authorization': 'Bearer ${UserSingleton().token}'},
        ),
      );

      setState(() {
        if (response.data is! Map<String, dynamic>) {
          return;
        }
        final responseData = response.data as Map<String, dynamic>;

        final propertiesList =
            List<Map<String, dynamic>>.from(responseData['data']);

        final properties = propertiesList
            .map((propertyJson) => Property.fromJson(propertyJson))
            .toList();
        userProperties = properties;
      });
    } catch (e) {
      print(e);
      // Handle error
    }
  }

  Future<void> _deleteProperty(String id) async {
    try {
      FirebaseApiClient apiClient = FirebaseApiClient();
      await apiClient.dio.delete(
        '/handle_property_crud/properties/$id',
      );
      setState(() {
        userProperties.removeWhere((property) => property.id == id);
      });
    } catch (e) {
      debugPrint(e.toString());
      // Handle error
    }
  }

  Future<void> _addProperty() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newProperty = {
      'description': _descriptionController.text,
      'price': double.parse(_priceController.text),
      'street_address': _addressController.text,
      'city': selectedCity,
      'property_type': selectedPropertyType,
      'listing_type': selectedListingType,
    };

    try {
      FirebaseApiClient apiClient = FirebaseApiClient();
      await apiClient.dio.post(
        '/handle_property_crud/properties',
        data: newProperty,
      );

      _loadUserProperties();
      _clearForm();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _clearForm() {
    _descriptionController.clear();
    _priceController.clear();
    _addressController.clear();
    setState(() {
      selectedCity = null;
      selectedPropertyType = null;
      selectedListingType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
        title: Text('Dashboard - ${UserSingleton().email}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              UserSingleton().setUserData(null, null);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required field' : null,
                    ),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required field' : null,
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration:
                          const InputDecoration(labelText: 'Street Address'),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required field' : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedCity,
                      hint: const Text('Select City'),
                      items: ['Toronto', 'Hamilton']
                          .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedCity = value),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedPropertyType,
                      hint: const Text('Property Type'),
                      items: ['House', 'Condo']
                          .map(
                              (t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedPropertyType = value),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedListingType,
                      hint: const Text('Listing Type'),
                      items: ['For Sale', 'For Rent']
                          .map(
                              (t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedListingType = value),
                    ),
                    ElevatedButton(
                      onPressed: _addProperty,
                      child: const Text('Add Property'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: userProperties.length,
                itemBuilder: (context, index) => PropertyCard(
                  property: userProperties[index],
                  onDelete: () => _deleteProperty(userProperties[index].id),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
