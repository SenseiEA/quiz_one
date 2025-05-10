import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../drawer/drawer_header.dart';
import '../drawer/drawer_list_view.dart';
import 'admin_body.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_one/pokeapi_service.dart';
import 'package:quiz_one/pokemon.dart';




class AddPokemonScreen extends StatefulWidget {
  //final Function(Pokemon) onPokemonAdded;

  const AddPokemonScreen({super.key}); //, required this.onPokemonAdded

  @override
  State<AddPokemonScreen> createState() => _AddPokemonScreenState();
}

class _AddPokemonScreenState extends State<AddPokemonScreen> {
  Uint8List? _customImageBytes;
  final _formKey = GlobalKey<FormState>();
  String? _selectedPokemon;
  String? _selectedType;
  String? _selectedImageUrl;

  // Random stats generator
  final Random _random = Random();

  File? _selectedImageFile; // New: stores the custom image

  int _generateRandomStat() {
    return _random.nextInt(100) + 10; // Generates a value between 30 and 100
  }
  late Future<List<Pokemon>> futurePokemonList;
  final TextEditingController _pokemonName = TextEditingController();
  final TextEditingController _nickname = TextEditingController();
  final TextEditingController _type = TextEditingController();
  final TextEditingController _hp = TextEditingController();
  final TextEditingController _atk = TextEditingController();
  final TextEditingController _def = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _imageUrl = TextEditingController();

  Future<void> addPokemonData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('pokemonRegistrations')
          .orderBy('pokemonId', descending: true)
          .limit(1)
          .get();

      int newId = 1; // Default if no Pokémon exist

      if (snapshot.docs.isNotEmpty) {
        final highestId = snapshot.docs.first.data()['pokemonId'] ?? 0;
        newId = highestId + 1;
      }

      final pokemonData = {
        "pokemonId": newId,
        "pokemonName": _selectedPokemon,
        "nickname": _nickname.text,
        "type": _selectedType,
        "hp": int.tryParse(_hp.text) ?? 0,
        "atk": int.tryParse(_atk.text) ?? 0,
        "def": int.tryParse(_def.text) ?? 0,
        "description": _description.text,
        "imageUrl": _imageUrl.text.isNotEmpty ? _imageUrl.text : _selectedImageUrl ?? '',
      };

      try {
        await FirebaseFirestore.instance.collection('pokemonRegistrations').add(pokemonData);
        print("Pokémon data added successfully!");
      } catch (e) {
        print("Failed to add Pokémon data: $e");
      }

    } catch (e) {
      print("Failed to add Pokémon data: $e");
    }

  }

  @override
  void initState() {
    super.initState();

    // Generate and pre-fill stats
    final hpValue = _generateRandomStat();
    final atkValue = _generateRandomStat();
    final defValue = _generateRandomStat();

    _hp.text = hpValue.toString();
    _atk.text = atkValue.toString();
    _def.text = defValue.toString();
    futurePokemonList = PokeApiService().fetchPokemonList(50);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      drawer: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Forces sharp 90° corners
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrwHeader(),
            DrwListView(currentRoute: "/admin"),//Replace "home" with current route
          ],
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF35FF89),
              Colors.white
            ],
          ),
        ),// Light green background
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: _imageUrl.text.isNotEmpty
                                ? Image.network(
                              _imageUrl.text,
                              width: 120,
                              height: 100,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildPokemonImageWithFallback(_selectedImageUrl);
                              },
                            )
                                : _buildPokemonImageWithFallback(_selectedImageUrl),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Text(
                        'Or enter image URL',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextFormField(
                        controller: _imageUrl,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'https://example.com/pokemon.jpg',
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Select a Pokemon',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      // dropdown of pokemon using PokeAPI below, guys
                      FutureBuilder<List<Pokemon>>(
                        future: futurePokemonList,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No Pokémon found.'));
                          } else {
                            final pokemonList = snapshot.data!..sort((a, b) => a.name.compareTo(b.name));
                            return DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              value: _selectedPokemon,
                              items: pokemonList
                                  .map((pokemon) => DropdownMenuItem<String>(
                                value: pokemon.name,
                                child: Text(
                                  '${pokemon.name[0].toUpperCase()}${pokemon.name.substring(1)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ))
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedPokemon = newValue;
                                  final selectedPokemon = pokemonList.firstWhere(
                                        (pokemon) => pokemon.name.toLowerCase() == _selectedPokemon?.toLowerCase(),
                                  );
                                  _selectedType = selectedPokemon.type;
                                  _selectedImageUrl = selectedPokemon.image;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a Pokemon';
                                }
                                return null;
                              },
                              // Customize dropdown appearance
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              // Limit dropdown menu height
                              menuMaxHeight: 300,
                              // Style the dropdown menu items
                              dropdownColor: Colors.white,
                              // Make dropdown button smaller
                              isDense: true,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Nickname the Pokemon',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextFormField(
                        controller: _nickname,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: Colors.black),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a nickname';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.amber, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.amber, width: 2),
                          ),
                          hintText: "Nickname...",
                          hintStyle: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextFormField(
                        controller: _description,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(color: Colors.black),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.amber, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.amber, width: 2),
                          ),
                          hintText: "Write a description...",
                          hintStyle: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildStatsBar('HP', _generateRandomStat()),
                      const SizedBox(height: 8),
                      _buildStatsBar('ATK', _generateRandomStat()),
                      const SizedBox(height: 8),
                      _buildStatsBar('DEF', _generateRandomStat()),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(  // Add Expanded to Cancel button
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
                          Expanded(  // Add Expanded to Register button
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await addPokemonData();
                                  if (!mounted) return;
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const PokemonAdminApp()),
                                  );
                                }
                              },
                              child: const Text(
                                'Register',
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
  PreferredSizeWidget _appBar(){
    return AppBar(
      title: const Text(
        "Registered Pokemon",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'DM-Sans'
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.blue,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [const Color(0xFF35FF89), Colors.white],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft
            )
        ),
      ),
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }
  Widget _buildPokemonImageWithFallback(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: 120,
        height: 100,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultPokemonIcon();
        },
      );
    }
    return _buildDefaultPokemonIcon();
  }
  Widget _buildDefaultPokemonIcon() {
    return Image.asset(
      'assets/unknown_pokemon.png',
      width: 120,
      height: 100,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.catching_pokemon,
          size: 120,
          color: Colors.grey[800],
        );
      },
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

}