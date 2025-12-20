import 'package:flutter/material.dart';

/// Adaptive colors that automatically adjust based on theme brightness
class AdaptiveColors {
  /// Get card background color - white in light, dark gray in dark mode
  static Color cardBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF1E1E1E) : Colors.white;
  }

  /// Get surface color - light gray in light, darker gray in dark mode
  static Color surface(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF252525) : const Color(0xFFF5F5F5);
  }

  /// Get text color - dark in light, WHITE in dark mode for clarity
  static Color text(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white : const Color(0xFF2D3436);
  }

  /// Get primary text color (same as text for consistency)
  static Color textPrimary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white : const Color(0xFF2D3436);
  }

  /// Get secondary text color
  static Color textSecondary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFFB0B0B0) : const Color(0xFF636E72);
  }

  /// Get icon color
  static Color icon(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFFE0E0E0) : const Color(0xFF2D3436);
  }

  /// Get divider color
  static Color divider(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);
  }

  /// Get overlay/modal background
  static Color overlay(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF2A2A2A) : Colors.white;
  }

  /// Get button background (for white buttons in light mode)
  static Color buttonBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF2A2A2A) : Colors.white;
  }

  /// Get button text color (opposite of background)
  static Color buttonText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFFE0E0E0) : const Color(0xFF2D3436);
  }

  /// Get search bar background
  static Color searchBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF2A2A2A) : Colors.white;
  }

  /// Get chip/tag background
  static Color chipBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5);
  }
}
