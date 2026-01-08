// lib/core/constants/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary / Accent
  static const Color primaryAccent = Color(0xFF00FFA3); // Neon green
  static const Color secondaryAccent = Color(0xFF00B0FF); // Cyber blue

  // Backgrounds
  static const Color backgroundDark = Color(0xFF0A0E21); // Dark navy
  static const Color backgroundLight = Color(
    0xFFF5F7FA,
  ); // Light grey / subtle white

  // Cards / Containers
  static const Color cardDark = Color(0xFF1C1F33); // Slightly lighter dark
  static const Color cardLight = Colors.white;

  // Text
  static const Color textDark = Colors.white;
  static const Color textLight = Color(0xFF111827); // Almost black

  // Buttons
  static const Color buttonDark = primaryAccent;
  static const Color buttonLight = secondaryAccent;

  // Error / Warning
  static const Color errorColor = Color(0xFFFF4D6D); // Cyber red
  static const Color warningColor = Color(0xFFFFB800); // Amber

  // Subtle / secondary text
  static const Color textSecondaryDark = Colors.white70;
  static const Color textSecondaryLight = Colors.black54;
}
