// File: lib/main.dart

import 'package:flutter/material.dart';
import 'package:Amble/features/home/home_page.dart';


// The entry point of  application
void main() {
  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

