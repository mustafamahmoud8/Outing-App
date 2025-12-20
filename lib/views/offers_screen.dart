
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outing/providers/offer_provider.dart';
import 'package:outing/views/create_offer_screen.dart';
import 'package:outing/views/edit_offer_screen.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<OfferProvider>(context, listen: false).getOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers'),
      ),
      body: Consumer<OfferProvider>(
        builder: (context, offerProvider, _) {
          if (offerProvider.offers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: offerProvider.offers.length,
            itemBuilder: (context, index) {
              final offer = offerProvider.offers[index];
              return ListTile(
                title: Text(offer.title),
                subtitle: Text(offer.description),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditOfferScreen(offer: offer),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditOfferScreen(offer: offer),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        Provider.of<OfferProvider>(context, listen: false).deleteOffer(offer.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateOfferScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
