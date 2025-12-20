class ApiConfig {
  // Base URLs
  // للتطوير (Android Emulator)
  static const String baseUrl = 'http://10.0.2.2:5000';
  
  // للتطوير (iOS Simulator)
  // static const String baseUrl = 'http://localhost:5000';
  
  // للإنتاج
  // static const String baseUrl = 'https://your-production-api.com';
  
  // Endpoints
  static const String authEndpoint = '$baseUrl/auth';
  static const String apiEndpoint = '$baseUrl/api';
  
  // Specific API paths
  static const String placesPath = '/api/places';
  static const String offersPath = '/api/offers';
  static const String chatsPath = '/api/chats';
  static const String plansPath = '/api/plans';
  static const String aiConversationsPath = '/api/ai-conversations';
  static const String smartPlannerPath = '/api/smart-planner';
  static const String budgetPath = '/api/budget';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // API Version
  static const String apiVersion = 'v1';
  
  // Debug mode
  static const bool debugMode = true;
}
