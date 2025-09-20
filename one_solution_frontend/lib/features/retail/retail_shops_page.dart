// File: lib/features/retail/retail_shops_page.dart
//import packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Amble/features/banquets_venues/widgets/venue_dropdown.dart';


// Main page for retail shops request form
class RetailShopsPage extends StatefulWidget {
  const RetailShopsPage({super.key});

  @override
  State<RetailShopsPage> createState() => _RetailShopsPageState();
}

class _RetailShopsPageState extends State<RetailShopsPage> {

  String? selectedServiceType;
  String? selectedBudget = "5000 INR";
  String? selectedOfferWithin = "1 Week";
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  List<String> serviceTypes = ["Clothing Shop", "Salon", "Electronics", "Grocery", "Stationery"];
  // List of budget options
  List<String> budgetOptions = ["5000 INR", "10000 INR", "20000 INR", "Other"];
  List<String> offerDurations = ["1 Day", "3 Days", "1 Week", "2 Weeks"];

  List<String> countries = [];
  List<String> states = [];
  List<String> cities = [];

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  // API calls to fetch countries, states, cities
  Future<void> fetchCountries() async {
    final response = await http.get(Uri.parse('https://ssquad-backend.onrender.com/api/countries'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        countries = List<String>.from(data);
        selectedCountry = countries.isNotEmpty ? countries.first : null;
        if (selectedCountry != null) {
          fetchStates(selectedCountry!);
        }
      });
    }
  }

  Future<void> fetchStates(String country) async {
    final response = await http.get(Uri.parse('https://ssquad-backend.onrender.com/api/states?country=$country'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        states = List<String>.from(data);
        selectedState = states.isNotEmpty ? states.first : null;
        if (selectedState != null) {
          fetchCities(selectedState!);
        }
      });
    }
  }

  Future<void> fetchCities(String state) async {
    final response = await http.get(Uri.parse('https://ssquad-backend.onrender.com/api/cities?state=$state'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        cities = List<String>.from(data);
        selectedCity = cities.isNotEmpty ? cities.first : null;
      });
    }
  }

// for request submission
  Future<void> _submitRequest() async {
    // Validation
    if (selectedServiceType == null || selectedCountry == null || selectedState == null || selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final Map<String, dynamic> requestData = {
      "serviceType": selectedServiceType,
      "country": selectedCountry,
      "state": selectedState,
      "city": selectedCity,
      "budget": selectedBudget,
      "offerWithin": selectedOfferWithin,
    };

    try {
      final response = await http.post(
        Uri.parse('https://ssquad-backend.onrender.com/api/retail-shops/requests'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Retail request submitted successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit request: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade600,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
        title: const Text("Retail & Shops", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tell Us Your Retail Requirements",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Service Type
              const Text("Product/Service Type", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: selectedServiceType,
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                hint: const Text("Select service type"),
                items: serviceTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedServiceType = val),
              ),

              const SizedBox(height: 16),

              VenueDropdown(
                label: "Country",
                value: selectedCountry,
                items: countries,
                onChanged: (val) {
                  setState(() => selectedCountry = val);
                  if (val != null) {
                    fetchStates(val);
                  }
                },
              ),

              VenueDropdown(
                label: "State",
                value: selectedState,
                items: states,
                onChanged: (val) {
                  setState(() => selectedState = val);
                  if (val != null) {
                    fetchCities(val);
                  }
                },
              ),

              VenueDropdown(
                label: "City",
                value: selectedCity,
                items: cities,
                onChanged: (val) => setState(() => selectedCity = val),
              ),

              const SizedBox(height: 20),

              // Budget
              const Text(
                "Budget",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),

              // Dropdown + custom input
              DropdownButtonFormField<String>(
                initialValue:
                    selectedBudget != null &&
                        [
                          "5000 INR",
                          "10000 INR",
                          "20000 INR",
                        ].contains(selectedBudget)
                    ? selectedBudget
                    : (selectedBudget == null || selectedBudget!.endsWith("INR")
                          ? "5000 INR"
                          : "Other"),
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1,
                    ),
                  ),
                ),
                items: budgetOptions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    if (val == "Other") {
                      selectedBudget = "";
                    } else {
                      selectedBudget = val;
                    }
                  });
                },
              ),

              // Show inline TextField  if Other selected
              if (selectedBudget != null && selectedBudget!.isEmpty)
                const SizedBox(height: 10),
              if (selectedBudget != null && selectedBudget!.isEmpty)
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter custom amount",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      selectedBudget = val.isNotEmpty ? "$val INR" : "";
                    });
                  },
                ),

              const SizedBox(height: 20),

              // Offer Within
              const Text("Offer Within", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: selectedOfferWithin,
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                items: offerDurations.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => selectedOfferWithin = val),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: _submitRequest,
                  child: const Text(
                    "Submit Request",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
