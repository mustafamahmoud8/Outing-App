import 'package:outing/models/brand_model.dart';

// This file contains massive brand expansion data
// To be integrated into BrandsProvider

class BrandExpansionData {
  // Desserts & Sweets Brands
  static List<Brand> getDessertBrands() {
    return [
      // Balbaa - بلبن
      Brand(
        id: '100',
        name: 'Balbaa',
        category: 'Desserts',
        logo: '🍰',
        menuCategories: [
          MenuCategory(
            id: 'oriental_sweets',
            name: 'Oriental Sweets',
            icon: '🥮',
            items: [
              MenuItem(
                name: 'Kunafa Nabulsi',
                description: 'Traditional kunafa with cheese',
                price: 45,
                category: 'Oriental Sweets',
                ingredients: ['Kunafa Dough', 'Cheese', 'Sugar Syrup', 'Pistachios'],
                calories: 380,
                isPopular: true,
              ),
              MenuItem(
                name: 'Basbousa',
                description: 'Semolina cake with syrup',
                price: 35,
                category: 'Oriental Sweets',
                ingredients: ['Semolina', 'Sugar Syrup', 'Coconut', 'Almonds'],
                calories: 320,
                isPopular: true,
              ),
              MenuItem(
                name: 'Baklava',
                description: 'Layered pastry with nuts',
                price: 50,
                category: 'Oriental Sweets',
                ingredients: ['Phyllo Dough', 'Walnuts', 'Pistachios', 'Honey'],
                calories: 410,
              ),
              MenuItem(
                name: 'Qatayef',
                description: 'Stuffed pancakes',
                price: 40,
                category: 'Oriental Sweets',
                ingredients: ['Pancake', 'Nuts', 'Cream', 'Sugar Syrup'],
                calories: 290,
              ),
            ],
          ),
          MenuCategory(
            id: 'ice_cream',
            name: 'Ice Cream',
            icon: '🍦',
            items: [
              MenuItem(
                name: 'Vanilla Ice Cream',
                description: 'Classic vanilla',
                price: 25,
                category: 'Ice Cream',
                ingredients: ['Milk', 'Cream', 'Vanilla', 'Sugar'],
                calories: 210,
              ),
              MenuItem(
                name: 'Chocolate Ice Cream',
                description: 'Rich chocolate',
                price: 25,
                category: 'Ice Cream',
                ingredients: ['Milk', 'Cream', 'Chocolate', 'Sugar'],
                calories: 240,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '100-1', name: 'Balbaa - Heliopolis', address: 'Korba, Heliopolis', latitude: 30.0875, longitude: 31.3241, rating: 4.6, menu: []),
          Branch(id: '100-2', name: 'Balbaa - Nasr City', address: 'Abbas El Akkad', latitude: 30.0626, longitude: 31.3474, rating: 4.5, menu: []),
          Branch(id: '100-3', name: 'Balbaa - Maadi', address: 'Road 9, Maadi', latitude: 29.9602, longitude: 31.2569, rating: 4.7, menu: []),
          Branch(id: '100-4', name: 'Balbaa - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.6, menu: []),
          Branch(id: '100-5', name: 'Balbaa - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.5, menu: []),
        ],
      ),

      // El Abd - العبد
      Brand(
        id: '101',
        name: 'El Abd',
        category: 'Desserts',
        logo: '🧁',
        menuCategories: [
          MenuCategory(
            id: 'cakes',
            name: 'Cakes',
            icon: '🎂',
            items: [
              MenuItem(
                name: 'Chocolate Cake',
                description: 'Rich chocolate layer cake',
                price: 60,
                category: 'Cakes',
                ingredients: ['Chocolate', 'Flour', 'Eggs', 'Butter', 'Cream'],
                calories: 450,
                isPopular: true,
              ),
              MenuItem(
                name: 'Red Velvet',
                description: 'Classic red velvet cake',
                price: 65,
                category: 'Cakes',
                ingredients: ['Cocoa', 'Buttermilk', 'Cream Cheese', 'Red Color'],
                calories: 480,
                isPopular: true,
              ),
              MenuItem(
                name: 'Carrot Cake',
                description: 'Moist carrot cake',
                price: 55,
                category: 'Cakes',
                ingredients: ['Carrots', 'Walnuts', 'Cream Cheese', 'Cinnamon'],
                calories: 420,
              ),
            ],
          ),
          MenuCategory(
            id: 'oriental',
            name: 'Oriental Sweets',
            icon: '🥮',
            items: [
              MenuItem(
                name: 'Kunafa',
                description: 'Traditional kunafa',
                price: 50,
                category: 'Oriental',
                ingredients: ['Kunafa', 'Cheese', 'Syrup', 'Pistachios'],
                calories: 390,
              ),
              MenuItem(
                name: 'Baklava Mix',
                description: 'Assorted baklava',
                price: 70,
                category: 'Oriental',
                ingredients: ['Phyllo', 'Nuts', 'Honey', 'Butter'],
                calories: 520,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '101-1', name: 'El Abd - Talaat Harb', address: 'Talaat Harb St, Downtown', latitude: 30.0444, longitude: 31.2357, rating: 4.8, menu: []),
          Branch(id: '101-2', name: 'El Abd - Heliopolis', address: 'Baghdad St', latitude: 30.0875, longitude: 31.3241, rating: 4.7, menu: []),
          Branch(id: '101-3', name: 'El Abd - Mohandiseen', address: 'Gameat El Dowal', latitude: 30.0594, longitude: 31.2000, rating: 4.6, menu: []),
          Branch(id: '101-4', name: 'El Abd - Nasr City', address: 'Makram Ebeid', latitude: 30.0626, longitude: 31.3474, rating: 4.7, menu: []),
          Branch(id: '101-5', name: 'El Abd - Maadi', address: 'Road 9', latitude: 29.9602, longitude: 31.2569, rating: 4.8, menu: []),
          Branch(id: '101-6', name: 'El Abd - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.7, menu: []),
          Branch(id: '101-7', name: 'El Abd - 6th October', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.6, menu: []),
          Branch(id: '101-8', name: 'El Abd - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.7, menu: []),
        ],
      ),

      // Mandarine Koueider
      Brand(
        id: '102',
        name: 'Mandarine Koueider',
        category: 'Desserts',
        logo: '🍊',
        menuCategories: [
          MenuCategory(
            id: 'cakes',
            name: 'Cakes',
            icon: '🎂',
            items: [
              MenuItem(
                name: 'Mandarine Cake',
                description: 'Signature mandarine cake',
                price: 70,
                category: 'Cakes',
                ingredients: ['Mandarine', 'Cream', 'Sponge Cake'],
                calories: 420,
                isPopular: true,
              ),
              MenuItem(
                name: 'Chocolate Truffle',
                description: 'Rich chocolate truffle cake',
                price: 75,
                category: 'Cakes',
                ingredients: ['Dark Chocolate', 'Cream', 'Cocoa'],
                calories: 510,
                isPopular: true,
              ),
              MenuItem(
                name: 'Strawberry Shortcake',
                description: 'Fresh strawberry cake',
                price: 65,
                category: 'Cakes',
                ingredients: ['Strawberries', 'Cream', 'Sponge'],
                calories: 380,
              ),
            ],
          ),
          MenuCategory(
            id: 'pastries',
            name: 'Pastries',
            icon: '🥐',
            items: [
              MenuItem(
                name: 'Croissant',
                description: 'Butter croissant',
                price: 20,
                category: 'Pastries',
                ingredients: ['Butter', 'Flour'],
                calories: 270,
              ),
              MenuItem(
                name: 'Pain au Chocolat',
                description: 'Chocolate croissant',
                price: 25,
                category: 'Pastries',
                ingredients: ['Butter', 'Flour', 'Chocolate'],
                calories: 320,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '102-1', name: 'Mandarine - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.8, menu: []),
          Branch(id: '102-2', name: 'Mandarine - Heliopolis', address: 'Korba', latitude: 30.0875, longitude: 31.3241, rating: 4.7, menu: []),
          Branch(id: '102-3', name: 'Mandarine - Maadi', address: 'Road 9', latitude: 29.9602, longitude: 31.2569, rating: 4.8, menu: []),
          Branch(id: '102-4', name: 'Mandarine - Mohandiseen', address: 'Gameat El Dowal', latitude: 30.0594, longitude: 31.2000, rating: 4.7, menu: []),
          Branch(id: '102-5', name: 'Mandarine - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.8, menu: []),
          Branch(id: '102-6', name: 'Mandarine - 6th October', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.7, menu: []),
          Branch(id: '102-7', name: 'Mandarine - Nasr City', address: 'City Stars', latitude: 30.0727, longitude: 31.3474, rating: 4.8, menu: []),
          Branch(id: '102-8', name: 'Mandarine - Dokki', address: 'Mesaha Square', latitude: 30.0444, longitude: 31.2000, rating: 4.7, menu: []),
          Branch(id: '102-9', name: 'Mandarine - Sheikh Zayed', address: 'Arkan Plaza', latitude: 30.0272, longitude: 30.9700, rating: 4.8, menu: []),
          Branch(id: '102-10', name: 'Mandarine - Alexandria', address: 'San Stefano', latitude: 31.2357, longitude: 29.9602, rating: 4.7, menu: []),
        ],
      ),

      // Tseppas
      Brand(
        id: '103',
        name: 'Tseppas',
        category: 'Desserts',
        logo: '🍮',
        menuCategories: [
          MenuCategory(
            id: 'desserts',
            name: 'Desserts',
            icon: '🍰',
            items: [
              MenuItem(
                name: 'Tiramisu',
                description: 'Classic Italian tiramisu',
                price: 55,
                category: 'Desserts',
                ingredients: ['Mascarpone', 'Coffee', 'Ladyfingers', 'Cocoa'],
                calories: 450,
                isPopular: true,
              ),
              MenuItem(
                name: 'Cheesecake',
                description: 'New York style cheesecake',
                price: 60,
                category: 'Desserts',
                ingredients: ['Cream Cheese', 'Graham Crackers', 'Sour Cream'],
                calories: 480,
                isPopular: true,
              ),
              MenuItem(
                name: 'Chocolate Mousse',
                description: 'Rich chocolate mousse',
                price: 45,
                category: 'Desserts',
                ingredients: ['Dark Chocolate', 'Cream', 'Eggs'],
                calories: 380,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '103-1', name: 'Tseppas - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.7, menu: []),
          Branch(id: '103-2', name: 'Tseppas - Heliopolis', address: 'Korba', latitude: 30.0875, longitude: 31.3241, rating: 4.6, menu: []),
          Branch(id: '103-3', name: 'Tseppas - Maadi', address: 'Road 9', latitude: 29.9602, longitude: 31.2569, rating: 4.7, menu: []),
          Branch(id: '103-4', name: 'Tseppas - Mohandiseen', address: 'Gameat El Dowal', latitude: 30.0594, longitude: 31.2000, rating: 4.6, menu: []),
          Branch(id: '103-5', name: 'Tseppas - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.7, menu: []),
          Branch(id: '103-6', name: 'Tseppas - 6th October', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.6, menu: []),
          Branch(id: '103-7', name: 'Tseppas - Nasr City', address: 'City Stars', latitude: 30.0727, longitude: 31.3474, rating: 4.7, menu: []),
          Branch(id: '103-8', name: 'Tseppas - Sheikh Zayed', address: 'Arkan Plaza', latitude: 30.0272, longitude: 30.9700, rating: 4.6, menu: []),
        ],
      ),

      // La Poire
      Brand(
        id: '104',
        name: 'La Poire',
        category: 'Desserts',
        logo: '🍐',
        menuCategories: [
          MenuCategory(
            id: 'cakes',
            name: 'Cakes',
            icon: '🎂',
            items: [
              MenuItem(
                name: 'Opera Cake',
                description: 'French opera cake',
                price: 70,
                category: 'Cakes',
                ingredients: ['Almond Sponge', 'Coffee Buttercream', 'Chocolate Ganache'],
                calories: 520,
                isPopular: true,
              ),
              MenuItem(
                name: 'Mille-Feuille',
                description: 'Layered puff pastry',
                price: 65,
                category: 'Cakes',
                ingredients: ['Puff Pastry', 'Pastry Cream', 'Fondant'],
                calories: 480,
              ),
            ],
          ),
          MenuCategory(
            id: 'macarons',
            name: 'Macarons',
            icon: '🍪',
            items: [
              MenuItem(
                name: 'Macaron Box',
                description: 'Assorted macarons',
                price: 80,
                category: 'Macarons',
                ingredients: ['Almond Flour', 'Various Flavors'],
                calories: 350,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '104-1', name: 'La Poire - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.8, menu: []),
          Branch(id: '104-2', name: 'La Poire - Heliopolis', address: 'Korba', latitude: 30.0875, longitude: 31.3241, rating: 4.7, menu: []),
          Branch(id: '104-3', name: 'La Poire - Maadi', address: 'Road 9', latitude: 29.9602, longitude: 31.2569, rating: 4.8, menu: []),
          Branch(id: '104-4', name: 'La Poire - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.7, menu: []),
          Branch(id: '104-5', name: 'La Poire - 6th October', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.8, menu: []),
          Branch(id: '104-6', name: 'La Poire - Sheikh Zayed', address: 'Arkan Plaza', latitude: 30.0272, longitude: 30.9700, rating: 4.7, menu: []),
        ],
      ),
    ];
  }
}
