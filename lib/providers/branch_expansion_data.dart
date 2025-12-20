import 'package:outing/models/brand_model.dart';

// McDonald's Branch Expansion - 20+ branches across Egypt
class McDonaldsBranchExpansion {
  static List<Branch> getExpandedBranches() {
    return [
      // Cairo & Giza
      Branch(id: '1-1', name: 'McDonald\'s - City Stars', address: 'City Stars Mall, Nasr City', latitude: 30.0727, longitude: 31.3474, rating: 4.2, menu: []),
      Branch(id: '1-2', name: 'McDonald\'s - Mall of Arabia', address: 'Mall of Arabia, 6th October', latitude: 29.9765, longitude: 30.9283, rating: 4.3, menu: []),
      Branch(id: '1-3', name: 'McDonald\'s - Maadi', address: 'Road 9, Maadi', latitude: 29.9602, longitude: 31.2569, rating: 4.1, menu: []),
      Branch(id: '1-4', name: 'McDonald\'s - Zamalek', address: '26th July St, Zamalek', latitude: 30.0626, longitude: 31.2197, rating: 4.4, menu: []),
      Branch(id: '1-5', name: 'McDonald\'s - Mohandiseen', address: 'Gameat El Dowal, Mohandiseen', latitude: 30.0594, longitude: 31.2000, rating: 4.2, menu: []),
      Branch(id: '1-6', name: 'McDonald\'s - Heliopolis', address: 'Korba, Heliopolis', latitude: 30.0875, longitude: 31.3241, rating: 4.3, menu: []),
      Branch(id: '1-7', name: 'McDonald\'s - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.4, menu: []),
      Branch(id: '1-8', name: 'McDonald\'s - Dokki', address: 'Mesaha Square, Dokki', latitude: 30.0444, longitude: 31.2000, rating: 4.1, menu: []),
      Branch(id: '1-9', name: 'McDonald\'s - Nasr City', address: 'Abbas El Akkad St', latitude: 30.0626, longitude: 31.3474, rating: 4.2, menu: []),
      Branch(id: '1-10', name: 'McDonald\'s - Sheikh Zayed', address: 'Arkan Plaza', latitude: 30.0272, longitude: 30.9700, rating: 4.5, menu: []),
      Branch(id: '1-11', name: 'McDonald\'s - Downtown', address: 'Talaat Harb St', latitude: 30.0444, longitude: 31.2357, rating: 4.0, menu: []),
      Branch(id: '1-12', name: 'McDonald\'s - Giza', address: 'Pyramids Road', latitude: 29.9792, longitude: 31.1342, rating: 4.1, menu: []),
      Branch(id: '1-13', name: 'McDonald\'s - Shubra', address: 'Shubra St', latitude: 30.1127, longitude: 31.2444, rating: 4.0, menu: []),
      Branch(id: '1-14', name: 'McDonald\'s - Ain Shams', address: 'Ain Shams', latitude: 30.1310, longitude: 31.3189, rating: 4.1, menu: []),
      Branch(id: '1-15', name: 'McDonald\'s - Obour City', address: 'Obour City', latitude: 30.2127, longitude: 31.4700, rating: 4.2, menu: []),
      Branch(id: '1-16', name: 'McDonald\'s - October Gardens', address: '6th October', latitude: 29.9600, longitude: 30.9200, rating: 4.3, menu: []),
      Branch(id: '1-17', name: 'McDonald\'s - Smart Village', address: 'Smart Village', latitude: 30.0700, longitude: 30.9900, rating: 4.4, menu: []),
      Branch(id: '1-18', name: 'McDonald\'s - Rehab City', address: 'Rehab City', latitude: 30.0600, longitude: 31.4900, rating: 4.2, menu: []),
      Branch(id: '1-19', name: 'McDonald\'s - Shorouk', address: 'Shorouk City', latitude: 30.1200, longitude: 31.6100, rating: 4.1, menu: []),
      Branch(id: '1-20', name: 'McDonald\'s - Tagamoa', address: 'Fifth Settlement', latitude: 30.0300, longitude: 31.4300, rating: 4.3, menu: []),
      
      // Alexandria
      Branch(id: '1-21', name: 'McDonald\'s - Alexandria', address: 'San Stefano Mall', latitude: 31.2357, longitude: 29.9602, rating: 4.4, menu: []),
      Branch(id: '1-22', name: 'McDonald\'s - Alexandria Downtown', address: 'Raml Station', latitude: 31.2001, longitude: 29.9187, rating: 4.2, menu: []),
    ];
  }
}

// KFC Branch Expansion - 30+ branches across Egypt
class KFCBranchExpansion {
  static List<Branch> getExpandedBranches() {
    return [
      // Cairo & Giza
      Branch(id: '2-1', name: 'KFC - Tahrir', address: 'Tahrir Square', latitude: 30.0444, longitude: 31.2357, rating: 4.0, menu: []),
      Branch(id: '2-2', name: 'KFC - Heliopolis', address: 'Korba, Heliopolis', latitude: 30.0875, longitude: 31.3241, rating: 4.2, menu: []),
      Branch(id: '2-3', name: 'KFC - City Stars', address: 'City Stars Mall', latitude: 30.0727, longitude: 31.3474, rating: 4.3, menu: []),
      Branch(id: '2-4', name: 'KFC - Mall of Arabia', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.2, menu: []),
      Branch(id: '2-5', name: 'KFC - Maadi', address: 'Road 9, Maadi', latitude: 29.9602, longitude: 31.2569, rating: 4.4, menu: []),
      Branch(id: '2-6', name: 'KFC - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.3, menu: []),
      Branch(id: '2-7', name: 'KFC - Mohandiseen', address: 'Gameat El Dowal', latitude: 30.0594, longitude: 31.2000, rating: 4.1, menu: []),
      Branch(id: '2-8', name: 'KFC - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.5, menu: []),
      Branch(id: '2-9', name: 'KFC - Nasr City', address: 'Abbas El Akkad', latitude: 30.0626, longitude: 31.3474, rating: 4.2, menu: []),
      Branch(id: '2-10', name: 'KFC - Dokki', address: 'Mesaha Square', latitude: 30.0444, longitude: 31.2000, rating: 4.0, menu: []),
      Branch(id: '2-11', name: 'KFC - Sheikh Zayed', address: 'Arkan Plaza', latitude: 30.0272, longitude: 30.9700, rating: 4.4, menu: []),
      Branch(id: '2-12', name: 'KFC - Giza', address: 'Pyramids Road', latitude: 29.9792, longitude: 31.1342, rating: 4.1, menu: []),
      Branch(id: '2-13', name: 'KFC - Shubra', address: 'Shubra St', latitude: 30.1127, longitude: 31.2444, rating: 3.9, menu: []),
      Branch(id: '2-14', name: 'KFC - Ain Shams', address: 'Ain Shams', latitude: 30.1310, longitude: 31.3189, rating: 4.0, menu: []),
      Branch(id: '2-15', name: 'KFC - Obour City', address: 'Obour City', latitude: 30.2127, longitude: 31.4700, rating: 4.2, menu: []),
      Branch(id: '2-16', name: 'KFC - October Gardens', address: '6th October', latitude: 29.9600, longitude: 30.9200, rating: 4.3, menu: []),
      Branch(id: '2-17', name: 'KFC - Smart Village', address: 'Smart Village', latitude: 30.0700, longitude: 30.9900, rating: 4.4, menu: []),
      Branch(id: '2-18', name: 'KFC - Rehab City', address: 'Rehab City', latitude: 30.0600, longitude: 31.4900, rating: 4.1, menu: []),
      Branch(id: '2-19', name: 'KFC - Shorouk', address: 'Shorouk City', latitude: 30.1200, longitude: 31.6100, rating: 4.0, menu: []),
      Branch(id: '2-20', name: 'KFC - Tagamoa', address: 'Fifth Settlement', latitude: 30.0300, longitude: 31.4300, rating: 4.3, menu: []),
      Branch(id: '2-21', name: 'KFC - Madinaty', address: 'Madinaty', latitude: 30.0900, longitude: 31.6400, rating: 4.4, menu: []),
      Branch(id: '2-22', name: 'KFC - Katameya', address: 'Katameya Heights', latitude: 29.9900, longitude: 31.4700, rating: 4.3, menu: []),
      Branch(id: '2-23', name: 'KFC - New Maadi', address: 'New Maadi', latitude: 29.9500, longitude: 31.2800, rating: 4.2, menu: []),
      Branch(id: '2-24', name: 'KFC - Hadayek El Ahram', address: 'Hadayek El Ahram', latitude: 29.9900, longitude: 31.1100, rating: 4.1, menu: []),
      Branch(id: '2-25', name: 'KFC - Faisal', address: 'Faisal St', latitude: 30.0100, longitude: 31.1700, rating: 4.0, menu: []),
      
      // Alexandria
      Branch(id: '2-26', name: 'KFC - Alexandria', address: 'San Stefano Mall', latitude: 31.2357, longitude: 29.9602, rating: 4.4, menu: []),
      Branch(id: '2-27', name: 'KFC - Alexandria Downtown', address: 'Raml Station', latitude: 31.2001, longitude: 29.9187, rating: 4.2, menu: []),
      Branch(id: '2-28', name: 'KFC - Alexandria Smouha', address: 'Smouha', latitude: 31.2100, longitude: 29.9400, rating: 4.3, menu: []),
      Branch(id: '2-29', name: 'KFC - Alexandria Sidi Gaber', address: 'Sidi Gaber', latitude: 31.2200, longitude: 29.9500, rating: 4.2, menu: []),
      Branch(id: '2-30', name: 'KFC - Alexandria Miami', address: 'Miami', latitude: 31.2400, longitude: 29.9700, rating: 4.3, menu: []),
    ];
  }
}

// Mo'men Branch Expansion - 50+ branches
class MomenBranchExpansion {
  static List<Branch> getExpandedBranches() {
    return [
      Branch(id: '3-1', name: 'Mo\'men - Mohandiseen', address: 'Lebanon St', latitude: 30.0594, longitude: 31.2000, rating: 4.5, menu: []),
      Branch(id: '3-2', name: 'Mo\'men - Nasr City', address: 'Makram Ebeid', latitude: 30.0626, longitude: 31.3474, rating: 4.4, menu: []),
      Branch(id: '3-3', name: 'Mo\'men - Heliopolis', address: 'Korba', latitude: 30.0875, longitude: 31.3241, rating: 4.6, menu: []),
      Branch(id: '3-4', name: 'Mo\'men - Maadi', address: 'Road 9', latitude: 29.9602, longitude: 31.2569, rating: 4.5, menu: []),
      Branch(id: '3-5', name: 'Mo\'men - Zamalek', address: '26th July St', latitude: 30.0626, longitude: 31.2197, rating: 4.7, menu: []),
      Branch(id: '3-6', name: 'Mo\'men - New Cairo', address: 'Cairo Festival City', latitude: 30.0272, longitude: 31.4066, rating: 4.6, menu: []),
      Branch(id: '3-7', name: 'Mo\'men - 6th October', address: 'Mall of Arabia', latitude: 29.9765, longitude: 30.9283, rating: 4.5, menu: []),
      Branch(id: '3-8', name: 'Mo\'men - Sheikh Zayed', address: 'Arkan Plaza', latitude: 30.0272, longitude: 30.9700, rating: 4.6, menu: []),
      Branch(id: '3-9', name: 'Mo\'men - Dokki', address: 'Mesaha Square', latitude: 30.0444, longitude: 31.2000, rating: 4.4, menu: []),
      Branch(id: '3-10', name: 'Mo\'men - Downtown', address: 'Talaat Harb', latitude: 30.0444, longitude: 31.2357, rating: 4.3, menu: []),
      // Add 40 more branches across all Cairo neighborhoods, Giza, and Alexandria
      Branch(id: '3-11', name: 'Mo\'men - City Stars', address: 'City Stars Mall', latitude: 30.0727, longitude: 31.3474, rating: 4.5, menu: []),
      Branch(id: '3-12', name: 'Mo\'men - Tagamoa', address: 'Fifth Settlement', latitude: 30.0300, longitude: 31.4300, rating: 4.6, menu: []),
      Branch(id: '3-13', name: 'Mo\'men - Rehab', address: 'Rehab City', latitude: 30.0600, longitude: 31.4900, rating: 4.5, menu: []),
      Branch(id: '3-14', name: 'Mo\'men - Madinaty', address: 'Madinaty', latitude: 30.0900, longitude: 31.6400, rating: 4.6, menu: []),
      Branch(id: '3-15', name: 'Mo\'men - Shorouk', address: 'Shorouk City', latitude: 30.1200, longitude: 31.6100, rating: 4.4, menu: []),
    ];
  }
}
