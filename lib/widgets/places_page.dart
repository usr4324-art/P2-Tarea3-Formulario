
import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'place_item.dart';

const Color primaryColor = Color(0xFF1565C0);
const Color secondaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFF5F7FA);
const Color textColor = Color(0xFF212121);

class PlacesPage extends StatefulWidget {
  const PlacesPage({super.key});

  @override
  State<PlacesPage> createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {
  final List<PlaceItem> places = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Places of the Canary Islands'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.place,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Total places: ${places.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: places.isEmpty
                ? const Center(
                    child: Text(
                      'No places added yet.',
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      final place = places[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.location_on,
                            color: primaryColor,
                          ),
                          title: Text(place.name),
                          subtitle: Text(
                            '${place.description}\n'
                            '${place.island} - ${place.category}',
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
