import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:outing/models/plan_item.dart';
import 'package:outing/models/brand_model.dart';

class PlanProvider with ChangeNotifier {
  List<PlanItem> _planItems = [];
  bool _isLoading = false;

  List<PlanItem> get planItems => _planItems;
  bool get isLoading => _isLoading;
  int get itemCount => _planItems.length;
  
  double get totalBudget {
    return _planItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  PlanProvider() {
    _loadPlan();
  }

  // Load plan from SharedPreferences
  Future<void> _loadPlan() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final planData = prefs.getString('userPlan');
      
      if (planData != null && planData.isNotEmpty) {
        final List<dynamic> decoded = json.decode(planData);
        _planItems = decoded.map((item) {
          // Reconstruct basic plan item from saved data
          // Note: We save essential data to reconstruct the item
          return PlanItem(
            id: item['id'],
            menuItem: MenuItem(
              id: item['menuItemId'] ?? '',
              name: item['menuItemName'] ?? '',
              description: '',
              price: (item['totalPrice'] ?? 0.0) / (item['quantity'] ?? 1),
              category: '',
              ingredients: [],
              calories: 0,
            ),
            brand: Brand(
              id: item['brandId'] ?? '',
              name: item['brandName'] ?? '',
              category: '',
              logo: '',
              menuCategories: [],
              branches: [],
            ),
            branch: Branch(
              id: item['branchId'] ?? '',
              name: item['branchName'] ?? '',
              address: '',
              latitude: 0,
              longitude: 0,
              rating: 0,
              menu: [],
            ),
            selectedSize: item['selectedSize'] != null 
                ? ItemSize(
                    name: item['selectedSize']['name'] ?? 'Regular',
                    price: (item['selectedSize']['price'] ?? 0.0).toDouble(),
                  )
                : null,
            quantity: item['quantity'] ?? 1,
            addedAt: DateTime.parse(item['addedAt'] ?? DateTime.now().toIso8601String()),
          );
        }).toList();
      }
    } catch (e) {
      print('Error loading plan: $e');
      _planItems = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Save plan to SharedPreferences
  Future<void> _savePlan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final planData = json.encode(_planItems.map((item) => item.toJson()).toList());
      await prefs.setString('userPlan', planData);
    } catch (e) {
      print('Error saving plan: $e');
    }
  }

  // Add item to plan
  Future<void> addToPlan(
    MenuItem menuItem,
    Brand brand,
    Branch branch, {
    ItemSize? selectedSize,
    int quantity = 1,
  }) async {
    final planItem = PlanItem(
      menuItem: menuItem,
      brand: brand,
      branch: branch,
      selectedSize: selectedSize,
      quantity: quantity,
    );

    _planItems.add(planItem);
    await _savePlan();
    notifyListeners();
  }

  // Remove item from plan
  Future<void> removeFromPlan(String itemId) async {
    _planItems.removeWhere((item) => item.id == itemId);
    await _savePlan();
    notifyListeners();
  }

  // Update item quantity
  Future<void> updateQuantity(String itemId, int newQuantity) async {
    final index = _planItems.indexWhere((item) => item.id == itemId);
    if (index != -1 && newQuantity > 0) {
      final oldItem = _planItems[index];
      _planItems[index] = PlanItem(
        id: oldItem.id,
        menuItem: oldItem.menuItem,
        brand: oldItem.brand,
        branch: oldItem.branch,
        selectedSize: oldItem.selectedSize,
        quantity: newQuantity,
        addedAt: oldItem.addedAt,
      );
      await _savePlan();
      notifyListeners();
    }
  }

  // Clear all plan items
  Future<void> clearPlan() async {
    _planItems.clear();
    await _savePlan();
    notifyListeners();
  }

  // Get items by brand
  List<PlanItem> getItemsByBrand(String brandId) {
    return _planItems.where((item) => item.brand.id == brandId).toList();
  }

  // Check if item exists in plan
  bool hasItem(String menuItemId) {
    return _planItems.any((item) => item.menuItem.id == menuItemId);
  }
}
