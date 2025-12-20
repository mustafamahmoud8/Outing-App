import 'package:outing/models/brand_model.dart';

// Additional Popular Brands
class AdditionalBrandsData {
  static List<Brand> getAdditionalFastFood() {
    return [
      // Burger King
      Brand(
        id: '700',
        name: 'Burger King',
        category: 'Restaurants',
        logo: '👑',
        menuCategories: [
          MenuCategory(
            id: 'burgers',
            name: 'Burgers',
            icon: '🍔',
            items: [
              MenuItem(
                name: 'Whopper',
                description: 'Flame-grilled beef burger',
                price: 90,
                category: 'Burgers',
                ingredients: ['Beef Patty', 'Lettuce', 'Tomato', 'Pickles', 'Onions', 'Mayo'],
                calories: 670,
                isPopular: true,
              ),
              MenuItem(
                name: 'Double Whopper',
                description: 'Two flame-grilled patties',
                price: 120,
                category: 'Burgers',
                ingredients: ['2 Beef Patties', 'Cheese', 'Lettuce', 'Tomato'],
                calories: 900,
                isPopular: true,
              ),
              MenuItem(
                name: 'Chicken Royale',
                description: 'Crispy chicken burger',
                price: 75,
                category: 'Burgers',
                ingredients: ['Chicken', 'Lettuce', 'Mayo'],
                calories: 550,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '700-1', name: 'Burger King - City Stars', address: 'City Stars Mall', latitude: 30.0727, longitude: 31.3474, rating: 4.2, menu: []),
          Branch(id: '700-2', name: 'Burger King - Mall of Arabia', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.1, menu: []),
          Branch(id: '700-3', name: 'Burger King - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.3, menu: []),
          Branch(id: '700-4', name: 'Burger King - Maadi', address: 'Maadi City Center', latitude: 29.9602, longitude: 31.2569, rating: 4.2, menu: []),
          Branch(id: '700-5', name: 'Burger King - Heliopolis', address: 'Korba', latitude: 30.0875, longitude: 31.3241, rating: 4.1, menu: []),
          Branch(id: '700-6', name: 'Burger King - Mohandiseen', address: 'Gameat El Dowal', latitude: 30.0594, longitude: 31.2000, rating: 4.0, menu: []),
          Branch(id: '700-7', name: 'Burger King - Sheikh Zayed', address: 'Arkan Plaza', latitude: 30.0272, longitude: 30.9700, rating: 4.3, menu: []),
          Branch(id: '700-8', name: 'Burger King - Nasr City', address: 'Abbas El Akkad', latitude: 30.0626, longitude: 31.3474, rating: 4.1, menu: []),
        ],
      ),

      // Papa John's
      Brand(
        id: '701',
        name: 'Papa John\'s',
        category: 'Restaurants',
        logo: '🍕',
        menuCategories: [
          MenuCategory(
            id: 'pizzas',
            name: 'Pizzas',
            icon: '🍕',
            items: [
              MenuItem(
                name: 'The Works',
                description: 'Loaded with everything',
                price: 160,
                category: 'Pizzas',
                ingredients: ['Pepperoni', 'Sausage', 'Mushrooms', 'Peppers', 'Onions'],
                calories: 310,
                isPopular: true,
              ),
              MenuItem(
                name: 'BBQ Chicken',
                description: 'BBQ sauce and chicken',
                price: 145,
                category: 'Pizzas',
                ingredients: ['Chicken', 'BBQ Sauce', 'Onions', 'Cheese'],
                calories: 280,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '701-1', name: 'Papa John\'s - Heliopolis', address: 'Korba', latitude: 30.0875, longitude: 31.3241, rating: 4.3, menu: []),
          Branch(id: '701-2', name: 'Papa John\'s - Maadi', address: 'Road 9', latitude: 29.9602, longitude: 31.2569, rating: 4.4, menu: []),
          Branch(id: '701-3', name: 'Papa John\'s - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.3, menu: []),
          Branch(id: '701-4', name: 'Papa John\'s - Mohandiseen', address: 'Gameat El Dowal', latitude: 30.0594, longitude: 31.2000, rating: 4.2, menu: []),
          Branch(id: '701-5', name: 'Papa John\'s - Sheikh Zayed', address: 'Arkan Plaza', latitude: 30.0272, longitude: 30.9700, rating: 4.4, menu: []),
        ],
      ),

      // Subway
      Brand(
        id: '702',
        name: 'Subway',
        category: 'Restaurants',
        logo: '🥖',
        menuCategories: [
          MenuCategory(
            id: 'subs',
            name: 'Subs',
            icon: '🥖',
            items: [
              MenuItem(
                name: 'Italian BMT',
                description: 'Classic Italian sub',
                price: 65,
                category: 'Subs',
                ingredients: ['Salami', 'Pepperoni', 'Ham', 'Cheese', 'Vegetables'],
                calories: 410,
                isPopular: true,
              ),
              MenuItem(
                name: 'Chicken Teriyaki',
                description: 'Teriyaki chicken sub',
                price: 70,
                category: 'Subs',
                ingredients: ['Chicken', 'Teriyaki Sauce', 'Vegetables'],
                calories: 380,
                isPopular: true,
              ),
              MenuItem(
                name: 'Veggie Delite',
                description: 'Fresh vegetables',
                price: 50,
                category: 'Subs',
                ingredients: ['Lettuce', 'Tomato', 'Cucumber', 'Peppers', 'Onions'],
                calories: 230,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '702-1', name: 'Subway - City Stars', address: 'City Stars Mall', latitude: 30.0727, longitude: 31.3474, rating: 4.1, menu: []),
          Branch(id: '702-2', name: 'Subway - Mall of Arabia', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.0, menu: []),
          Branch(id: '702-3', name: 'Subway - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.2, menu: []),
          Branch(id: '702-4', name: 'Subway - Maadi', address: 'Road 9', latitude: 29.9602, longitude: 31.2569, rating: 4.1, menu: []),
          Branch(id: '702-5', name: 'Subway - Heliopolis', address: 'Korba', latitude: 30.0875, longitude: 31.3241, rating: 4.0, menu: []),
        ],
      ),

      // Popeyes
      Brand(
        id: '703',
        name: 'Popeyes',
        category: 'Restaurants',
        logo: '🍗',
        menuCategories: [
          MenuCategory(
            id: 'chicken',
            name: 'Chicken',
            icon: '🍗',
            items: [
              MenuItem(
                name: 'Chicken Sandwich',
                description: 'Crispy chicken sandwich',
                price: 85,
                category: 'Chicken',
                ingredients: ['Chicken', 'Pickles', 'Mayo', 'Bun'],
                calories: 700,
                isPopular: true,
              ),
              MenuItem(
                name: 'Chicken Tenders',
                description: 'Crispy tenders',
                price: 75,
                category: 'Chicken',
                ingredients: ['Chicken Breast', 'Breading'],
                calories: 445,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '703-1', name: 'Popeyes - City Stars', address: 'City Stars Mall', latitude: 30.0727, longitude: 31.3474, rating: 4.3, menu: []),
          Branch(id: '703-2', name: 'Popeyes - Mall of Arabia', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.2, menu: []),
          Branch(id: '703-3', name: 'Popeyes - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.4, menu: []),
        ],
      ),
    ];
  }

  static List<Brand> getAdditionalEgyptian() {
    return [
      // Abo Shakra
      Brand(
        id: '800',
        name: 'Abo Shakra',
        category: 'Restaurants',
        logo: '🍖',
        menuCategories: [
          MenuCategory(
            id: 'grills',
            name: 'Grills',
            icon: '🍖',
            items: [
              MenuItem(
                name: 'Mixed Grill',
                description: 'Kofta, kebab, and chicken',
                price: 180,
                category: 'Grills',
                ingredients: ['Kofta', 'Kebab', 'Chicken', 'Rice'],
                calories: 850,
                isPopular: true,
              ),
              MenuItem(
                name: 'Kofta',
                description: 'Grilled kofta',
                price: 120,
                category: 'Grills',
                ingredients: ['Minced Meat', 'Spices'],
                calories: 520,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '800-1', name: 'Abo Shakra - Downtown', address: 'Qasr El Nil', latitude: 30.0444, longitude: 31.2357, rating: 4.6, menu: []),
          Branch(id: '800-2', name: 'Abo Shakra - Heliopolis', address: 'Korba', latitude: 30.0875, longitude: 31.3241, rating: 4.5, menu: []),
          Branch(id: '800-3', name: 'Abo Shakra - Mohandiseen', address: 'Gameat El Dowal', latitude: 30.0594, longitude: 31.2000, rating: 4.6, menu: []),
        ],
      ),

      // Kazouza
      Brand(
        id: '801',
        name: 'Kazouza',
        category: 'Restaurants',
        logo: '🥤',
        menuCategories: [
          MenuCategory(
            id: 'egyptian',
            name: 'Egyptian Food',
            icon: '🍽️',
            items: [
              MenuItem(
                name: 'Ful & Falafel',
                description: 'Traditional Egyptian breakfast',
                price: 35,
                category: 'Egyptian',
                ingredients: ['Fava Beans', 'Falafel', 'Tahina', 'Bread'],
                calories: 380,
                isPopular: true,
              ),
              MenuItem(
                name: 'Koshari',
                description: 'Egyptian koshari',
                price: 30,
                category: 'Egyptian',
                ingredients: ['Rice', 'Lentils', 'Pasta', 'Sauce'],
                calories: 420,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '801-1', name: 'Kazouza - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.4, menu: []),
          Branch(id: '801-2', name: 'Kazouza - Maadi', address: 'Road 9', latitude: 29.9602, longitude: 31.2569, rating: 4.5, menu: []),
        ],
      ),
    ];
  }

  static List<Brand> getAdditionalCafes() {
    return [
      // Cafe Greco
      Brand(
        id: '900',
        name: 'Cafe Greco',
        category: 'Cafes',
        logo: '☕',
        menuCategories: [
          MenuCategory(
            id: 'coffee',
            name: 'Coffee',
            icon: '☕',
            items: [
              MenuItem(
                name: 'Greek Coffee',
                description: 'Traditional Greek coffee',
                price: 40,
                category: 'Coffee',
                ingredients: ['Coffee', 'Sugar'],
                calories: 20,
                isPopular: true,
              ),
              MenuItem(
                name: 'Freddo Espresso',
                description: 'Iced espresso',
                price: 50,
                category: 'Coffee',
                ingredients: ['Espresso', 'Ice'],
                calories: 10,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '900-1', name: 'Cafe Greco - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.6, menu: []),
          Branch(id: '900-2', name: 'Cafe Greco - Heliopolis', address: 'Korba', latitude: 30.0875, longitude: 31.3241, rating: 4.5, menu: []),
          Branch(id: '900-3', name: 'Cafe Greco - Maadi', address: 'Road 9', latitude: 29.9602, longitude: 31.2569, rating: 4.6, menu: []),
        ],
      ),
    ];
  }
}
