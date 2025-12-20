import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:outing/providers/history_provider.dart';
import 'dart:convert';

class BudgetProvider with ChangeNotifier {
  double _totalBudget = 0;
  double _minPricePerPlace = 0;
  double _maxPricePerPlace = 0;
  double _usedBudget = 0;
  List<Map<String, dynamic>> _selectedPlaces = [];
  int _participantCount = 1;
  List<String> _participantNames = [];

  double get totalBudget => _totalBudget;
  double get minPricePerPlace => _minPricePerPlace;
  double get maxPricePerPlace => _maxPricePerPlace;
  double get usedBudget => _usedBudget;
  double get remainingBudget => _totalBudget - _usedBudget;
  List<Map<String, dynamic>> get selectedPlaces => _selectedPlaces;
  int get participantCount => _participantCount;
  List<String> get participantNames => _participantNames;
  
  double get perPersonBudget => _participantCount > 0 ? _totalBudget / _participantCount : 0;
  double get perPersonUsed => _participantCount > 0 ? _usedBudget / _participantCount : 0;
  double get perPersonRemaining => _participantCount > 0 ? remainingBudget / _participantCount : 0;

  BudgetProvider() {
    _loadBudget();
  }

  Future<void> _loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    _totalBudget = prefs.getDouble('totalBudget') ?? 0;
    _minPricePerPlace = prefs.getDouble('minPricePerPlace') ?? 0;
    _maxPricePerPlace = prefs.getDouble('maxPricePerPlace') ?? 0;
    _usedBudget = prefs.getDouble('usedBudget') ?? 0;
    _participantCount = prefs.getInt('participantCount') ?? 1;
    
    final participantsJson = prefs.getString('participantNames');
    if (participantsJson != null && participantsJson.isNotEmpty) {
      _participantNames = List<String>.from(json.decode(participantsJson));
    }
    
    notifyListeners();
  }

  Future<void> setBudget(double total, double minPrice, double maxPrice) async {
    _totalBudget = total;
    _minPricePerPlace = minPrice;
    _maxPricePerPlace = maxPrice;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('totalBudget', total);
    await prefs.setDouble('minPricePerPlace', minPrice);
    await prefs.setDouble('maxPricePerPlace', maxPrice);
    
    notifyListeners();
  }

  Future<void> setParticipants(int count, List<String> names) async {
    _participantCount = count > 0 ? count : 1;
    _participantNames = names;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('participantCount', _participantCount);
    await prefs.setString('participantNames', json.encode(_participantNames));
    
    notifyListeners();
  }

  void addPlaceToPlan(Map<String, dynamic> place) {
    _selectedPlaces.add(place);
    _usedBudget += (place['price'] as num).toDouble();
    _saveBudget();
    notifyListeners();
  }

  void removePlaceFromPlan(int index) {
    if (index < _selectedPlaces.length) {
      _usedBudget -= (_selectedPlaces[index]['price'] as num).toDouble();
      _selectedPlaces.removeAt(index);
      _saveBudget();
      notifyListeners();
    }
  }

  void clearPlan() {
    _selectedPlaces.clear();
    _usedBudget = 0;
    _saveBudget();
    notifyListeners();
  }

  Future<void> _saveBudget() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('usedBudget', _usedBudget);
  }

  bool canAffordPlace(double price) {
    return (_usedBudget + price) <= _totalBudget;
  }

  bool isWithinPriceRange(double price) {
    return price >= _minPricePerPlace && price <= _maxPricePerPlace;
  }
}
