import 'package:outing/models/brand_model.dart';

// Fast Food Expansion Data
class FastFoodExpansionData {
  static List<Brand> getFastFoodBrands() {
    return [
      // Hardee's
      Brand(
        id: '200',
        name: 'Hardee\'s',
        category: 'Restaurants',
        logo: '🍔',
        menuCategories: [
          MenuCategory(
            id: 'burgers',
            name: 'Burgers',
            icon: '🍔',
            items: [
              MenuItem(
                name: 'Thickburger',
                description: '1/3 lb charbroiled beef',
                price: 95,
                category: 'Burgers',
                ingredients: ['Beef Patty', 'Lettuce', 'Tomato', 'Onion', 'Pickles'],
                calories: 680,
                isPopular: true,
              ),
              MenuItem(
                name: 'Famous Star',
                description: 'Classic charbroiled burger',
                price: 85,
                category: 'Burgers',
                ingredients: ['Beef', 'Lettuce', 'Tomato', 'Special Sauce'],
                calories: 590,
              ),
              MenuItem(
                name: 'Mushroom Swiss',
                description: 'Burger with mushrooms and swiss cheese',
                price: 100,
                category: 'Burgers',
                ingredients: ['Beef', 'Mushrooms', 'Swiss Cheese', 'Mayo'],
                calories: 720,
                isPopular: true,
              ),
            ],
          ),
          MenuCategory(
            id: 'chicken',
            name: 'Chicken',
            icon: '🍗',
            items: [
              MenuItem(
                name: 'Chicken Tenders',
                description: 'Crispy chicken strips',
                price: 70,
                category: 'Chicken',
                ingredients: ['Chicken Breast', 'Breading'],
                calories: 450,
                sizes: [
                  ItemSize(name: '3 Pieces', price: 70),
                  ItemSize(name: '5 Pieces', price: 95),
                ],
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '200-1', name: 'Hardee\'s - City Stars', address: 'City Stars Mall', latitude: 30.0727, longitude: 31.3474, rating: 4.3, menu: []),
          Branch(id: '200-2', name: 'Hardee\'s - Mall of Arabia', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.2, menu: []),
          Branch(id: '200-3', name: 'Hardee\'s - Maadi', address: 'Maadi City Center', latitude: 29.9602, longitude: 31.2569, rating: 4.3, menu: []),
          Branch(id: '200-4', name: 'Hardee\'s - Heliopolis', address: 'Korba', latitude: 30.0875, longitude: 31.3241, rating: 4.2, menu: []),
          Branch(id: '200-5', name: 'Hardee\'s - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.4, menu: []),
          Branch(id: '200-6', name: 'Hardee\'s - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.3, menu: []),
          Branch(id: '200-7', name: 'Hardee\'s - Mohandiseen', address: 'Gameat El Dowal', latitude: 30.0594, longitude: 31.2000, rating: 4.2, menu: []),
          Branch(id: '200-8', name: 'Hardee\'s - Nasr City', address: 'Abbas El Akkad', latitude: 30.0626, longitude: 31.3474, rating: 4.3, menu: []),
          Branch(id: '200-9', name: 'Hardee\'s - 6th October', address: 'Dandy Mall', latitude: 29.9765, longitude: 30.9283, rating: 4.2, menu: []),
          Branch(id: '200-10', name: 'Hardee\'s - Sheikh Zayed', address: 'Arkan Plaza', latitude: 30.0272, longitude: 30.9700, rating: 4.4, menu: []),
        ],
      ),

      // Buffalo Burger
      Brand(
        id: '201',
        name: 'Buffalo Burger',
        category: 'Restaurants',
        logo: '🦬',
        menuCategories: [
          MenuCategory(
            id: 'burgers',
            name: 'Burgers',
            icon: '🍔',
            items: [
              MenuItem(
                name: 'Shiitake Burger',
                description: 'Signature shiitake mushroom burger',
                price: 90,
                category: 'Burgers',
                ingredients: ['Beef', 'Shiitake Mushrooms', 'Special Sauce', 'Cheese'],
                calories: 650,
                isPopular: true,
              ),
              MenuItem(
                name: 'Old School',
                description: 'Classic buffalo burger',
                price: 80,
                category: 'Burgers',
                ingredients: ['Beef', 'Lettuce', 'Tomato', 'Pickles', 'Buffalo Sauce'],
                calories: 580,
                isPopular: true,
              ),
              MenuItem(
                name: 'Blue Burger',
                description: 'Blue cheese burger',
                price: 95,
                category: 'Burgers',
                ingredients: ['Beef', 'Blue Cheese', 'Caramelized Onions'],
                calories: 690,
              ),
            ],
          ),
          MenuCategory(
            id: 'sides',
            name: 'Sides',
            icon: '🍟',
            items: [
              MenuItem(
                name: 'Buffalo Fries',
                description: 'Seasoned fries',
                price: 30,
                category: 'Sides',
                ingredients: ['Potatoes', 'Buffalo Seasoning'],
                calories: 350,
              ),
              MenuItem(
                name: 'Onion Rings',
                description: 'Crispy onion rings',
                price: 35,
                category: 'Sides',
                ingredients: ['Onions', 'Breading'],
                calories: 380,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '201-1', name: 'Buffalo Burger - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.5, menu: []),
          Branch(id: '201-2', name: 'Buffalo Burger - Heliopolis', address: 'Korba', latitude: 30.0875, longitude: 31.3241, rating: 4.4, menu: []),
          Branch(id: '201-3', name: 'Buffalo Burger - Maadi', address: 'Road 9', latitude: 29.9602, longitude: 31.2569, rating: 4.6, menu: []),
          Branch(id: '201-4', name: 'Buffalo Burger - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.5, menu: []),
          Branch(id: '201-5', name: 'Buffalo Burger - Mohandiseen', address: 'Gameat El Dowal', latitude: 30.0594, longitude: 31.2000, rating: 4.4, menu: []),
          Branch(id: '201-6', name: 'Buffalo Burger - Nasr City', address: 'City Stars', latitude: 30.0727, longitude: 31.3474, rating: 4.5, menu: []),
          Branch(id: '201-7', name: 'Buffalo Burger - 6th October', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.4, menu: []),
          Branch(id: '201-8', name: 'Buffalo Burger - Sheikh Zayed', address: 'Arkan Plaza', latitude: 30.0272, longitude: 30.9700, rating: 4.6, menu: []),
        ],
      ),

      // Pizza Hut
      Brand(
        id: '202',
        name: 'Pizza Hut',
        category: 'Restaurants',
        logo: '🍕',
        menuCategories: [
          MenuCategory(
            id: 'pizzas',
            name: 'Pizzas',
            icon: '🍕',
            items: [
              MenuItem(
                name: 'Super Supreme',
                description: 'Loaded with toppings',
                price: 150,
                category: 'Pizzas',
                ingredients: ['Beef', 'Pepperoni', 'Mushrooms', 'Peppers', 'Onions', 'Olives'],
                calories: 280,
                isPopular: true,
                sizes: [
                  ItemSize(name: 'Small', price: 100),
                  ItemSize(name: 'Medium', price: 150),
                  ItemSize(name: 'Large', price: 200),
                ],
              ),
              MenuItem(
                name: 'Pepperoni',
                description: 'Classic pepperoni pizza',
                price: 120,
                category: 'Pizzas',
                ingredients: ['Pepperoni', 'Cheese', 'Tomato Sauce'],
                calories: 250,
                isPopular: true,
              ),
              MenuItem(
                name: 'Margherita',
                description: 'Classic cheese pizza',
                price: 90,
                category: 'Pizzas',
                ingredients: ['Cheese', 'Tomato Sauce', 'Basil'],
                calories: 220,
              ),
            ],
          ),
          MenuCategory(
            id: 'sides',
            name: 'Sides',
            icon: '🥖',
            items: [
              MenuItem(
                name: 'Garlic Bread',
                description: 'Cheesy garlic bread',
                price: 40,
                category: 'Sides',
                ingredients: ['Bread', 'Garlic', 'Cheese'],
                calories: 320,
              ),
              MenuItem(
                name: 'Chicken Wings',
                description: 'Spicy wings',
                price: 60,
                category: 'Sides',
                ingredients: ['Chicken Wings', 'Spicy Sauce'],
                calories: 450,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '202-1', name: 'Pizza Hut - City Stars', address: 'City Stars Mall', latitude: 30.0727, longitude: 31.3474, rating: 4.2, menu: []),
          Branch(id: '202-2', name: 'Pizza Hut - Mall of Arabia', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.1, menu: []),
          Branch(id: '202-3', name: 'Pizza Hut - Maadi', address: 'Maadi City Center', latitude: 29.9602, longitude: 31.2569, rating: 4.3, menu: []),
          Branch(id: '202-4', name: 'Pizza Hut - Heliopolis', address: 'Korba', latitude: 30.0875, longitude: 31.3241, rating: 4.2, menu: []),
          Branch(id: '202-5', name: 'Pizza Hut - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.3, menu: []),
          Branch(id: '202-6', name: 'Pizza Hut - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.2, menu: []),
          Branch(id: '202-7', name: 'Pizza Hut - Mohandiseen', address: 'Gameat El Dowal', latitude: 30.0594, longitude: 31.2000, rating: 4.1, menu: []),
          Branch(id: '202-8', name: 'Pizza Hut - Nasr City', address: 'Abbas El Akkad', latitude: 30.0626, longitude: 31.3474, rating: 4.2, menu: []),
          Branch(id: '202-9', name: 'Pizza Hut - Dokki', address: 'Mesaha Square', latitude: 30.0444, longitude: 31.2000, rating: 4.1, menu: []),
          Branch(id: '202-10', name: 'Pizza Hut - Sheikh Zayed', address: 'Arkan Plaza', latitude: 30.0272, longitude: 30.9700, rating: 4.3, menu: []),
        ],
      ),

      // Domino's Pizza
      Brand(
        id: '203',
        name: 'Domino\'s Pizza',
        category: 'Restaurants',
        logo: '🍕',
        menuCategories: [
          MenuCategory(
            id: 'pizzas',
            name: 'Pizzas',
            icon: '🍕',
            items: [
              MenuItem(
                name: 'Extravaganza',
                description: 'Loaded pizza',
                price: 160,
                category: 'Pizzas',
                ingredients: ['Beef', 'Pepperoni', 'Mushrooms', 'Peppers', 'Onions'],
                calories: 300,
                isPopular: true,
              ),
              MenuItem(
                name: 'Chicken Ranch',
                description: 'Chicken with ranch sauce',
                price: 140,
                category: 'Pizzas',
                ingredients: ['Chicken', 'Ranch Sauce', 'Cheese'],
                calories: 270,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '203-1', name: 'Domino\'s - Heliopolis', address: 'Korba', latitude: 30.0875, longitude: 31.3241, rating: 4.3, menu: []),
          Branch(id: '203-2', name: 'Domino\'s - Maadi', address: 'Road 9', latitude: 29.9602, longitude: 31.2569, rating: 4.4, menu: []),
          Branch(id: '203-3', name: 'Domino\'s - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.3, menu: []),
          Branch(id: '203-4', name: 'Domino\'s - Mohandiseen', address: 'Gameat El Dowal', latitude: 30.0594, longitude: 31.2000, rating: 4.2, menu: []),
          Branch(id: '203-5', name: 'Domino\'s - Nasr City', address: 'City Stars', latitude: 30.0727, longitude: 31.3474, rating: 4.4, menu: []),
          Branch(id: '203-6', name: 'Domino\'s - 6th October', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.3, menu: []),
          Branch(id: '203-7', name: 'Domino\'s - Sheikh Zayed', address: 'Arkan Plaza', latitude: 30.0272, longitude: 30.9700, rating: 4.4, menu: []),
          Branch(id: '203-8', name: 'Domino\'s - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.3, menu: []),
        ],
      ),
    ];
  }
}
