
import 'package:flutter/material.dart';
import 'package:outing/models/place.dart';
import 'package:outing/services/place_service.dart';
import 'package:outing/providers/auth_provider.dart';

class PlaceProvider with ChangeNotifier {
  final PlaceService _placeService = PlaceService();
  final AuthProvider _authProvider;
  List<Place> _places = [];

  List<Place> get places => _places;

  PlaceProvider(this._authProvider);

  Future<void> deletePlace(String id) async {
    try {
      await _placeService.deletePlace(id, _authProvider.token!);
      getPlaces();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> createPlace(String name, String address) async {
    try {
      await _placeService.createPlace(name, address, _authProvider.token!);
      getPlaces();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> getPlaces() async {
    try {
      _places = await _placeService.getPlaces();
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }
}
