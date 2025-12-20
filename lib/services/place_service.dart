
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:outing/models/place.dart';

class PlaceService {
  final String _baseUrl = 'http://10.0.2.2:5000/api/places';

  Future<void> updatePlace(String id, String name, String address, String token) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      body: jsonEncode({'name': name, 'address': address}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update place');
    }
  }

  Future<void> deletePlace(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete place');
    }
  }

  Future<void> createPlace(String name, String address, String token) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      body: jsonEncode({'name': name, 'address': address}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create place');
    }
  }

  Future<List<Place>> getPlaces() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Place.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load places');
    }
  }
}
