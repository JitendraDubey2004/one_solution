// File: lib/features/home/home_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Amble/features/banquets_venues/banquets_venues_page.dart';
import 'package:Amble/features/home/widgets/category_card.dart';
import 'package:Amble/features/travel/travel_stay_page.dart';
import 'package:Amble/features/retail/retail_shops_page.dart';

// Category model
class Category {
  final int id;
  final String name;
  final String imageUrl;
  final IconData icon;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    IconData iconData;
    switch (json['icon']) {
      case 'hotel':
        iconData = Icons.hotel;
        break;
      case 'event':
        iconData = Icons.event;
        break;
      case 'store':
        iconData = Icons.store;
        break;
      default:
        iconData = Icons.category;
    }

    return Category(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      icon: iconData,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> categories = [];
  List<Category> filteredCategories = []; // for search
  bool isLoading = true;
  String error = '';
  late ScrollController _scrollController;
  bool _showFloatingSIcon = false;
    bool notificationsOn = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    fetchCategories();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 200 && !_showFloatingSIcon) {
      setState(() {
        _showFloatingSIcon = true;
      });
    } else if (_scrollController.offset <= 200 && _showFloatingSIcon) {
      setState(() {
        _showFloatingSIcon = false;
      });
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('https://ssquad-backend.onrender.com/api/categories'),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          categories = data.map((json) => Category.fromJson(json)).toList();
          filteredCategories = categories; // copy original list
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load categories: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  // Floating S icon
  Widget _buildSIcon() {
    return GestureDetector(
    onTap: () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("We will reach to you soon!"),
          duration: Duration(seconds: 2),
        ),
      );
    },
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 1, 50, 91),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(5),
            ),
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.green[400],
          radius: 20,
          child: const Text(
            "S",
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[200],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 72, 167, 244),
              ),
              accountName: const Text(
                "Jitendra Dubey",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text(
                "jitendra@example.com", // optional: can be removed
                style: TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg", 
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Add Account'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('Orders'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.update),
              title: const Text('Your Updates'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings and Privacy'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top blue header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                _scaffoldKey.currentState?.openDrawer(),
                            child: Row(
                              children: const [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                    "https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg", 
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Jitendra Dubey",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              _buildSIcon(),
                              const SizedBox(width: 8),

                              // 🔔 Notification Bell
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    notificationsOn = !notificationsOn;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        notificationsOn
                                            ? "Notifications turned ON 🔔"
                                            : "Notifications turned OFF 🔕",
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: notificationsOn
                                        ? const Color.fromARGB(
                                            255,
                                            0,
                                            70,
                                            128,
                                          ) // background ON
                                        : Colors
                                              .transparent, // remove background when OFF
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    notificationsOn
                                        ? Icons.notifications
                                        : Icons.notifications_none,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Free plan card
                      
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Free plan",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "Bid left: 3",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "You have 3 bids left. Upgrade now to Bid more.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Search bar with live filter
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5874a3),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            hintText: "Search",
                            icon: Icon(Icons.search, color: Colors.white),
                          ),
                          onChanged: (query) {
                            setState(() {
                              filteredCategories = categories
                                  .where(
                                    (category) => category.name
                                        .toLowerCase()
                                        .contains(query.toLowerCase()),
                                  )
                                  .toList();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Categories
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : error.isNotEmpty
                          ? Center(child: Text(error))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredCategories.length,
                              itemBuilder: (context, index) {
                                final category = filteredCategories[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: CategoryCard(
                                    imageUrl: category.imageUrl,
                                    title: category.name,
                                    icon: category.icon,
                                    onTap: () {
                                      if (category.name ==
                                          "Banquets & Venues") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const BanquetsVenuesPage(),
                                          ),
                                        );
                                      } else if (category.name ==
                                          "Travel & Stay") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const TravelStayPage(),
                                          ),
                                        );
                                      } else if (category.name ==
                                          "Retail stores & Shops") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const RetailShopsPage(),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_showFloatingSIcon)
            Positioned(right: 16, top: 80, child: _buildSIcon()),
        ],
      ),
    );
  }
}
