
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outing/providers/place_provider.dart';
import 'package:outing/views/create_place_screen.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<PlaceProvider>(context, listen: false).getPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Places'),
      ),
      body: Consumer<PlaceProvider>(
        builder: (context, placeProvider, _) {
          if (placeProvider.places.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: placeProvider.places.length,
            itemBuilder: (context, index) {
              final place = placeProvider.places[index];
              return ListTile(
                title: Text(place.name),
                subtitle: Text(place.address),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<PlaceProvider>(context, listen: false).deletePlace(place.id);
                  },
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
              builder: (context) => const CreatePlaceScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
