import 'package:flutter/material.dart';
import 'package:outing/models/brand_model.dart';
import 'package:outing/providers/dessert_brands_data.dart';
import 'package:outing/providers/fastfood_expansion_data.dart';
import 'package:outing/providers/cafes_expansion_data.dart';
import 'package:outing/providers/egyptian_restaurants_data.dart';
import 'package:outing/providers/branch_expansion_data.dart';
import 'package:outing/providers/asian_finedining_data.dart';
import 'package:outing/providers/additional_brands_data.dart';
import 'package:outing/providers/entertainment_brands_data.dart';
import 'package:outing/providers/historical_places_data.dart';

class BrandsProvider with ChangeNotifier {
  final List<Brand> _brands = [
    // McDonald's with full menu
    Brand(
      id: '1',
      name: 'McDonald\'s',
      category: 'Restaurants',
      logo: '🍔',
      menuCategories: [
        MenuCategory(
          id: 'burgers',
          name: 'Burgers',
          icon: '🍔',
          items: [
            MenuItem(
              name: 'Big Mac',
              description: 'Two 100% beef patties, special sauce, lettuce, cheese, pickles, onions',
              price: 85,
              category: 'Burgers',
              ingredients: ['Beef Patty', 'Special Sauce', 'Lettuce', 'Cheese', 'Pickles', 'Onions', 'Sesame Bun'],
              calories: 563,
              isPopular: true,
              sizes: [
                ItemSize(name: 'Regular', price: 85),
                ItemSize(name: 'Meal', price: 120, description: 'With fries and drink'),
              ],
            ),
            MenuItem(
              name: 'Quarter Pounder',
              description: 'Quarter pound 100% beef patty with cheese',
              price: 95,
              category: 'Burgers',
              ingredients: ['Beef Patty', 'Cheese', 'Onions', 'Pickles', 'Ketchup', 'Mustard'],
              calories: 520,
              isPopular: true,
            ),
            MenuItem(
              name: 'McChicken',
              description: 'Crispy chicken fillet with lettuce and mayo',
              price: 70,
              category: 'Burgers',
              ingredients: ['Chicken Fillet', 'Lettuce', 'Mayo', 'Bun'],
              calories: 400,
            ),
            MenuItem(
              name: 'Filet-O-Fish',
              description: 'Fish fillet with tartar sauce',
              price: 75,
              category: 'Burgers',
              ingredients: ['Fish Fillet', 'Tartar Sauce', 'Cheese', 'Bun'],
              calories: 380,
            ),
          ],
        ),
        MenuCategory(
          id: 'chicken',
          name: 'Chicken',
          icon: '🍗',
          items: [
            MenuItem(
              name: 'Chicken McNuggets',
              description: 'Crispy chicken nuggets',
              price: 55,
              category: 'Chicken',
              ingredients: ['Chicken Breast', 'Breading'],
              calories: 280,
              isPopular: true,
              sizes: [
                ItemSize(name: '6 Pieces', price: 55),
                ItemSize(name: '9 Pieces', price: 75),
                ItemSize(name: '20 Pieces', price: 150),
              ],
            ),
          ],
        ),
        MenuCategory(
          id: 'sides',
          name: 'Sides',
          icon: '🍟',
          items: [
            MenuItem(
              name: 'French Fries',
              description: 'Golden crispy fries',
              price: 25,
              category: 'Sides',
              ingredients: ['Potatoes', 'Salt'],
              calories: 230,
              sizes: [
                ItemSize(name: 'Small', price: 20),
                ItemSize(name: 'Medium', price: 25),
                ItemSize(name: 'Large', price: 35),
              ],
            ),
          ],
        ),
        MenuCategory(
          id: 'desserts',
          name: 'Desserts',
          icon: '🍦',
          items: [
            MenuItem(
              name: 'McFlurry Oreo',
              description: 'Soft serve with Oreo pieces',
              price: 40,
              category: 'Desserts',
              ingredients: ['Soft Serve', 'Oreo Cookies'],
              calories: 340,
              isPopular: true,
            ),
            MenuItem(
              name: 'Apple Pie',
              description: 'Hot apple pie',
              price: 20,
              category: 'Desserts',
              ingredients: ['Apples', 'Cinnamon', 'Pastry'],
              calories: 230,
            ),
          ],
        ),
        MenuCategory(
          id: 'drinks',
          name: 'Drinks',
          icon: '🥤',
          items: [
            MenuItem(
              name: 'Coca Cola',
              description: 'Classic Coca Cola',
              price: 20,
              category: 'Drinks',
              ingredients: ['Carbonated Water', 'Sugar'],
              calories: 140,
              sizes: [
                ItemSize(name: 'Small', price: 15),
                ItemSize(name: 'Medium', price: 20),
                ItemSize(name: 'Large', price: 25),
              ],
            ),
          ],
        ),
        MenuCategory(
          id: 'happy_meal',
          name: 'Happy Meal',
          icon: '🎁',
          items: [
            MenuItem(
              name: 'Happy Meal',
              description: 'Kids meal with toy',
              price: 65,
              category: 'Happy Meal',
              ingredients: ['Burger or Nuggets', 'Fries', 'Drink', 'Toy'],
              calories: 475,
            ),
          ],
        ),
      ],
      branches: McDonaldsBranchExpansion.getExpandedBranches(),
    ),

    // KFC
    Brand(
      id: '2',
      name: 'KFC',
      category: 'Restaurants',
      logo: '🍗',
      menuCategories: [
        MenuCategory(
          id: 'meals',
          name: 'Meals',
          icon: '🍗',
          items: [
            MenuItem(
              name: 'Zinger Meal',
              description: 'Spicy chicken sandwich meal',
              price: 90,
              category: 'Meals',
              ingredients: ['Spicy Chicken', 'Lettuce', 'Mayo', 'Bun', 'Fries', 'Drink'],
              calories: 650,
              isPopular: true,
            ),
            MenuItem(
              name: 'Original Recipe 3pc',
              description: 'Classic fried chicken',
              price: 85,
              category: 'Meals',
              ingredients: ['Fried Chicken', 'Secret Recipe'],
              calories: 520,
            ),
          ],
        ),
        MenuCategory(
          id: 'chicken',
          name: 'Chicken',
          icon: '🍗',
          items: [
            MenuItem(
              name: 'Hot Wings',
              description: 'Spicy chicken wings',
              price: 70,
              category: 'Chicken',
              ingredients: ['Chicken Wings', 'Spicy Coating'],
              calories: 450,
              sizes: [
                ItemSize(name: '6 Pieces', price: 70),
                ItemSize(name: '12 Pieces', price: 130),
              ],
            ),
            MenuItem(
              name: 'Popcorn Chicken',
              description: 'Bite-sized chicken',
              price: 55,
              category: 'Chicken',
              ingredients: ['Chicken', 'Breading'],
              calories: 380,
            ),
          ],
        ),
        MenuCategory(
          id: 'buckets',
          name: 'Buckets',
          icon: '🪣',
          items: [
            MenuItem(
              name: 'Bucket 8pc',
              description: '8 pieces chicken',
              price: 250,
              category: 'Buckets',
              ingredients: ['Fried Chicken'],
              calories: 1600,
              isPopular: true,
            ),
            MenuItem(
              name: 'Bucket 12pc',
              description: '12 pieces chicken',
              price: 350,
              category: 'Buckets',
              ingredients: ['Fried Chicken'],
              calories: 2400,
            ),
          ],
        ),
      ],
      branches: [
        Branch(
          id: '2-1',
          name: 'KFC - Tahrir',
          address: 'Tahrir Square',
          latitude: 30.0444,
          longitude: 31.2357,
          rating: 4.0,
          menu: [],
        ),
        Branch(
          id: '2-2',
          name: 'KFC - Heliopolis',
          address: 'Korba, Heliopolis',
          latitude: 30.0875,
          longitude: 31.3241,
          rating: 4.2,
          menu: [],
        ),
      ],
    ),

    // Mo'men
    Brand(
      id: '3',
      name: 'Mo\'men',
      category: 'Restaurants',
      logo: '🥙',
      menuCategories: [
        MenuCategory(
          id: 'shawarma',
          name: 'Shawarma',
          icon: '🥙',
          items: [
            MenuItem(
              name: 'Chicken Shawarma',
              description: 'Grilled chicken wrap',
              price: 45,
              category: 'Shawarma',
              ingredients: ['Grilled Chicken', 'Tahina', 'Pickles', 'Bread'],
              calories: 350,
              isPopular: true,
            ),
            MenuItem(
              name: 'Meat Shawarma',
              description: 'Grilled meat wrap',
              price: 55,
              category: 'Shawarma',
              ingredients: ['Grilled Meat', 'Tahina', 'Pickles', 'Bread'],
              calories: 420,
            ),
            MenuItem(
              name: 'Mix Shawarma',
              description: 'Chicken & meat mix',
              price: 60,
              category: 'Shawarma',
              ingredients: ['Chicken', 'Meat', 'Tahina', 'Pickles', 'Bread'],
              calories: 450,
            ),
          ],
        ),
        MenuCategory(
          id: 'grilled',
          name: 'Grilled',
          icon: '🍖',
          items: [
            MenuItem(
              name: 'Kofta Sandwich',
              description: 'Grilled kofta',
              price: 50,
              category: 'Grilled',
              ingredients: ['Kofta', 'Tahina', 'Bread'],
              calories: 380,
            ),
            MenuItem(
              name: 'Shish Tawook',
              description: 'Chicken skewers',
              price: 70,
              category: 'Grilled',
              ingredients: ['Chicken Skewers', 'Garlic Sauce'],
              calories: 320,
            ),
          ],
        ),
      ],
      branches: [
        Branch(
          id: '3-1',
          name: 'Mo\'men - Mohandiseen',
          address: 'Lebanon St',
          latitude: 30.0594,
          longitude: 31.2000,
          rating: 4.5,
          menu: [],
        ),
        Branch(
          id: '3-2',
          name: 'Mo\'men - Nasr City',
          address: 'Makram Ebeid',
          latitude: 30.0626,
          longitude: 31.3474,
          rating: 4.4,
          menu: [],
        ),
      ],
    ),

    // Starbucks
    Brand(
      id: '4',
      name: 'Starbucks',
      category: 'Cafes',
      logo: '☕',
      menuCategories: [
        MenuCategory(
          id: 'hot_coffee',
          name: 'Hot Coffee',
          icon: '☕',
          items: [
            MenuItem(
              name: 'Caffe Latte',
              description: 'Espresso with steamed milk',
              price: 55,
              category: 'Hot Coffee',
              ingredients: ['Espresso', 'Steamed Milk'],
              calories: 190,
              isPopular: true,
              sizes: [
                ItemSize(name: 'Tall', price: 45),
                ItemSize(name: 'Grande', price: 55),
                ItemSize(name: 'Venti', price: 65),
              ],
            ),
            MenuItem(
              name: 'Cappuccino',
              description: 'Espresso with foam',
              price: 50,
              category: 'Hot Coffee',
              ingredients: ['Espresso', 'Steamed Milk', 'Foam'],
              calories: 140,
            ),
            MenuItem(
              name: 'Caramel Macchiato',
              description: 'Vanilla & caramel',
              price: 65,
              category: 'Hot Coffee',
              ingredients: ['Espresso', 'Vanilla', 'Steamed Milk', 'Caramel'],
              calories: 250,
              isPopular: true,
            ),
          ],
        ),
        MenuCategory(
          id: 'cold_coffee',
          name: 'Cold Coffee',
          icon: '🧊',
          items: [
            MenuItem(
              name: 'Frappuccino',
              description: 'Iced blended coffee',
              price: 70,
              category: 'Cold Coffee',
              ingredients: ['Coffee', 'Ice', 'Milk', 'Whipped Cream'],
              calories: 380,
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
              price: 35,
              category: 'Food',
              ingredients: ['Butter', 'Flour'],
              calories: 270,
            ),
            MenuItem(
              name: 'Blueberry Muffin',
              description: 'Fresh muffin',
              price: 40,
              category: 'Food',
              ingredients: ['Blueberries', 'Flour', 'Sugar'],
              calories: 360,
            ),
          ],
        ),
      ],
      branches: [
        Branch(
          id: '4-1',
          name: 'Starbucks - Zamalek',
          address: '26th July St',
          latitude: 30.0626,
          longitude: 31.2197,
          rating: 4.5,
          menu: [],
        ),
        Branch(
          id: '4-2',
          name: 'Starbucks - New Cairo',
          address: 'Cairo Festival City',
          latitude: 30.0272,
          longitude: 31.4066,
          rating: 4.4,
          menu: [],
        ),
      ],
    ),

    // Costa Coffee
    Brand(
      id: '5',
      name: 'Costa Coffee',
      category: 'Cafes',
      logo: '☕',
      menuCategories: [
        MenuCategory(
          id: 'coffee',
          name: 'Coffee',
          icon: '☕',
          items: [
            MenuItem(
              name: 'Flat White',
              description: 'Smooth espresso',
              price: 50,
              category: 'Coffee',
              ingredients: ['Espresso', 'Microfoam Milk'],
              calories: 120,
            ),
            MenuItem(
              name: 'Latte',
              description: 'Creamy latte',
              price: 52,
              category: 'Coffee',
              ingredients: ['Espresso', 'Steamed Milk'],
              calories: 180,
            ),
            MenuItem(
              name: 'Mocha',
              description: 'Chocolate coffee',
              price: 60,
              category: 'Coffee',
              ingredients: ['Espresso', 'Chocolate', 'Steamed Milk'],
              calories: 290,
              isPopular: true,
            ),
          ],
        ),
        MenuCategory(
          id: 'food',
          name: 'Food',
          icon: '🍰',
          items: [
            MenuItem(
              name: 'Carrot Cake',
              description: 'Moist cake',
              price: 50,
              category: 'Food',
              ingredients: ['Carrots', 'Cream Cheese Frosting'],
              calories: 420,
            ),
          ],
        ),
      ],
      branches: [
        Branch(
          id: '5-1',
          name: 'Costa - Mohandiseen',
          address: 'Gameat El Dowal',
          latitude: 30.0594,
          longitude: 31.2000,
          rating: 4.3,
          menu: [],
        ),
      ],
    ),

    // Add all dessert brands
    ...BrandExpansionData.getDessertBrands(),
    
    // Add all fast food brands
    ...FastFoodExpansionData.getFastFoodBrands(),
    
    // Add all cafe brands
    ...CafesExpansionData.getCafeBrands(),
    
    // Add all Egyptian restaurants
    ...EgyptianRestaurantsData.getEgyptianRestaurants(),
    
    // Add all Asian cuisine brands
    ...AsianAndFineDiningData.getAsianCuisine(),
    
    // Add all fine dining brands
    ...AsianAndFineDiningData.getFineDining(),
    
    // Add additional fast food brands
    ...AdditionalBrandsData.getAdditionalFastFood(),
    
    // Add additional Egyptian restaurants
    ...AdditionalBrandsData.getAdditionalEgyptian(),
    
    // Add additional cafes
    ...AdditionalBrandsData.getAdditionalCafes(),
    
    // Add entertainment - Cinemas
    ...EntertainmentBrandsData.getCinemas(),
    
    // Add entertainment - Malls
    ...EntertainmentBrandsData.getMalls(),
    
    // Add entertainment - Entertainment Centers
    ...EntertainmentBrandsData.getEntertainmentCenters(),
    
    // Add entertainment - Recreational Places
    ...EntertainmentBrandsData.getRecreationalPlaces(),
    
    // Add historical sites
    ...HistoricalPlacesData.getHistoricalSites(),
  ];

  List<Brand> get brands => _brands;

  List<Brand> getBrandsByCategory(String category) {
    if (category == 'All') return _brands;
    return _brands.where((b) => b.category == category).toList();
  }

  Brand? getBrandById(String id) {
    try {
      return _brands.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }
}
