import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteItem {
  final String id;
  final String name;
  final String type; // 'brand' or 'place'
  final String? category;
  final String? logo;
  final DateTime addedAt;

  FavoriteItem({
    required this.id,
    required this.name,
    required this.type,
    this.category,
    this.logo,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'category': category,
        'logo': logo,
        'addedAt': addedAt.toIso8601String(),
      };

  factory FavoriteItem.fromJson(Map<String, dynamic> json) => FavoriteItem(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        category: json['category'],
        logo: json['logo'],
        addedAt: DateTime.parse(json['addedAt']),
      );
}

class FavoritesProvider with ChangeNotifier {
  List<FavoriteItem> _favorites = [];
  static const String _storageKey = 'favorites';

  List<FavoriteItem> get favorites => _favorites;
  int get favoritesCount => _favorites.length;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? favoritesJson = prefs.getString(_storageKey);

      if (favoritesJson != null && favoritesJson.isNotEmpty) {
        final List<dynamic> decoded = json.decode(favoritesJson);
        _favorites = decoded.map((item) => FavoriteItem.fromJson(item)).toList();
        _favorites.sort((a, b) => b.addedAt.compareTo(a.addedAt));
        notifyListeners();
      }
    } catch (e) {
      print('Error loading favorites: $e');
      _favorites = [];
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = json.encode(_favorites.map((i) => i.toJson()).toList());
      await prefs.setString(_storageKey, encoded);
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  bool isFavorite(String id) {
    return _favorites.any((item) => item.id == id);
  }

  Future<void> toggleFavorite({
    required String id,
    required String name,
    required String type,
    String? category,
    String? logo,
  }) async {
    if (isFavorite(id)) {
      await removeFavorite(id);
    } else {
      await addFavorite(
        id: id,
        name: name,
        type: type,
        category: category,
        logo: logo,
      );
    }
  }

  Future<void> addFavorite({
    required String id,
    required String name,
    required String type,
    String? category,
    String? logo,
  }) async {
    if (!isFavorite(id)) {
      final item = FavoriteItem(
        id: id,
        name: name,
        type: type,
        category: category,
        logo: logo,
        addedAt: DateTime.now(),
      );
      _favorites.insert(0, item);
      await _saveFavorites();
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String id) async {
    _favorites.removeWhere((item) => item.id == id);
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> clearFavorites() async {
    _favorites.clear();
    await _saveFavorites();
    notifyListeners();
  }

  List<FavoriteItem> getFavoritesByType(String type) {
    return _favorites.where((item) => item.type == type).toList();
  }

  List<FavoriteItem> getFavoritesByCategory(String category) {
    return _favorites.where((item) => item.category == category).toList();
  }
}
