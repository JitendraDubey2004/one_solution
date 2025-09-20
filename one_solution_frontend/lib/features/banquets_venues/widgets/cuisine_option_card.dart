// File: lib/features/banquets_venues/widgets/cuisine_option_card.dart

import 'package:flutter/material.dart';

//  Card widget for selecting a cuisine option
class CuisineOptionCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const CuisineOptionCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,  // Handling user tap to select cuisine 
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500)),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(imageUrl,
                  height: 50, width: 160, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}