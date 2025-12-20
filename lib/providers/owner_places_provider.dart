import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OwnerPlace {
  final String id;
  final String name;
  final String category;
  final String address;
  final String phone;
  final String description;
  final List<String> imagePaths;
  final DateTime addedAt;

  OwnerPlace({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.phone,
    required this.description,
    required this.imagePaths,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'address': address,
    'phone': phone,
    'description': description,
    'imagePaths': imagePaths,
    'addedAt': addedAt.toIso8601String(),
  };

  factory OwnerPlace.fromJson(Map<String, dynamic> json) => OwnerPlace(
    id: json['id'],
    name: json['name'],
    category: json['category'],
    address: json['address'],
    phone: json['phone'],
    description: json['description'],
    imagePaths: List<String>.from(json['imagePaths']),
    addedAt: DateTime.parse(json['addedAt']),
  );
}

class OwnerPlacesProvider with ChangeNotifier {
  List<OwnerPlace> _places = [];
  static const String _storageKey = 'owner_places';

  List<OwnerPlace> get places => _places;

  OwnerPlacesProvider() {
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final String? placesJson = prefs.getString(_storageKey);
    
    if (placesJson != null) {
      final List<dynamic> decoded = json.decode(placesJson);
      _places = decoded.map((item) => OwnerPlace.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _savePlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_places.map((p) => p.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  Future<void> addPlace(OwnerPlace place) async {
    _places.add(place);
    await _savePlaces();
    notifyListeners();
  }

  Future<void> removePlace(String id) async {
    _places.removeWhere((p) => p.id == id);
    await _savePlaces();
    notifyListeners();
  }
}
