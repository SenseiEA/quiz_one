import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_one/pokeapi_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_one/pokemon.dart';
import 'package:quiz_one/pages/drawer/drawer_header.dart';
import 'package:quiz_one/pages/drawer/drawer_list_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  Uint8List? _customImageBytes;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _nickname;
  late TextEditingController _description;
  late Future<List<Pokemon>> futurePokemonList;
  int _hp = 0;
  int _atk = 0;
  int _def = 0;

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

  Future<void> updatePokemonData() async {
    try {
      // Construct update map
      final updateData = {
        'nickname': _nickname.text.trim(),
        'description': _description.text.trim(),
        'hp': _hp,
        'atk': _atk,
        'def': _def,
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
        _nickname.text = data['nickname'] ?? '';
        _description.text = data['description'] ?? '';
        _hp = data['hp'] ?? 0;
        _atk = data['atk'] ?? 0;
        _def = data['def'] ?? 0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();//text: widget.pokemon.name
    _nickname = TextEditingController();
    _description = TextEditingController();
    fetchPokemon();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nickname.dispose();
    super.dispose();
  }

  // Widget _buildPokemonImage() {
  //   // Check if we have a new image selected first
  //   if (_customImageBytes != null) {
  //     return Image.memory(
  //       _customImageBytes!,
  //       width: double.infinity,
  //       height: double.infinity,
  //       fit: BoxFit.cover,
  //     );
  //   } else if (widget.pokemon.isCustomImage) {
  //     // Handle binary data (custom uploaded image)
  //     return Image.memory(
  //       widget.pokemon.imageUrl as Uint8List,
  //       width: double.infinity,
  //       height: double.infinity,
  //       fit: BoxFit.cover,
  //     );
  //   } else {
  //     // Handle URL string (default image)
  //     return Image.network(
  //       widget.pokemon.imageUrl as String,
  //       width: double.infinity,
  //       height: double.infinity,
  //       fit: BoxFit.cover,
  //       errorBuilder: (context, error, stackTrace) {
  //         return Icon(
  //           Icons.catching_pokemon,
  //           size: 120,
  //           color: Colors.grey[800],
  //         );
  //       },
  //     );
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Pokemon",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'DM-Sans'
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
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
        ), // Light green background
        child: Column(
          children: [
            _buildAppBar('Update a Pokemon'),
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
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              // child:  _selectedImageFile != null
                              //     ? Image.file(
                              //   _selectedImageFile!,
                              //   width: 120,
                              //   height: 100,
                              //   fit: BoxFit.contain,
                              // )
                              //     : Image.asset(
                              //   'assets/unknown_pokemon.png',
                              //   width: 120,
                              //   height: 100,
                              //   fit: BoxFit.contain,
                              //   errorBuilder: (context, error, stackTrace) {
                              //     return Icon(
                              //       Icons.catching_pokemon,
                              //       size: 120,
                              //       color: Colors.grey[800],
                              //     );
                              //   },
                              // ),
                            ),
                          ),
                        ),
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
                                    MaterialPageRoute(builder: (context) => const PokemonAdminApp()), // Change to your actual widget
                                  );
                                }
                                // if (_formKey.currentState!.validate()) {
                                //   final updatedPokemon = Pokemon(
                                //     id: widget.pokemon.id,
                                //     name: _nameController.text,
                                //     nickname: _nameController.text,
                                //     types: widget.pokemon.types,
                                //     imageUrl: widget.pokemon.imageUrl,
                                //     hp: widget.pokemon.hp,
                                //     atk: widget.pokemon.atk,
                                //     def: widget.pokemon.def
                                //   );
                                //   widget.onPokemonUpdated(updatedPokemon);
                                //   Navigator.pop(context);
                                // }
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
}