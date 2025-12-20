import 'package:outing/models/brand_model.dart';

// Egyptian Restaurants Expansion Data
class EgyptianRestaurantsData {
  static List<Brand> getEgyptianRestaurants() {
    return [
      // Cook Door
      Brand(
        id: '400',
        name: 'Cook Door',
        category: 'Restaurants',
        logo: '🍽️',
        menuCategories: [
          MenuCategory(
            id: 'main_dishes',
            name: 'Main Dishes',
            icon: '🍛',
            items: [
              MenuItem(
                name: 'Koshary',
                description: 'Egyptian koshary',
                price: 35,
                category: 'Main Dishes',
                ingredients: ['Rice', 'Lentils', 'Pasta', 'Tomato Sauce', 'Fried Onions'],
                calories: 450,
                isPopular: true,
              ),
              MenuItem(
                name: 'Molokhia',
                description: 'Traditional molokhia',
                price: 50,
                category: 'Main Dishes',
                ingredients: ['Molokhia', 'Chicken', 'Rice'],
                calories: 380,
              ),
              MenuItem(
                name: 'Mahshi',
                description: 'Stuffed vegetables',
                price: 55,
                category: 'Main Dishes',
                ingredients: ['Zucchini', 'Peppers', 'Rice', 'Meat'],
                calories: 420,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '400-1', name: 'Cook Door - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.6, menu: []),
          Branch(id: '400-2', name: 'Cook Door - Heliopolis', address: 'Korba', latitude: 30.0875, longitude: 31.3241, rating: 4.5, menu: []),
          Branch(id: '400-3', name: 'Cook Door - Maadi', address: 'Road 9', latitude: 29.9602, longitude: 31.2569, rating: 4.7, menu: []),
          Branch(id: '400-4', name: 'Cook Door - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.6, menu: []),
          Branch(id: '400-5', name: 'Cook Door - Mohandiseen', address: 'Gameat El Dowal', latitude: 30.0594, longitude: 31.2000, rating: 4.5, menu: []),
        ],
      ),

      // Zooba
      Brand(
        id: '401',
        name: 'Zooba',
        category: 'Restaurants',
        logo: '🥙',
        menuCategories: [
          MenuCategory(
            id: 'street_food',
            name: 'Street Food',
            icon: '🌯',
            items: [
              MenuItem(
                name: 'Hawawshi',
                description: 'Stuffed pita with meat',
                price: 45,
                category: 'Street Food',
                ingredients: ['Pita', 'Minced Meat', 'Spices'],
                calories: 420,
                isPopular: true,
              ),
              MenuItem(
                name: 'Falafel Sandwich',
                description: 'Classic falafel',
                price: 25,
                category: 'Street Food',
                ingredients: ['Falafel', 'Tahina', 'Vegetables', 'Bread'],
                calories: 350,
              ),
              MenuItem(
                name: 'Feteer',
                description: 'Egyptian pastry',
                price: 40,
                category: 'Street Food',
                ingredients: ['Dough', 'Cheese', 'Honey'],
                calories: 480,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '401-1', name: 'Zooba - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.7, menu: []),
          Branch(id: '401-2', name: 'Zooba - Maadi', address: 'Road 9', latitude: 29.9602, longitude: 31.2569, rating: 4.6, menu: []),
          Branch(id: '401-3', name: 'Zooba - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.7, menu: []),
          Branch(id: '401-4', name: 'Zooba - Sheikh Zayed', address: 'Arkan Plaza', latitude: 30.0272, longitude: 30.9700, rating: 4.6, menu: []),
        ],
      ),
    ];
  }
}
