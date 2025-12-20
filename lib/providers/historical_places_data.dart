import 'package:outing/models/brand_model.dart';

// Historical & Tourist Attractions
class HistoricalPlacesData {
  static List<Brand> getHistoricalSites() {
    return [
      // Pyramids of Giza
      Brand(
        id: '2000',
        name: 'Pyramids of Giza',
        category: 'Historical',
        logo: '🔺',
        menuCategories: [
          MenuCategory(
            id: 'tickets',
            name: 'Tickets',
            icon: '🎫',
            items: [
              MenuItem(
                name: 'Pyramids Area Entry',
                description: 'Access to pyramids complex',
                price: 200,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
              MenuItem(
                name: 'Great Pyramid Interior',
                description: 'Inside the Great Pyramid',
                price: 400,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
              MenuItem(
                name: 'Sound & Light Show',
                description: 'Evening show',
                price: 300,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '2000-1', name: 'Pyramids of Giza', address: 'Giza Plateau', latitude: 29.9792, longitude: 31.1342, rating: 4.9, menu: []),
        ],
      ),

      // Egyptian Museum
      Brand(
        id: '2001',
        name: 'Egyptian Museum',
        category: 'Historical',
        logo: '🏛️',
        menuCategories: [
          MenuCategory(
            id: 'tickets',
            name: 'Tickets',
            icon: '🎫',
            items: [
              MenuItem(
                name: 'General Admission',
                description: 'Museum entry',
                price: 200,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
              MenuItem(
                name: 'Royal Mummies Hall',
                description: 'Special exhibition',
                price: 150,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '2001-1', name: 'Egyptian Museum', address: 'Tahrir Square', latitude: 30.0478, longitude: 31.2336, rating: 4.7, menu: []),
        ],
      ),

      // Grand Egyptian Museum (GEM)
      Brand(
        id: '2002',
        name: 'Grand Egyptian Museum',
        category: 'Historical',
        logo: '🏺',
        menuCategories: [
          MenuCategory(
            id: 'tickets',
            name: 'Tickets',
            icon: '🎫',
            items: [
              MenuItem(
                name: 'GEM Entry Ticket',
                description: 'Full museum access',
                price: 500,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
              MenuItem(
                name: 'Tutankhamun Gallery',
                description: 'Complete collection',
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
          Branch(id: '2002-1', name: 'Grand Egyptian Museum', address: 'Near Pyramids, Giza', latitude: 29.9934, longitude: 31.1175, rating: 4.9, menu: []),
        ],
      ),

      // Citadel of Saladin
      Brand(
        id: '2003',
        name: 'Citadel of Saladin',
        category: 'Historical',
        logo: '🏰',
        menuCategories: [
          MenuCategory(
            id: 'tickets',
            name: 'Tickets',
            icon: '🎫',
            items: [
              MenuItem(
                name: 'Citadel Entry',
                description: 'Full citadel access',
                price: 180,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
              MenuItem(
                name: 'Mohamed Ali Mosque',
                description: 'Mosque visit',
                price: 100,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '2003-1', name: 'Citadel of Saladin', address: 'Al-Abageyah, Cairo', latitude: 30.0296, longitude: 31.2600, rating: 4.6, menu: []),
        ],
      ),

      // Khan El Khalili
      Brand(
        id: '2004',
        name: 'Khan El Khalili',
        category: 'Historical',
        logo: '🕌',
        menuCategories: [
          MenuCategory(
            id: 'experience',
            name: 'Experience',
            icon: '🛍️',
            items: [
              MenuItem(
                name: 'Bazaar Tour',
                description: 'Guided shopping tour',
                price: 150,
                category: 'Experience',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '2004-1', name: 'Khan El Khalili', address: 'Islamic Cairo', latitude: 30.0478, longitude: 31.2625, rating: 4.5, menu: []),
        ],
      ),

      // Luxor Temple
      Brand(
        id: '2005',
        name: 'Luxor Temple',
        category: 'Historical',
        logo: '⛩️',
        menuCategories: [
          MenuCategory(
            id: 'tickets',
            name: 'Tickets',
            icon: '🎫',
            items: [
              MenuItem(
                name: 'Temple Entry',
                description: 'Ancient temple visit',
                price: 160,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '2005-1', name: 'Luxor Temple', address: 'Luxor City', latitude: 25.6995, longitude: 32.6397, rating: 4.8, menu: []),
        ],
      ),

      // Karnak Temple
      Brand(
        id: '2006',
        name: 'Karnak Temple',
        category: 'Historical',
        logo: '🏛️',
        menuCategories: [
          MenuCategory(
            id: 'tickets',
            name: 'Tickets',
            icon: '🎫',
            items: [
              MenuItem(
                name: 'Karnak Entry',
                description: 'Temple complex',
                price: 200,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '2006-1', name: 'Karnak Temple', address: 'Luxor', latitude: 25.7188, longitude: 32.6573, rating: 4.9, menu: []),
        ],
      ),

      // Valley of the Kings
      Brand(
        id: '2007',
        name: 'Valley of the Kings',
        category: 'Historical',
        logo: '👑',
        menuCategories: [
          MenuCategory(
            id: 'tickets',
            name: 'Tickets',
            icon: '🎫',
            items: [
              MenuItem(
                name: 'Valley Entry',
                description: '3 tombs access',
                price: 240,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
              MenuItem(
                name: 'Tutankhamun Tomb',
                description: 'Special tomb',
                price: 300,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '2007-1', name: 'Valley of the Kings', address: 'West Bank, Luxor', latitude: 25.7402, longitude: 32.6014, rating: 4.8, menu: []),
        ],
      ),

      // Abu Simbel
      Brand(
        id: '2008',
        name: 'Abu Simbel Temples',
        category: 'Historical',
        logo: '🗿',
        menuCategories: [
          MenuCategory(
            id: 'tickets',
            name: 'Tickets',
            icon: '🎫',
            items: [
              MenuItem(
                name: 'Temples Entry',
                description: 'Both temples',
                price: 200,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '2008-1', name: 'Abu Simbel Temples', address: 'Aswan', latitude: 22.3372, longitude: 31.6258, rating: 4.9, menu: []),
        ],
      ),

      // Alexandria Library
      Brand(
        id: '2009',
        name: 'Bibliotheca Alexandrina',
        category: 'Historical',
        logo: '📚',
        menuCategories: [
          MenuCategory(
            id: 'tickets',
            name: 'Tickets',
            icon: '🎫',
            items: [
              MenuItem(
                name: 'Library Entry',
                description: 'Full access',
                price: 70,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '2009-1', name: 'Bibliotheca Alexandrina', address: 'Alexandria Corniche', latitude: 31.2089, longitude: 29.9093, rating: 4.7, menu: []),
        ],
      ),

      // Qaitbay Citadel
      Brand(
        id: '2010',
        name: 'Qaitbay Citadel',
        category: 'Historical',
        logo: '🏯',
        menuCategories: [
          MenuCategory(
            id: 'tickets',
            name: 'Tickets',
            icon: '🎫',
            items: [
              MenuItem(
                name: 'Citadel Entry',
                description: 'Fort & museum',
                price: 60,
                category: 'Tickets',
                ingredients: [],
                calories: 0,
                isPopular: true,
              ),
            ],
          ),
        ],
        branches: [
          Branch(id: '2010-1', name: 'Qaitbay Citadel', address: 'Alexandria', latitude: 31.2139, longitude: 29.8853, rating: 4.5, menu: []),
        ],
      ),
    ];
  }
}
