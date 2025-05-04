import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:math';
import 'admin_body.dart';
import 'package:image_picker/image_picker.dart';



class AddPokemonScreen extends StatefulWidget {
  final Function(Pokemon) onPokemonAdded;

  const AddPokemonScreen({super.key, required this.onPokemonAdded});

  @override
  State<AddPokemonScreen> createState() => _AddPokemonScreenState();
}

class _AddPokemonScreenState extends State<AddPokemonScreen> {
  Uint8List? _customImageBytes;
  final _formKey = GlobalKey<FormState>();
  final List<String> _availablePokemon = [
    'Pikachu',
    'Charizard',
    'Bulbasaur',
    'Squirtle',
    'Eevee',
    'Mewtwo',
    'Gyarados',
    'Gengar',
    'Dragonite',
    'Snorlax',
  ];
  String? _selectedPokemon;

  // Random stats generator
  final Random _random = Random();

  File? _selectedImageFile; // New: stores the custom image
  // New: picker instance

  int _generateRandomStat() {
    return _random.nextInt(100) + 10; // Generates a value between 30 and 100
  }
  int _generateRandomAge() {
    return _random.nextInt(12) + 8;
  }

  Future<void> _pickImage() async {

    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _customImageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF77FF86), // Light green background
        child: Column(
          children: [
            _buildAppBar('Register a Pokemon'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.black,
                                    width: 1.5
                                )
                            ),
                            child: _customImageBytes != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                _customImageBytes!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                                : Center(
                              child: Image.asset(
                                'assets/unknown_pokemon.png',
                                width: 120,
                                height: 120,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.catching_pokemon,
                                    size: 120,
                                    color: Colors.grey[800],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Select a Pokemon',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        value: _selectedPokemon,
                        hint: Text('(e.g. Pikachu or Eevee)'),
                        items: _availablePokemon.map((String pokemon) {
                          return DropdownMenuItem<String>(
                            value: pokemon,
                            child: Text(pokemon),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPokemon = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a Pokemon';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildStatsBar('HP', _generateRandomStat()),
                      const SizedBox(height: 8),
                      _buildStatsBar('ATK', _generateRandomStat()),
                      const SizedBox(height: 8),
                      _buildStatsBar('DEF', _generateRandomStat()),
                      const SizedBox(height: 8),
                      _buildStatsBar('SPD', _generateRandomStat()),
                      const SizedBox(height: 8),
                      _buildStatsBar('AGE', _generateRandomAge()),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final newPokemon = Pokemon(
                                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                                    name: _selectedPokemon!,
                                    types: _getTypeForPokemon(_selectedPokemon!),
                                    imageUrl: _selectedImageFile?.path ?? _getImageForPokemon(_selectedPokemon!),
                                    hp: _generateRandomStat(),
                                    atk: _generateRandomStat(),
                                    def: _generateRandomStat(),
                                    spd: _generateRandomStat(),
                                    age: _generateRandomAge(),
                                  );
                                  widget.onPokemonAdded(newPokemon);
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text(
                                'Add Pokemon',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(String title) {
    return Container(
      padding: const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 16),
      child: Row(
        children: [
          Icon(Icons.menu, color: Colors.black),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar(String label, int value) {
    return Row(
      children: [
        SizedBox(
          width: 30,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.grey[300],
              color: Colors.black,
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }


  List<String> _getTypeForPokemon(String name) {
    // Map Pokemon names to their types (as a list)
    final types = {
      'Pikachu': ['Electric'],
      'Charizard': ['Fire', 'Flying'],
      'Bulbasaur': ['Grass', 'Poison'],
      'Squirtle': ['Water'],
      'Eevee': ['Normal'],
      'Mewtwo': ['Psychic'],
      'Gyarados': ['Water', 'Flying'],
      'Gengar': ['Ghost', 'Poison'],
      'Dragonite': ['Dragon', 'Flying'],
      'Snorlax': ['Normal'],
    };
    return types[name] ?? ['Unknown'];
  }

  String _getImageForPokemon(String name) {
    // Map Pokemon names to their image URLs
    // For actual implementation, you'd use real image URLs
    final images = {
      'Pikachu': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
      'Charizard': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/6.png',
      'Bulbasaur': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
      'Squirtle': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png',
      'Eevee': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/133.png',
      'Mewtwo': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/150.png',
      'Gyarados': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/130.png',
      'Gengar': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/94.png',
      'Dragonite': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/149.png',
      'Snorlax': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/143.png',
    };
    return images[name] ?? 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/0.png';
  }
}
