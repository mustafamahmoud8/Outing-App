class Brand {
  final String id;
  final String name;
  final String category;
  final String logo;
  final List<Branch> branches;
  final List<MenuCategory> menuCategories;

  Brand({
    required this.id,
    required this.name,
    required this.category,
    required this.logo,
    required this.branches,
    List<MenuCategory>? menuCategories,
  }) : menuCategories = menuCategories ?? [];

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      logo: json['logo'],
      branches: (json['branches'] as List).map((b) => Branch.fromJson(b)).toList(),
      menuCategories: json['menuCategories'] != null
          ? (json['menuCategories'] as List).map((c) => MenuCategory.fromJson(c)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'logo': logo,
      'branches': branches.map((b) => b.toJson()).toList(),
      'menuCategories': menuCategories.map((c) => c.toJson()).toList(),
    };
  }
}

class Branch {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final List<MenuItem> menu;

  Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.menu,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      menu: (json['menu'] as List).map((m) => MenuItem.fromJson(m)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'menu': menu.map((m) => m.toJson()).toList(),
    };
  }
}

class MenuCategory {
  final String id;
  final String name;
  final String icon;
  final List<MenuItem> items;

  MenuCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.items,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      items: (json['items'] as List).map((i) => MenuItem.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? image;
  final String category;
  final List<String> ingredients;
  final List<ItemSize> sizes;
  final bool isPopular;
  final bool isNew;
  final int? calories;

  MenuItem({
    String? id,
    required this.name,
    required this.description,
    required this.price,
    this.image,
    this.category = 'General',
    List<String>? ingredients,
    List<ItemSize>? sizes,
    this.isPopular = false,
    this.isNew = false,
    this.calories,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        ingredients = ingredients ?? [],
        sizes = sizes ?? [];

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
      category: json['category'] ?? 'General',
      ingredients: json['ingredients'] != null ? List<String>.from(json['ingredients']) : [],
      sizes: json['sizes'] != null
          ? (json['sizes'] as List).map((s) => ItemSize.fromJson(s)).toList()
          : [],
      isPopular: json['isPopular'] ?? false,
      isNew: json['isNew'] ?? false,
      calories: json['calories'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'ingredients': ingredients,
      'sizes': sizes.map((s) => s.toJson()).toList(),
      'isPopular': isPopular,
      'isNew': isNew,
      'calories': calories,
    };
  }
}

class ItemSize {
  final String name;
  final double price;
  final String? description;

  ItemSize({
    required this.name,
    required this.price,
    this.description,
  });

  factory ItemSize.fromJson(Map<String, dynamic> json) {
    return ItemSize(
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
    };
  }
}
