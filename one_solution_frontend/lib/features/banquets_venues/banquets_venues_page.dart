// File: lib/features/banquets_venues/banquets_venues_page.dart

// importing packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Amble/features/banquets_venues/widgets/catering_preference_option.dart';
import 'package:Amble/features/banquets_venues/widgets/cuisine_option_card.dart';
import 'package:Amble/features/banquets_venues/widgets/venue_dropdown.dart';


// Main page for banquet venues request form
class BanquetsVenuesPage extends StatefulWidget {
  const BanquetsVenuesPage({super.key});

  @override
  State<BanquetsVenuesPage> createState() => _BanquetsVenuesPageState();
}

class _BanquetsVenuesPageState extends State<BanquetsVenuesPage> {
   // State variables for form inputs
  String? selectedEventType = "Wedding";
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  final TextEditingController adultsController = TextEditingController(
    text: "250",
  );

  List<DateTime> eventDates = [DateTime(2025, 3, 1), DateTime(2025, 3, 2)];
  String? cateringPreference = "Veg";
  List<String> selectedCuisines = [];
  String? selectedBudget = "5000 INR";
  String? selectedOffer = "24 hours";

  List<String> countries = [];
  List<String> states = [];
  List<String> cities = [];

  // List of budget options
  List<String> budgetOptions = ["5000 INR", "10000 INR", "20000 INR", "Other"];

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  // API calls to fetch countries, states, cities
  Future<void> fetchCountries() async {
    final response = await http.get(
      Uri.parse('https://ssquad-backend.onrender.com/api/countries'),
    );
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
    final response = await http.get(
      Uri.parse('https://ssquad-backend.onrender.com/api/states?country=$country'),
    );
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
    final response = await http.get(
      Uri.parse('https://ssquad-backend.onrender.com/api/cities?state=$state'),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        cities = List<String>.from(data);
        selectedCity = cities.isNotEmpty ? cities.first : null;
      });
    }
  }

//for events date
  Future<void> _pickDate(int index) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: eventDates[index],
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        eventDates[index] = picked;
      });
    }
  }

  void _addDate() {
    setState(() {
      eventDates.add(DateTime.now());
    });
  }

// for request submission
  Future<void> _submitRequest() async {
    final Map<String, dynamic> requestData = {
      "eventType": selectedEventType,
      "country": selectedCountry,
      "state": selectedState,
      "city": selectedCity,
      "eventDates": eventDates.map((date) => date.toIso8601String()).toList(),
      "numberOfAdults": int.tryParse(adultsController.text) ?? 0,
      "cateringPreference": cateringPreference,
      "cuisines": selectedCuisines,
      "budget": selectedBudget,
      "offerWithin": selectedOffer,
    };

    try {
      final response = await http.post(
        Uri.parse('https://ssquad-backend.onrender.com/api/banquets-venues/requests'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request submitted successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit request: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    }
  }

  @override
  void dispose() {
    adultsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade600,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
        title: const Text(
          "Banquets & Venues",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
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
                "Tell Us Your Venue Requirements",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              VenueDropdown(
                label: "Event Type",
                value: selectedEventType,
                items: [
                  "Wedding",
                  "Anniversary",
                  "Corporate event",
                  "Other Party",
                ],
                onChanged: (val) => setState(() => selectedEventType = val),
              ),

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

              const Text(
                "Event Dates",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),

              Column(
                children: List.generate(eventDates.length, (index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${eventDates[index].day} "
                          "${_monthName(eventDates[index].month)} "
                          "${eventDates[index].year}",
                          style: const TextStyle(fontSize: 15),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _pickDate(index),
                              child: const Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  eventDates.removeAt(index);
                                });
                              },
                              child: const Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),

              GestureDetector(
                onTap: _addDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(Icons.add, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(
                        "Add more dates",
                        style: TextStyle(color: Colors.blue, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Number of Adults",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: adultsController,
                decoration: InputDecoration(
                  hintText: "Enter number of adults",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),
              const Text(
                "Catering Preference",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CateringPreferenceOption(
                      label: "Veg",
                      icon: Icons.eco,
                      color: Colors.green,
                      isSelected: cateringPreference == "Veg",
                      onTap: () {
                        setState(() => cateringPreference = "Veg");
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CateringPreferenceOption(
                      label: "Non-veg",
                      icon: Icons.set_meal,
                      color: Colors.red,
                      isSelected: cateringPreference == "Non-veg",
                      onTap: () {
                        setState(() => cateringPreference = "Non-veg");
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Text(
                "Please select your Cuisines",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              CuisineOptionCard(
                title: "Indian",
                imageUrl:
                    "https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg",
                isSelected: selectedCuisines.contains("Indian"),
                onTap: () {
                  setState(() {
                    if (selectedCuisines.contains("Indian")) {
                      selectedCuisines.remove("Indian");
                    } else {
                      selectedCuisines.add("Indian");
                    }
                  });
                },
              ),
              CuisineOptionCard(
                title: "Italian",
                imageUrl:
                    "https://images.pexels.com/photos/1566837/pexels-photo-1566837.jpeg",
                isSelected: selectedCuisines.contains("Italian"),
                onTap: () {
                  setState(() {
                    if (selectedCuisines.contains("Italian")) {
                      selectedCuisines.remove("Italian");
                    } else {
                      selectedCuisines.add("Italian");
                    }
                  });
                },
              ),
              CuisineOptionCard(
                title: "Asian",
                imageUrl:
                    "https://images.pexels.com/photos/33933381/pexels-photo-33933381.jpeg",
                isSelected: selectedCuisines.contains("Asian"),
                onTap: () {
                  setState(() {
                    if (selectedCuisines.contains("Asian")) {
                      selectedCuisines.remove("Asian");
                    } else {
                      selectedCuisines.add("Asian");
                    }
                  });
                },
              ),
              CuisineOptionCard(
                title: "Mexican",
                imageUrl:
                    "https://images.pexels.com/photos/7613561/pexels-photo-7613561.jpeg",
                isSelected: selectedCuisines.contains("Mexican"),
                onTap: () {
                  setState(() {
                    if (selectedCuisines.contains("Mexican")) {
                      selectedCuisines.remove("Mexican");
                    } else {
                      selectedCuisines.add("Mexican");
                    }
                  });
                },
              ),

              const SizedBox(height: 20),
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
              const Text(
                "Get offer within (optional)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  setState(() => selectedOffer = "24 hours");
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: selectedOffer == "24 hours"
                          ? Colors.blue
                          : Colors.grey.shade400,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "24 hours",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Needs 1 extra points",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Normal response time is within 2 days",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
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

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }
}
