import 'package:flutter/material.dart';
import 'package:outing/models/brand_model.dart';

class PlanItem {
  final String id;
  final MenuItem menuItem;
  final Brand brand;
  final Branch branch;
  final ItemSize? selectedSize;
  final int quantity;
  final DateTime addedAt;

  PlanItem({
    String? id,
    required this.menuItem,
    required this.brand,
    required this.branch,
    this.selectedSize,
    required this.quantity,
    DateTime? addedAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        addedAt = addedAt ?? DateTime.now();

  double get totalPrice {
    final price = selectedSize?.price ?? menuItem.price;
    return price * quantity;
  }

  String get displayName => menuItem.name;
  String get brandName => brand.name;
  String get branchName => branch.name;
  String get sizeDisplay => selectedSize?.name ?? 'Regular';
  String? get imageUrl => menuItem.image;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menuItemId': menuItem.id,
      'menuItemName': menuItem.name,
      'brandId': brand.id,
      'brandName': brand.name,
      'branchId': branch.id,
      'branchName': branch.name,
      'selectedSize': selectedSize?.toJson(),
      'quantity': quantity,
      'totalPrice': totalPrice,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}
