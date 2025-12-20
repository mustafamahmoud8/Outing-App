import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  final String _baseUrl = 'http://10.0.2.2:5000/api/ai-conversations';

  Future<Map<String, dynamic>> createConversation(String token) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create conversation');
    }
  }

  Future<Map<String, dynamic>> sendMessage(String conversationId, String message, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$conversationId/messages'),
      body: jsonEncode({'message': message}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send message');
    }
  }

  Future<List<dynamic>> getUserConversations(String token) async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['conversations'];
    } else {
      throw Exception('Failed to load conversations');
    }
  }

  Future<List<dynamic>> getUserPlans(String token) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/api/plans'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['plans'] ?? [];
    } else {
      throw Exception('Failed to load plans');
    }
  }
}
