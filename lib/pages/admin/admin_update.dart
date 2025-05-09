import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_one/pokemon.dart';
import '../drawer/drawer_header.dart';
import '../drawer/drawer_list_view.dart';
import 'admin_body.dart';

class UpdatePokemonScreen extends StatefulWidget {
  final int pokemonId;

  const UpdatePokemonScreen({
    super.key,
    required this.pokemonId,
  });

  @override
  State<UpdatePokemonScreen> createState() => _UpdatePokemonScreenState();
}

class _UpdatePokemonScreenState extends State<UpdatePokemonScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _nickname;
  late TextEditingController _description;
  late TextEditingController _imageUrl;
  late Future<List<Pokemon>> futurePokemonList;
  int _hp = 0;
  int _atk = 0;
  int _def = 0;
  String _pokemonName = '';
  String _pokemonType = '';

  Future<void> updatePokemonData() async {
    try {
      // Construct update map
      final updateData = {
        'nickname': _nickname.text.trim(),
        'description': _description.text.trim(),
        'hp': _hp,
        'atk': _atk,
        'def': _def,
        'imageUrl': _imageUrl.text.trim(),
      };
      final querySnapshot = await FirebaseFirestore.instance
          .collection('pokemonRegistrations')
          .where('pokemonId', isEqualTo: widget.pokemonId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update(updateData);
        debugPrint("Pokémon data updated successfully.");
      } else {
        debugPrint("No Pokémon found with the given ID.");
      }
    } catch (e) {
      debugPrint("Error updating Pokémon: $e");
    }
  }

  void fetchPokemon() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('pokemonRegistrations')
        .where('pokemonId', isEqualTo: widget.pokemonId)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();

      // You can now access and set state here if needed
      setState(() {
        _pokemonName = data['pokemonName'] ?? '';
        _pokemonType = data['type'] ?? '';
        _nickname.text = data['nickname'] ?? '';
        _description.text = data['description'] ?? '';
        _imageUrl.text = data['imageUrl'] ?? '';
        _hp = data['hp'] ?? 0;
        _atk = data['atk'] ?? 0;
        _def = data['def'] ?? 0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nickname = TextEditingController();
    _description = TextEditingController();
    _imageUrl = TextEditingController();
    fetchPokemon();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nickname.dispose();
    _description.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Pokemon",
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
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Forces sharp 90° corners
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrwHeader(),
            DrwListView(currentRoute: "/admin"),
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
        ),
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
                      // Pokemon Image Card
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
                                return _buildDefaultPokemonIcon();
                              },
                            )
                                : _buildDefaultPokemonIcon(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      // Pokemon Name Display (non-editable)
                      if (_pokemonName.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Pokémon: ${_pokemonName[0].toUpperCase() + _pokemonName.substring(1)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),

                      // Image URL Field
                      const Text(
                        'Image URL',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextFormField(
                        controller: _imageUrl,
                        keyboardType: TextInputType.url,
                        style: const TextStyle(color: Colors.black),
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
                          hintText: "https://example.com/pokemon.jpg",
                          hintStyle: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black54),
                        ),
                        onChanged: (value) {
                          // Update the UI when URL changes
                          setState(() {});
                        },
                      ),

                      const SizedBox(height: 8),
                      const Text(
                        'Change nickname',
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
                            return 'Nickname cannot be empty';
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
                      _buildStatsBar('HP', _hp),
                      const SizedBox(height: 8),
                      _buildStatsBar('ATK', _atk),
                      const SizedBox(height: 8),
                      _buildStatsBar('DEF', _def),
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
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await updatePokemonData();
                                  if (!mounted) return;
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const PokemonAdminApp()),
                                  );
                                }
                              },
                              child: const Text(
                                'Update',
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