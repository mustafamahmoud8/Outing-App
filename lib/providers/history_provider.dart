import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum HistoryType { search, visit, plan, budget }

class HistoryItem {
  final String id;
  final HistoryType type;
  final String title;
  final String? subtitle;
  final DateTime timestamp;

  HistoryItem({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'title': title,
    'subtitle': subtitle,
    'timestamp': timestamp.toIso8601String(),
  };

  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
    id: json['id'],
    type: HistoryType.values.firstWhere((e) => e.toString() == json['type']),
    title: json['title'],
    subtitle: json['subtitle'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

class HistoryProvider with ChangeNotifier {
  List<HistoryItem> _items = [];
  static const String _storageKey = 'history_items';

  List<HistoryItem> get items => _items;

  HistoryProvider() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString(_storageKey);
    
    if (historyJson != null) {
      final List<dynamic> decoded = json.decode(historyJson);
      _items = decoded.map((item) => HistoryItem.fromJson(item)).toList();
      _items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      notifyListeners();
    }
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_items.map((i) => i.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  Future<void> addSearch(String query) async {
    final item = HistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: HistoryType.search,
      title: query,
      timestamp: DateTime.now(),
    );
    _items.insert(0, item);
    await _saveHistory();
    notifyListeners();
  }

  Future<void> addVisit(String placeName, String? location) async {
    final item = HistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: HistoryType.visit,
      title: placeName,
      subtitle: location,
      timestamp: DateTime.now(),
    );
    _items.insert(0, item);
    await _saveHistory();
    notifyListeners();
  }

  Future<void> addToPlan(String placeName) async {
    final item = HistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: HistoryType.plan,
      title: placeName,
      subtitle: 'Added to plan',
      timestamp: DateTime.now(),
    );
    _items.insert(0, item);
    await _saveHistory();
    notifyListeners();
  }

  Future<void> addBudgetChange(String description, double amount) async {
    final item = HistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: HistoryType.budget,
      title: description,
      subtitle: '${amount.toStringAsFixed(0)} EGP',
      timestamp: DateTime.now(),
    );
    _items.insert(0, item);
    await _saveHistory();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _items.clear();
    await _saveHistory();
    notifyListeners();
  }
}
