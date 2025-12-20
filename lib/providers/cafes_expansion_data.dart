import 'package:outing/models/brand_model.dart';

// Cafes Expansion Data
class CafesExpansionData {
  static List<Brand> getCafeBrands() {
    return [
      // Cilantro
      Brand(
        id: '300',
        name: 'Cilantro',
        category: 'Cafes',
        logo: '☕',
        menuCategories: [
          MenuCategory(
            id: 'coffee',
            name: 'Coffee',
            icon: '☕',
            items: [
              MenuItem(
                name: 'Cappuccino',
                description: 'Classic cappuccino',
                price: 45,
                category: 'Coffee',
                ingredients: ['Espresso', 'Steamed Milk', 'Foam'],
                calories: 140,
                isPopular: true,
              ),
              MenuItem(
                name: 'Latte',
                description: 'Smooth latte',
                price: 50,
                category: 'Coffee',
                ingredients: ['Espresso', 'Steamed Milk'],
                calories: 190,
              ),
              MenuItem(
                name: 'Iced Coffee',
                description: 'Cold brew coffee',
                price: 55,
                category: 'Coffee',
                ingredients: ['Coffee', 'Ice', 'Milk'],
                calories: 120,
                isPopular: true,
              ),
            ],
          ),
          MenuCategory(
            id: 'food',
            name: 'Food',
            icon: '🥐',
            items: [
              MenuItem(
                name: 'Croissant',
                description: 'Butter croissant',
                price: 30,
                category: 'Food',
                ingredients: ['Butter', 'Flour'],
                calories: 270,
              ),
              MenuItem(
                name: 'Panini',
                description: 'Grilled sandwich',
                price: 60,
                category: 'Food',
                ingredients: ['Bread', 'Cheese', 'Vegetables'],
                calories: 420,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '300-1', name: 'Cilantro - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.6, menu: []),
          Branch(id: '300-2', name: 'Cilantro - Heliopolis', address: 'Korba', latitude: 30.0875, longitude: 31.3241, rating: 4.5, menu: []),
          Branch(id: '300-3', name: 'Cilantro - Maadi', address: 'Road 9', latitude: 29.9602, longitude: 31.2569, rating: 4.7, menu: []),
          Branch(id: '300-4', name: 'Cilantro - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.6, menu: []),
          Branch(id: '300-5', name: 'Cilantro - Mohandiseen', address: 'Gameat El Dowal', latitude: 30.0594, longitude: 31.2000, rating: 4.5, menu: []),
          Branch(id: '300-6', name: 'Cilantro - Nasr City', address: 'City Stars', latitude: 30.0727, longitude: 31.3474, rating: 4.6, menu: []),
          Branch(id: '300-7', name: 'Cilantro - 6th October', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.5, menu: []),
          Branch(id: '300-8', name: 'Cilantro - Sheikh Zayed', address: 'Arkan Plaza', latitude: 30.0272, longitude: 30.9700, rating: 4.7, menu: []),
          Branch(id: '300-9', name: 'Cilantro - Dokki', address: 'Mesaha Square', latitude: 30.0444, longitude: 31.2000, rating: 4.5, menu: []),
          Branch(id: '300-10', name: 'Cilantro - Downtown', address: 'Talaat Harb', latitude: 30.0444, longitude: 31.2357, rating: 4.6, menu: []),
        ],
      ),

      // Beano's
      Brand(
        id: '301',
        name: 'Beano\'s',
        category: 'Cafes',
        logo: '☕',
        menuCategories: [
          MenuCategory(
            id: 'coffee',
            name: 'Coffee',
            icon: '☕',
            items: [
              MenuItem(
                name: 'Espresso',
                description: 'Strong espresso',
                price: 35,
                category: 'Coffee',
                ingredients: ['Espresso Beans'],
                calories: 5,
              ),
              MenuItem(
                name: 'Americano',
                description: 'Espresso with water',
                price: 40,
                category: 'Coffee',
                ingredients: ['Espresso', 'Hot Water'],
                calories: 10,
              ),
              MenuItem(
                name: 'Mocha',
                description: 'Chocolate coffee',
                price: 55,
                category: 'Coffee',
                ingredients: ['Espresso', 'Chocolate', 'Milk'],
                calories: 290,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '301-1', name: 'Beano\'s - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.5, menu: []),
          Branch(id: '301-2', name: 'Beano\'s - Heliopolis', address: 'Korba', latitude: 30.0875, longitude: 31.3241, rating: 4.4, menu: []),
          Branch(id: '301-3', name: 'Beano\'s - Maadi', address: 'Road 9', latitude: 29.9602, longitude: 31.2569, rating: 4.6, menu: []),
          Branch(id: '301-4', name: 'Beano\'s - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.5, menu: []),
          Branch(id: '301-5', name: 'Beano\'s - Mohandiseen', address: 'Gameat El Dowal', latitude: 30.0594, longitude: 31.2000, rating: 4.4, menu: []),
          Branch(id: '301-6', name: 'Beano\'s - Nasr City', address: 'City Stars', latitude: 30.0727, longitude: 31.3474, rating: 4.5, menu: []),
        ],
      ),
    ];
  }
}
