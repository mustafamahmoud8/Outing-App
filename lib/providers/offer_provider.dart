
import 'package:flutter/material.dart';
import 'package:outing/models/offer.dart';
import 'package:outing/services/offer_service.dart';
import 'package:outing/providers/auth_provider.dart';

class OfferProvider with ChangeNotifier {
  final OfferService _offerService = OfferService();
  final AuthProvider _authProvider;
  List<Offer> _offers = [];

  List<Offer> get offers => _offers;

  OfferProvider(this._authProvider);

  Future<void> updateOffer(String id, String title, String description) async {
    try {
      await _offerService.updateOffer(id, title, description, _authProvider.token!);
      getOffers();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteOffer(String id) async {
    try {
      await _offerService.deleteOffer(id, _authProvider.token!);
      getOffers();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> createOffer(String title, String description) async {
    try {
      await _offerService.createOffer(title, description, _authProvider.token!);
      getOffers();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> getOffers() async {
    try {
      _offers = await _offerService.getOffers();
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }
}
