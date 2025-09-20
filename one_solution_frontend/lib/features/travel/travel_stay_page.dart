
//import Packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Amble/features/banquets_venues/widgets/venue_dropdown.dart';

// Main page for travel stay request form
class TravelStayPage extends StatefulWidget {
  const TravelStayPage({super.key});

  @override
  State<TravelStayPage> createState() => _TravelStayPageState();
}

class _TravelStayPageState extends State<TravelStayPage> {
  final TextEditingController adultsController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  String? selectedHolidayType = "Adventure";
  String? selectedOffer = "24 hours";
  DateTime? checkInDate;
  DateTime? checkOutDate;

  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

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

  Future<void> _pickDate(bool isCheckIn) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

// for request submission
  Future<void> _submitRequest() async {
    final Map<String, dynamic> requestData = {
      "holidayType": selectedHolidayType,
      "country": selectedCountry,
      "state": selectedState,
      "city": selectedCity,
      "checkInDate": checkInDate?.toIso8601String(),
      "checkOutDate": checkOutDate?.toIso8601String(),
      "numberOfAdults": int.tryParse(adultsController.text) ?? 0,
      "offerWithin": selectedOffer,
    };

    try {
      final response = await http.post(
        Uri.parse('https://ssquad-backend.onrender.com/api/travel-stay/requests'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Travel request submitted successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    adultsController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade600,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
        title: const Text("Travel & Stay", style: TextStyle(color: Colors.white)),
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
                "Tell Us Your Travel Requirements",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              // Holiday Type
              VenueDropdown(
                label: "Holiday Type",
                value: selectedHolidayType,
                items: ["Adventure", "Relaxation", "Family", "Romantic", "Cultural"],
                onChanged: (value) => setState(() => selectedHolidayType = value),
              ),
              
              // Country Dropdown
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

              // State Dropdown
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

              // City Dropdown
              VenueDropdown(
                label: "City",
                value: selectedCity,
                items: cities,
                onChanged: (val) => setState(() => selectedCity = val),
              ),

              const Text("Check-in & Check-out", style: TextStyle(color: Colors.grey)),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickDate(true),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(checkInDate != null
                            ? "${checkInDate!.day}/${checkInDate!.month}/${checkInDate!.year}"
                            : "Check-in Date"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickDate(false),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(checkOutDate != null
                            ? "${checkOutDate!.day}/${checkOutDate!.month}/${checkOutDate!.year}"
                            : "Check-out Date"),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text("Number of Adults", style: TextStyle(color: Colors.grey)),
              TextField(
                controller: adultsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter number of adults",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Offer Within",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                initialValue: selectedOffer,
                items: ["24 hours", "3 days", "1 week", "2 weeks"]
                    .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                    .toList(),
                onChanged: (value) => setState(() => selectedOffer = value),
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