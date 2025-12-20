import 'package:outing/models/brand_model.dart';

// Starbucks & Costa Expansion - More branches
class CafesBranchExpansion {
  static List<Branch> getStarbucksExpandedBranches() {
    return [
      // Original
      Branch(id: '4-1', name: 'Starbucks - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.5, menu: []),
      Branch(id: '4-2', name: 'Starbucks - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.6, menu: []),
      
      // New branches
      Branch(id: '4-3', name: 'Starbucks - City Stars', address: 'City Stars Mall', latitude: 30.0727, longitude: 31.3474, rating: 4.5, menu: []),
      Branch(id: '4-4', name: 'Starbucks - Mall of Arabia', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.4, menu: []),
      Branch(id: '4-5', name: 'Starbucks - Maadi', address: 'Road 9', latitude: 29.9602, longitude: 31.2569, rating: 4.6, menu: []),
      Branch(id: '4-6', name: 'Starbucks - Heliopolis', address: 'Korba', latitude: 30.0875, longitude: 31.3241, rating: 4.5, menu: []),
      Branch(id: '4-7', name: 'Starbucks - Mohandiseen', address: 'Gameat El Dowal', latitude: 30.0594, longitude: 31.2000, rating: 4.4, menu: []),
      Branch(id: '4-8', name: 'Starbucks - Sheikh Zayed', address: 'Arkan Plaza', latitude: 30.0272, longitude: 30.9700, rating: 4.6, menu: []),
      Branch(id: '4-9', name: 'Starbucks - Nasr City', address: 'Abbas El Akkad', latitude: 30.0626, longitude: 31.3474, rating: 4.5, menu: []),
      Branch(id: '4-10', name: 'Starbucks - Dokki', address: 'Mesaha Square', latitude: 30.0444, longitude: 31.2000, rating: 4.4, menu: []),
      Branch(id: '4-11', name: 'Starbucks - Tagamoa', address: 'Fifth Settlement', latitude: 30.0300, longitude: 31.4300, rating: 4.6, menu: []),
      Branch(id: '4-12', name: 'Starbucks - Rehab', address: 'Rehab City', latitude: 30.0600, longitude: 31.4900, rating: 4.5, menu: []),
      Branch(id: '4-13', name: 'Starbucks - Madinaty', address: 'Madinaty', latitude: 30.0900, longitude: 31.6400, rating: 4.6, menu: []),
      Branch(id: '4-14', name: 'Starbucks - Alexandria', address: 'San Stefano', latitude: 31.2357, longitude: 29.9602, rating: 4.5, menu: []),
      Branch(id: '4-15', name: 'Starbucks - Smart Village', address: 'Smart Village', latitude: 30.0700, longitude: 30.9900, rating: 4.6, menu: []),
    ];
  }

  static List<Branch> getCostaExpandedBranches() {
    return [
      // Original
      Branch(id: '5-1', name: 'Costa Coffee - Mohandiseen', address: 'Gameat El Dowal', latitude: 30.0594, longitude: 31.2000, rating: 4.4, menu: []),
      
      // New branches
      Branch(id: '5-2', name: 'Costa Coffee - City Stars', address: 'City Stars Mall', latitude: 30.0727, longitude: 31.3474, rating: 4.5, menu: []),
      Branch(id: '5-3', name: 'Costa Coffee - Mall of Arabia', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.3, menu: []),
      Branch(id: '5-4', name: 'Costa Coffee - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.5, menu: []),
      Branch(id: '5-5', name: 'Costa Coffee - Maadi', address: 'Road 9', latitude: 29.9602, longitude: 31.2569, rating: 4.6, menu: []),
      Branch(id: '5-6', name: 'Costa Coffee - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.5, menu: []),
      Branch(id: '5-7', name: 'Costa Coffee - Heliopolis', address: 'Korba', latitude: 30.0875, longitude: 31.3241, rating: 4.4, menu: []),
      Branch(id: '5-8', name: 'Costa Coffee - Sheikh Zayed', address: 'Arkan Plaza', latitude: 30.0272, longitude: 30.9700, rating: 4.6, menu: []),
      Branch(id: '5-9', name: 'Costa Coffee - Nasr City', address: 'Abbas El Akkad', latitude: 30.0626, longitude: 31.3474, rating: 4.4, menu: []),
      Branch(id: '5-10', name: 'Costa Coffee - Alexandria', address: 'San Stefano', latitude: 31.2357, longitude: 29.9602, rating: 4.5, menu: []),
    ];
  }
}

// Dessert Brands Expansion - More branches
class DessertBranchExpansion {
  static List<Branch> getBalbaaExpandedBranches() {
    return [
      // Original 5
      Branch(id: '100-1', name: 'Balbaa - Heliopolis', address: 'Korba, Heliopolis', latitude: 30.0875, longitude: 31.3241, rating: 4.6, menu: []),
      Branch(id: '100-2', name: 'Balbaa - Nasr City', address: 'Abbas El Akkad', latitude: 30.0626, longitude: 31.3474, rating: 4.5, menu: []),
      Branch(id: '100-3', name: 'Balbaa - Maadi', address: 'Road 9, Maadi', latitude: 29.9602, longitude: 31.2569, rating: 4.7, menu: []),
      Branch(id: '100-4', name: 'Balbaa - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.6, menu: []),
      Branch(id: '100-5', name: 'Balbaa - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.5, menu: []),
      
      // New branches
      Branch(id: '100-6', name: 'Balbaa - Mohandiseen', address: 'Gameat El Dowal', latitude: 30.0594, longitude: 31.2000, rating: 4.6, menu: []),
      Branch(id: '100-7', name: 'Balbaa - Dokki', address: 'Mesaha Square', latitude: 30.0444, longitude: 31.2000, rating: 4.5, menu: []),
      Branch(id: '100-8', name: 'Balbaa - Sheikh Zayed', address: 'Arkan Plaza', latitude: 30.0272, longitude: 30.9700, rating: 4.7, menu: []),
      Branch(id: '100-9', name: 'Balbaa - 6th October', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.5, menu: []),
      Branch(id: '100-10', name: 'Balbaa - Alexandria', address: 'San Stefano', latitude: 31.2357, longitude: 29.9602, rating: 4.6, menu: []),
    ];
  }

  static List<Branch> getElAbdExpandedBranches() {
    return [
      // Original 8
      Branch(id: '101-1', name: 'El Abd - Talaat Harb', address: 'Talaat Harb St, Downtown', latitude: 30.0444, longitude: 31.2357, rating: 4.8, menu: []),
      Branch(id: '101-2', name: 'El Abd - Heliopolis', address: 'Baghdad St', latitude: 30.0875, longitude: 31.3241, rating: 4.7, menu: []),
      Branch(id: '101-3', name: 'El Abd - Mohandiseen', address: 'Gameat El Dowal', latitude: 30.0594, longitude: 31.2000, rating: 4.6, menu: []),
      Branch(id: '101-4', name: 'El Abd - Nasr City', address: 'Makram Ebeid', latitude: 30.0626, longitude: 31.3474, rating: 4.7, menu: []),
      Branch(id: '101-5', name: 'El Abd - Maadi', address: 'Road 9', latitude: 29.9602, longitude: 31.2569, rating: 4.8, menu: []),
      Branch(id: '101-6', name: 'El Abd - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.7, menu: []),
      Branch(id: '101-7', name: 'El Abd - 6th October', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.6, menu: []),
      Branch(id: '101-8', name: 'El Abd - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.7, menu: []),
      
      // New branches
      Branch(id: '101-9', name: 'El Abd - Dokki', address: 'Mesaha Square', latitude: 30.0444, longitude: 31.2000, rating: 4.7, menu: []),
      Branch(id: '101-10', name: 'El Abd - Sheikh Zayed', address: 'Arkan Plaza', latitude: 30.0272, longitude: 30.9700, rating: 4.8, menu: []),
      Branch(id: '101-11', name: 'El Abd - Tagamoa', address: 'Fifth Settlement', latitude: 30.0300, longitude: 31.4300, rating: 4.7, menu: []),
      Branch(id: '101-12', name: 'El Abd - Alexandria', address: 'San Stefano', latitude: 31.2357, longitude: 29.9602, rating: 4.8, menu: []),
      Branch(id: '101-13', name: 'El Abd - Rehab', address: 'Rehab City', latitude: 30.0600, longitude: 31.4900, rating: 4.6, menu: []),
      Branch(id: '101-14', name: 'El Abd - Madinaty', address: 'Madinaty', latitude: 30.0900, longitude: 31.6400, rating: 4.7, menu: []),
    ];
  }
}
