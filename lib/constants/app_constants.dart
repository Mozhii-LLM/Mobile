import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryDarkBlue = Color(0xFF001F3F);
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkGray = Color(0xFF2A2A2A);
  static const Color mediumGray = Color(0xFF3A3A3A);
  static const Color lightGray = Color(0xFF6A6A6A);
  static const Color textGray = Color(0xFFAAAAAA);
  static const Color gradientBlue1 = Color(0xFF3B82F6);
  static const Color gradientBlue2 = Color(0xFF0EA5E9);
  static const Color gradientCyan = Color(0xFF06B6D4);
  static const Color buttonBlue = Color(0xFF1E3A5F);
  static const Color inputBackground = Color(0xFF0F2847);
  static const Color chatBubbleUser = Color(0xFF1E3A5F);
  static const Color chatBubbleAI = Color(0xFF2A2A2A);

  // Text Styles
  static const TextStyle appTitle = TextStyle(
    fontFamily: 'serif',
    fontSize: 48,
    fontWeight: FontWeight.w300,
    color: Colors.white,
    letterSpacing: 2,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle menuItemText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle settingsHeader = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle settingsSubtext = TextStyle(
    fontSize: 14,
    color: Color(0xFFAAAAAA),
  );

  // Gradients
  static const LinearGradient logoGradient = LinearGradient(
    colors: [gradientBlue1, gradientBlue2, gradientCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
