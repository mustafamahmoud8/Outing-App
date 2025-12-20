import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum OutingType { solo, couple, friends, family }

class OutingTypeProvider with ChangeNotifier {
  OutingType _selectedType = OutingType.solo;
  static const String _storageKey = 'outing_type';

  OutingType get selectedType => _selectedType;

  OutingTypeProvider() {
    _loadOutingType();
  }

  Future<void> _loadOutingType() async {
    final prefs = await SharedPreferences.getInstance();
    final typeIndex = prefs.getInt(_storageKey) ?? 0;
    _selectedType = OutingType.values[typeIndex];
    notifyListeners();
  }

  Future<void> setOutingType(OutingType type) async {
    _selectedType = type;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_storageKey, type.index);
    notifyListeners();
  }

  String get typeLabel {
    switch (_selectedType) {
      case OutingType.solo:
        return 'Solo';
      case OutingType.couple:
        return 'Couple';
      case OutingType.friends:
        return 'Friends';
      case OutingType.family:
        return 'Family';
    }
  }

  String get typeIcon {
    switch (_selectedType) {
      case OutingType.solo:
        return '👤';
      case OutingType.couple:
        return '💑';
      case OutingType.friends:
        return '👥';
      case OutingType.family:
        return '👨‍👩‍👧‍👦';
    }
  }

  List<String> getSuitableCategories() {
    switch (_selectedType) {
      case OutingType.solo:
        return ['Cafes', 'Parks', 'Museums'];
      case OutingType.couple:
        return ['Restaurants', 'Cafes', 'Parks', 'Entertainment'];
      case OutingType.friends:
        return ['Restaurants', 'Cafes', 'Entertainment', 'Shopping'];
      case OutingType.family:
        return ['Restaurants', 'Parks', 'Entertainment', 'Shopping'];
    }
  }
}
