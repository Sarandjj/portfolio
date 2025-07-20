// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color flutterBlue = Color(0xFF0175C2);
  static const Color flutterDarkBlue = Color(0xFF13B9FD);
  static const Color flutterNavy = Color(0xFF042B59);
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFFF8FAFF),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
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
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF4A5568), height: 1.7),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF718096), height: 1.6),
    ),
    colorScheme: const ColorScheme.light(
      primary: flutterBlue,
      secondary: flutterDarkBlue,
      tertiary: Color(0xFF5DADE2),
      surface: Color(0xFFFFFFFF),
      background: Color(0xFFF8FAFF),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1A202C),
      onBackground: Color(0xFF1A202C),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF0A0E1A),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
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
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFA1A1AA), height: 1.7),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF71717A), height: 1.6),
    ),
    colorScheme: const ColorScheme.dark(
      primary: flutterDarkBlue,
      secondary: Color(0xFF7DD3FC),
      tertiary: Color(0xFF93C5FD),
      surface: Color(0xFF1E293B),
      background: Color(0xFF0A0E1A),
      onPrimary: Color(0xFF0F172A),
      onSecondary: Color(0xFF0F172A),
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

  // Updated gradient colors with green/blue theme
  static const List<Color> lightGradient = [
    Color(0xFFF8FAFF),
    Color(0xFFE0F2FE),
    Color(0xFFBAE6FD),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF0A0E1A),
    Color(0xFF1E293B),
    Color(0xFF042B59),
  ];
}
