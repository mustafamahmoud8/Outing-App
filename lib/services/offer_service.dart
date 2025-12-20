
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:outing/models/offer.dart';

class OfferService {
  final String _baseUrl = 'http://10.0.2.2:5000/api/offers';

  Future<void> updateOffer(String id, String title, String description, String token) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      body: jsonEncode({'title': title, 'description': description}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update offer');
    }
  }

  Future<void> deleteOffer(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete offer');
    }
  }

  Future<void> createOffer(String title, String description, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create'),
      body: jsonEncode({'title': title, 'description': description}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create offer');
    }
  }

  Future<List<Offer>> getOffers() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Offer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load offers');
    }
  }
}
