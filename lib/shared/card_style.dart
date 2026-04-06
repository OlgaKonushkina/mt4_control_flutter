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
      border: Border.all(
        color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
        width: 1,
      ),
    );
  }

  static BoxDecoration containerDecoration({required bool isDarkMode}) {
    return BoxDecoration(
      border: Border.all(
        color: isDarkMode ? Colors.grey[600]! : Colors.grey[400]!,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  static TextStyle titleStyle({required bool isDarkMode}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: isDarkMode ? Colors.white : Colors.blueGrey[800],
    );
  }

  static TextStyle labelStyle({required bool isDarkMode}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
    );
  }

  static InputDecoration inputDecoration({required bool isDarkMode}) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: isDarkMode ? Colors.grey[600]! : Colors.grey[400]!,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      filled: true,
      fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  static ButtonStyle iconButtonStyle() {
    return IconButton.styleFrom(
      backgroundColor: Colors.blue.withOpacity(0.1),
      foregroundColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}