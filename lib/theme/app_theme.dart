import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A202C),
      ),
      displayMedium: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: Color(0xFF2D3748),
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D3748),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Color(0xFF4A5568),
        height: 1.7,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFF718096),
        height: 1.6,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF6366F1),
      secondary: Color(0xFFEC4899),
      tertiary: Color(0xFF06B6D4),
      surface: Color(0xFFFFFFFF),
      background: Color(0xFFF8FAFC),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1A202C),
      onBackground: Color(0xFF1A202C),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF0F0F23),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: Color(0xFFF1F5F9),
      ),
      displayMedium: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: Color(0xFFE2E8F0),
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFFE2E8F0),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Color(0xFFA1A1AA),
        height: 1.7,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFF71717A),
        height: 1.6,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF8B5CF6),
      secondary: Color(0xFFEC4899),
      tertiary: Color(0xFF06B6D4),
      surface: Color(0xFF1E1E2E),
      background: Color(0xFF0F0F23),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFFF1F5F9),
      onBackground: Color(0xFFF1F5F9),
    ),
  );

  // Glass effect colors for light theme
  static const Color lightGlassColor = Color(0x30FFFFFF);
  static const Color lightGlassBorder = Color(0x40FFFFFF);

  // Glass effect colors for dark theme
  static const Color darkGlassColor = Color(0x15FFFFFF);
  static const Color darkGlassBorder = Color(0x25FFFFFF);

  // Gradient colors
  static const List<Color> lightGradient = [
    Color(0xFFF8FAFC),
    Color(0xFFE2E8F0),
    Color(0xFFF1F5F9),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF0F0F23),
    Color(0xFF1E1E2E),
    Color(0xFF262640),
  ];
}
