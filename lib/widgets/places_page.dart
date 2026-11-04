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

  final List<String> islands = [
    'Tenerife',
    'Gran Canaria',
    'Lanzarote',
    'Fuerteventura',
    'La Palma',
    'La Gomera',
    'El Hierro',
    'La Graciosa',
  ];

  final List<String> categories = ['Playas', 'Restaurante', 'Sendero'];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String selectedIsland = 'Tenerife';
  String selectedCategory = 'Playas';

  void _showAddPlaceDialog() {
    nameController.clear();
    descriptionController.clear();
    selectedIsland = 'Tenerife';
    selectedCategory = 'Playas';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add a new place'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.place)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Description', prefixIcon: Icon(Icons.description)),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedIsland,
                      decoration: const InputDecoration(labelText: 'Island'),
                      items: islands.map((island) {
                        return DropdownMenuItem(value: island, child: Text(island));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedIsland = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: categories.map((category) {
                        return DropdownMenuItem(value: category, child: Text(category));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedCategory = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty || descriptionController.text.trim().isEmpty) {
                      return;
                    }

                    setState(() {
                      places.add(
                        PlaceItem(
                          name: nameController.text.trim(),
                          description: descriptionController.text.trim(),
                          island: selectedIsland,
                          category: selectedCategory,
                        ),
                      );
                    });

                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteAllDialog() {
    if (places.isEmpty) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete all places?'),
          content: const Text(
            'Are you sure you want to delete all places? '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  places.clear();
                });

                Navigator.pop(dialogContext);
              },
              child: const Text('Delete All'),
            ),
          ],
        );
      },
    );
  }

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
                    const Icon(Icons.place, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Total places: ${places.length}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: places.isEmpty
                ? const Center(
                    child: Text('No places added yet.', style: TextStyle(fontSize: 16, color: textColor)),
                  )
                : ListView.builder(
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      final place = places[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.location_on, color: primaryColor),
                          title: Text(place.name),
                          subtitle: Text(
                            '${place.description}\n'
                            '${place.island} - ${place.category}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                places.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _showDeleteAllDialog,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.delete_sweep),
            label: const Text('Delete All'),
          ),
          const SizedBox(width: 12),
          FloatingActionButton.extended(
            onPressed: _showAddPlaceDialog,
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Add Place'),
          ),
        ],
      ),
    );
  }
}
