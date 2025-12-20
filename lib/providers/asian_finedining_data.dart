import 'package:outing/models/brand_model.dart';

// Asian Cuisine & Fine Dining Expansion
class AsianAndFineDiningData {
  static List<Brand> getAsianCuisine() {
    return [
      // Wok & Walk
      Brand(
        id: '500',
        name: 'Wok & Walk',
        category: 'Asian',
        logo: '🥡',
        menuCategories: [
          MenuCategory(
            id: 'noodles',
            name: 'Noodles',
            icon: '🍜',
            items: [
              MenuItem(
                name: 'Pad Thai',
                description: 'Thai stir-fried noodles',
                price: 85,
                category: 'Noodles',
                ingredients: ['Rice Noodles', 'Shrimp', 'Peanuts', 'Tamarind'],
                calories: 450,
                isPopular: true,
              ),
              MenuItem(
                name: 'Singapore Noodles',
                description: 'Curry noodles',
                price: 80,
                category: 'Noodles',
                ingredients: ['Noodles', 'Curry', 'Vegetables', 'Shrimp'],
                calories: 420,
              ),
            ],
          ),
          MenuCategory(
            id: 'rice',
            name: 'Rice',
            icon: '🍚',
            items: [
              MenuItem(
                name: 'Chicken Fried Rice',
                description: 'Classic fried rice',
                price: 70,
                category: 'Rice',
                ingredients: ['Rice', 'Chicken', 'Vegetables', 'Soy Sauce'],
                calories: 380,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '500-1', name: 'Wok & Walk - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.5, menu: []),
          Branch(id: '500-2', name: 'Wok & Walk - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.6, menu: []),
          Branch(id: '500-3', name: 'Wok & Walk - Maadi', address: 'Road 9', latitude: 29.9602, longitude: 31.2569, rating: 4.5, menu: []),
        ],
      ),

      // Mori Sushi
      Brand(
        id: '501',
        name: 'Mori Sushi',
        category: 'Asian',
        logo: '🍣',
        menuCategories: [
          MenuCategory(
            id: 'sushi',
            name: 'Sushi',
            icon: '🍣',
            items: [
              MenuItem(
                name: 'California Roll',
                description: 'Crab, avocado, cucumber',
                price: 95,
                category: 'Sushi',
                ingredients: ['Crab', 'Avocado', 'Cucumber', 'Rice', 'Nori'],
                calories: 320,
                isPopular: true,
              ),
              MenuItem(
                name: 'Salmon Nigiri',
                description: 'Fresh salmon on rice',
                price: 110,
                category: 'Sushi',
                ingredients: ['Salmon', 'Rice'],
                calories: 280,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '501-1', name: 'Mori Sushi - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.7, menu: []),
          Branch(id: '501-2', name: 'Mori Sushi - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.6, menu: []),
        ],
      ),
    ];
  }

  static List<Brand> getFineDining() {
    return [
      // Chili's
      Brand(
        id: '600',
        name: 'Chili\'s',
        category: 'Fine Dining',
        logo: '🌶️',
        menuCategories: [
          MenuCategory(
            id: 'appetizers',
            name: 'Appetizers',
            icon: '🥗',
            items: [
              MenuItem(
                name: 'Loaded Boneless Wings',
                description: 'Crispy wings with sauce',
                price: 120,
                category: 'Appetizers',
                ingredients: ['Chicken', 'Buffalo Sauce', 'Ranch'],
                calories: 580,
                isPopular: true,
              ),
            ],
          ),
          MenuCategory(
            id: 'burgers',
            name: 'Burgers',
            icon: '🍔',
            items: [
              MenuItem(
                name: 'Oldtimer Burger',
                description: 'Classic chili\'s burger',
                price: 150,
                category: 'Burgers',
                ingredients: ['Beef', 'Cheese', 'Lettuce', 'Tomato'],
                calories: 720,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '600-1', name: 'Chili\'s - City Stars', address: 'City Stars Mall', latitude: 30.0727, longitude: 31.3474, rating: 4.4, menu: []),
          Branch(id: '600-2', name: 'Chili\'s - Mall of Arabia', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.3, menu: []),
          Branch(id: '600-3', name: 'Chili\'s - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.5, menu: []),
        ],
      ),

      // TGI Friday's
      Brand(
        id: '601',
        name: 'TGI Friday\'s',
        category: 'Fine Dining',
        logo: '🎉',
        menuCategories: [
          MenuCategory(
            id: 'appetizers',
            name: 'Appetizers',
            icon: '🍤',
            items: [
              MenuItem(
                name: 'Loaded Potato Skins',
                description: 'Crispy potato skins',
                price: 110,
                category: 'Appetizers',
                ingredients: ['Potato', 'Cheese', 'Bacon', 'Sour Cream'],
                calories: 520,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '601-1', name: 'TGI Friday\'s - City Stars', address: 'City Stars Mall', latitude: 30.0727, longitude: 31.3474, rating: 4.3, menu: []),
          Branch(id: '601-2', name: 'TGI Friday\'s - Mall of Arabia', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.2, menu: []),
        ],
      ),
    ];
  }
}
