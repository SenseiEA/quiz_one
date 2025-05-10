import 'package:flutter/material.dart';
import 'dart:math';
import 'package:quiz_one/pages/drawer/drawer_header.dart';
import 'package:quiz_one/pages/drawer/drawer_list_view.dart';
import 'package:quiz_one/main.dart';
import 'admin_delete.dart';
import 'admin_create.dart';
import 'admin_update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const PokemonAdminApp());
}

class PokemonAdminApp extends StatelessWidget {
  const PokemonAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokemon Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent
        ),
      ),
      home: const PokemonListScreen(),

    );
  }
}

class _Pokemon {
  final String id;
  String name;
  String nickname;
  final List<String> types;
  final String imageUrl;
  int hp;
  int atk;
  int def;
  String description;

  _Pokemon({
    required this.id,
    required this.name,
    required this.nickname,
    required this.types,
    required this.imageUrl,
    required this.hp,
    required this.atk,
    required this.def,
    required this.description,
  });
}

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {

  Color _getColorForType(String type) {
    final colors = {
      'Normal': Colors.grey[400],
      'Fire': Colors.orange,
      'Water': Colors.blue,
      'Electric': Colors.amber,
      'Grass': Colors.green,
      'Ice': Colors.cyan,
      'Fighting': Colors.brown,
      'Poison': Colors.purple,
      'Ground': Colors.brown[300],
      'Flying': Colors.indigo[200],
      'Psychic': Colors.pink,
      'Bug': Colors.lightGreen,
      'Rock': Colors.grey,
      'Ghost': Colors.indigo,
      'Dragon': Colors.indigo[400],
      'Dark': Colors.grey[800],
      'Steel': Colors.blueGrey,
      'Fairy': Colors.pinkAccent[100],
    };

    return colors[type] ?? Colors.grey;
  }
  final List<_Pokemon> _pokemons = [];

  void fetchPokemons() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('pokemonRegistrations').get();

      setState(() {
        _pokemons.clear();
        for (var doc in snapshot.docs) {
          final data = doc.data();
          // Get the image URL from Firestore or use default
          String imageUrl = data['imageUrl'] ??
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png';

          // Validate URL format
          if (!(imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))) {
            imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png';
          }

          _pokemons.add(
            _Pokemon(
              id: data['pokemonId'].toString(),
              name: data['pokemonName'],
              nickname: data['nickname'],
              types: [data['type'][0].toUpperCase() + data['type'].substring(1)],
              imageUrl: imageUrl,
              hp: data['hp'],
              atk: data['atk'],
              def: data['def'],
              description: data['description'],
            ),
          );
        }
      });
    } catch (e) {
      debugPrint('Error fetching pokemon: $e');
      // Consider showing a snackbar or alert to the user
    }
  }

  Future<void> deletePokemon(int id) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('pokemonRegistrations')
          .where('pokemonId', isEqualTo: id)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        String nickname = '';
        final data = snapshot.docs.first.data();
        if (data.containsKey('nickname')) {
          nickname = data['nickname'];
        }
        await snapshot.docs.first.reference.delete();
        _showToast('${nickname.isNotEmpty ? '"$nickname"' : 'Pokémon #$id'} deleted successfully!');
        debugPrint("Pokémon with ID $id deleted successfully.");
        // Optionally refresh the list
        fetchPokemons();
      } else {
        debugPrint("No Pokémon found with ID $id.");
        _showToast('No Pokémon found with ID $id', isError: true);
      }
    } catch (e) {
      debugPrint("Error deleting Pokémon: $e");
      _showToast('Failed to delete Pokémon: ${e.toString()}', isError: true);
    }
  }

  void _showToast(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: isError ? 4 : 2),
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    fetchPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _pokemons.length,
                itemBuilder: (context, index) {
                  final pokemon = _pokemons[index];
                  return  Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: pokemon.imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            ...pokemon.types.map((type) =>
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  margin: const EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                    color: _getColorForType(type),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.5
                                    )
                                  ),
                                  child: Text(
                                    type.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ).toList(),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pokemon.nickname,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text("#${pokemon.id} · ${pokemon.name}"),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            _showActionSheet(context, pokemon);
                          },
                        ),
                      ),
                    );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPokemonScreen(
                // onPokemonAdded: (pokemon) {
                //   setState(() {
                //     _pokemons.add(pokemon);
                //   });
                // },
              ),
            ),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
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

  void _showActionSheet(BuildContext context, _Pokemon pokemon) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdatePokemonScreen(pokemonId: int.parse(pokemon.id)
                        // pokemon: pokemon,
                        // onPokemonUpdated: (updatedPokemon) {
                        //   setState(() {
                        //     // Update the pokemon in the list
                        //     final index = _pokemons.indexWhere((p) => p.id == updatedPokemon.id);
                        //     if (index != -1) {
                        //       _pokemons[index] = updatedPokemon;
                        //     }
                        //   });
                        // },
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet first
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: Text('Are you sure you want to delete ${pokemon.nickname}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(), // Cancel
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop(); // Close dialog
                              await deletePokemon(int.parse(pokemon.id));
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },

              ),
            ],
          ),
        );
      },
    );
  }
}

