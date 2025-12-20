import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SmartPlannerService {
  static const String _baseUrl = 'http://10.0.2.2:5000/api/smart-planner';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Map<String, dynamic>>> getFilteredPlaces({
    required double minPrice,
    required double maxPrice,
    String? category,
    String? search,
  }) async {
    try {
      final token = await _getToken();
      final queryParams = {
        'minPrice': minPrice.toString(),
        'maxPrice': maxPrice.toString(),
        if (category != null) 'category': category,
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final uri = Uri.parse('$_baseUrl/filter').replace(queryParameters: queryParams);
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Error fetching filtered places: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> generateSmartPlan({
    required double totalBudget,
    required double minPrice,
    required double maxPrice,
    List<String>? preferences,
  }) async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('$_baseUrl/generate-plan'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'totalBudget': totalBudget,
          'minPrice': minPrice,
          'maxPrice': maxPrice,
          'preferences': preferences ?? [],
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error generating smart plan: $e');
      return null;
    }
  }

  Future<String> chatWithAI({
    required String message,
    double? userBudget,
    List<Map<String, dynamic>>? currentPlan,
  }) async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('$_baseUrl/ai-chat'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'message': message,
          'userBudget': userBudget,
          'currentPlan': currentPlan,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response'] ?? 'عذراً، لم أستطع فهم طلبك';
      }
      return 'حدث خطأ في الاتصال';
    } catch (e) {
      print('Error in AI chat: $e');
      return 'عذراً، حدث خطأ';
    }
  }
}
