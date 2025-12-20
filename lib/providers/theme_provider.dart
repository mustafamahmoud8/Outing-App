import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  // Professional Light Theme
  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: const Color(0xFFEF7A22),
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFEF7A22),
      secondary: Color(0xFFFF6584),
      surface: Colors.white,
      background: Color(0xFFF8F9FA),
      error: Color(0xFFFF5252),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFEF7A22),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEF7A22),
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  // Professional Dark Theme
  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFFF8C42),
    scaffoldBackgroundColor: const Color(0xFF0D1117),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFF8C42),
      secondary: Color(0xFFFF7A9A),
      surface: Color(0xFF161B22),
      background: Color(0xFF0D1117),
      error: Color(0xFFFF6B6B),
      onPrimary: Color(0xFF0D1117),
      onSecondary: Colors.white,
      onSurface: Color(0xFFC9D1D9),
      onBackground: Color(0xFFC9D1D9),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF161B22),
      foregroundColor: Color(0xFFC9D1D9),
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF161B22),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF8C42),
        foregroundColor: const Color(0xFF0D1117),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF21262D),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: Color(0xFF8B949E)),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFC9D1D9)),
      bodyMedium: TextStyle(color: Color(0xFFC9D1D9)),
      titleLarge: TextStyle(color: Color(0xFFC9D1D9)),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFC9D1D9)),
  );
}
