import 'package:flutter/material.dart';

class SmartColors {
  // Get adaptive card color based on theme
  static Color cardColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF1E1E1E) : Colors.white;
  }

  // Get adaptive surface color
  static Color surfaceColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF252525) : const Color(0xFFF5F5F5);
  }

  // Get adaptive text color
  static Color textColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFFE8E8E8) : const Color(0xFF2D3436);
  }

  // Get adaptive secondary text color
  static Color secondaryTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFFB0B0B0) : const Color(0xFF636E72);
  }

  // Get adaptive icon color
  static Color iconColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFFE0E0E0) : const Color(0xFF2D3436);
  }

  // Get adaptive divider color
  static Color dividerColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);
  }

  // Get adaptive shadow color
  static Color shadowColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.1);
  }

  // Get adaptive overlay color
  static Color overlayColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF2A2A2A) : Colors.white;
  }

  // Get adaptive button text color
  static Color buttonTextColor(BuildContext context, {required Color backgroundColor}) {
    // Calculate luminance to determine if we need dark or light text
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : const Color(0xFFE8E8E8);
  }
}
