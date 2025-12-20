import 'package:outing/models/brand_model.dart';

// Entertainment & Recreation Brands
class EntertainmentBrandsData {
  static List<Brand> getCinemas() {
    return [
      // VOX Cinemas
      Brand(
        id: '1000',
        name: 'VOX Cinemas',
        category: 'Entertainment',
        logo: '🎬',
        menuCategories: [
          MenuCategory(
            id: 'tickets',
            name: 'Tickets',
            icon: '🎫',
            items: [
              MenuItem(
                name: 'Standard Ticket',
                description: 'Regular cinema seat',
                price: 100,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
              MenuItem(
                name: 'VIP Ticket',
                description: 'Premium recliner seat',
                price: 200,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
              ),
              MenuItem(
                name: 'IMAX Ticket',
                description: 'IMAX experience',
                price: 150,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
            ],
          ),
          MenuCategory(
            id: 'snacks',
            name: 'Snacks',
            icon: '🍿',
            items: [
              MenuItem(
                name: 'Popcorn Combo',
                description: 'Large popcorn + drink',
                price: 80,
                category: 'Snacks',
                ingredients: ['Popcorn', 'Soft Drink'],
                calories: 450,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '1000-1', name: 'VOX - City Stars', address: 'City Stars Mall', latitude: 30.0727, longitude: 31.3474, rating: 4.6, menu: []),
          Branch(id: '1000-2', name: 'VOX - Mall of Arabia', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.5, menu: []),
          Branch(id: '1000-3', name: 'VOX - Cairo Festival City', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.7, menu: []),
          Branch(id: '1000-4', name: 'VOX - Mall of Egypt', address: 'Mall of Egypt', latitude: 29.9765, longitude: 30.9283, rating: 4.6, menu: []),
        ],
      ),

      // Cineplex
      Brand(
        id: '1001',
        name: 'Cineplex',
        category: 'Entertainment',
        logo: '🎥',
        menuCategories: [
          MenuCategory(
            id: 'tickets',
            name: 'Tickets',
            icon: '🎫',
            items: [
              MenuItem(
                name: 'Regular Ticket',
                description: 'Standard seat',
                price: 90,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
              MenuItem(
                name: 'Gold Class',
                description: 'Luxury experience',
                price: 250,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '1001-1', name: 'Cineplex - City Centre Almaza', address: 'Almaza', latitude: 30.0875, longitude: 31.3241, rating: 4.4, menu: []),
          Branch(id: '1001-2', name: 'Cineplex - Americana Plaza', address: 'Sheikh Zayed', latitude: 30.0272, longitude: 30.9700, rating: 4.5, menu: []),
        ],
      ),
    ];
  }

  static List<Brand> getMalls() {
    return [
      // City Stars
      Brand(
        id: '1100',
        name: 'City Stars',
        category: 'Shopping',
        logo: '🏬',
        menuCategories: [
          MenuCategory(
            id: 'services',
            name: 'Services',
            icon: '🛍️',
            items: [
              MenuItem(
                name: 'Shopping Experience',
                description: '300+ stores',
                price: 0,
                category: 'Services',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '1100-1', name: 'City Stars Mall', address: 'Nasr City', latitude: 30.0727, longitude: 31.3474, rating: 4.7, menu: []),
        ],
      ),

      // Mall of Arabia
      Brand(
        id: '1101',
        name: 'Mall of Arabia',
        category: 'Shopping',
        logo: '🏪',
        menuCategories: [
          MenuCategory(
            id: 'services',
            name: 'Services',
            icon: '🛍️',
            items: [
              MenuItem(
                name: 'Shopping & Entertainment',
                description: '400+ stores',
                price: 0,
                category: 'Services',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '1101-1', name: 'Mall of Arabia', address: '6th October', latitude: 29.9765, longitude: 30.9283, rating: 4.8, menu: []),
        ],
      ),

      // Cairo Festival City
      Brand(
        id: '1102',
        name: 'Cairo Festival City',
        category: 'Shopping',
        logo: '🎪',
        menuCategories: [
          MenuCategory(
            id: 'services',
            name: 'Services',
            icon: '🛍️',
            items: [
              MenuItem(
                name: 'Festival Experience',
                description: 'Shopping, dining, entertainment',
                price: 0,
                category: 'Services',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '1102-1', name: 'Cairo Festival City Mall', address: 'New Cairo', latitude: 30.0272, longitude: 31.4066, rating: 4.7, menu: []),
        ],
      ),
    ];
  }

  static List<Brand> getEntertainmentCenters() {
    return [
      // Magic Galaxy
      Brand(
        id: '1200',
        name: 'Magic Galaxy',
        category: 'Entertainment',
        logo: '🎮',
        menuCategories: [
          MenuCategory(
            id: 'activities',
            name: 'Activities',
            icon: '🎯',
            items: [
              MenuItem(
                name: 'Game Card 100 EGP',
                description: 'Arcade games',
                price: 100,
                category: 'Activities',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
              MenuItem(
                name: 'Game Card 200 EGP',
                description: 'More game credits',
                price: 200,
                category: 'Activities',
                ingredients: [],
                calories: 0,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '1200-1', name: 'Magic Galaxy - City Stars', address: 'City Stars Mall', latitude: 30.0727, longitude: 31.3474, rating: 4.5, menu: []),
          Branch(id: '1200-2', name: 'Magic Galaxy - Mall of Arabia', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.4, menu: []),
        ],
      ),

      // KidZania
      Brand(
        id: '1201',
        name: 'KidZania',
        category: 'Entertainment',
        logo: '👶',
        menuCategories: [
          MenuCategory(
            id: 'tickets',
            name: 'Tickets',
            icon: '🎫',
            items: [
              MenuItem(
                name: 'Child Ticket',
                description: 'Ages 4-14',
                price: 250,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
              MenuItem(
                name: 'Adult Ticket',
                description: 'Accompanying adult',
                price: 100,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '1201-1', name: 'KidZania Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.8, menu: []),
        ],
      ),

      // Ski Egypt
      Brand(
        id: '1202',
        name: 'Ski Egypt',
        category: 'Entertainment',
        logo: '⛷️',
        menuCategories: [
          MenuCategory(
            id: 'tickets',
            name: 'Tickets',
            icon: '🎫',
            items: [
              MenuItem(
                name: 'Slope Session',
                description: '2-hour skiing',
                price: 350,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
              MenuItem(
                name: 'Snow Park',
                description: 'Snow play area',
                price: 200,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '1202-1', name: 'Ski Egypt', address: 'Mall of Egypt', latitude: 29.9765, longitude: 30.9283, rating: 4.7, menu: []),
        ],
      ),
    ];
  }

  static List<Brand> getRecreationalPlaces() {
    return [
      // Dream Park
      Brand(
        id: '1300',
        name: 'Dream Park',
        category: 'Recreation',
        logo: '🎢',
        menuCategories: [
          MenuCategory(
            id: 'tickets',
            name: 'Tickets',
            icon: '🎫',
            items: [
              MenuItem(
                name: 'Day Pass',
                description: 'Unlimited rides',
                price: 300,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '1300-1', name: 'Dream Park', address: '6th October', latitude: 29.9765, longitude: 30.9283, rating: 4.5, menu: []),
        ],
      ),

      // Pharaoh's Village
      Brand(
        id: '1301',
        name: 'Pharaoh\'s Village',
        category: 'Recreation',
        logo: '🏛️',
        menuCategories: [
          MenuCategory(
            id: 'tickets',
            name: 'Tickets',
            icon: '🎫',
            items: [
              MenuItem(
                name: 'Entry Ticket',
                description: 'Pharaonic experience',
                price: 150,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '1301-1', name: 'Pharaoh\'s Village', address: 'Jacob Island, Giza', latitude: 30.0100, longitude: 31.2100, rating: 4.3, menu: []),
        ],
      ),

      // Aqua Park
      Brand(
        id: '1302',
        name: 'Aqua Park',
        category: 'Recreation',
        logo: '🏊',
        menuCategories: [
          MenuCategory(
            id: 'tickets',
            name: 'Tickets',
            icon: '🎫',
            items: [
              MenuItem(
                name: 'Day Pass',
                description: 'Water slides & pools',
                price: 250,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '1302-1', name: 'Aqua Park - 6th October', address: '6th October', latitude: 29.9765, longitude: 30.9283, rating: 4.4, menu: []),
        ],
      ),
    ];
  }
}
