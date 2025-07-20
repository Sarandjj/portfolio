import 'package:flutter/material.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

  Color get glassColor =>
      _isDarkMode ? AppTheme.darkGlassColor : AppTheme.lightGlassColor;

  Color get glassBorderColor =>
      _isDarkMode ? AppTheme.darkGlassBorder : AppTheme.lightGlassBorder;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
