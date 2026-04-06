import 'package:flutter/material.dart';

class CardStyle {
  static BoxDecoration decoration({required bool isDarkMode}) {
    return BoxDecoration(
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: isDarkMode ? Colors.black54 : Colors.grey.shade300,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static TextStyle titleStyle({required bool isDarkMode}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: isDarkMode ? Colors.white : Colors.black87,
    );
  }

  static InputDecoration inputDecoration({required bool isDarkMode}) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}