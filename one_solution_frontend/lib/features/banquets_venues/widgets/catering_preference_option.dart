// File: lib/features/banquets_venues/widgets/catering_preference_option.dart

import 'package:flutter/material.dart';

//Card widget for catering preference Veg/Non-Veg 
class CateringPreferenceOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const CateringPreferenceOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,   // Handle tap to select preference
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? color : Colors.grey),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}