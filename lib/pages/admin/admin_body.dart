import 'package:flutter/material.dart';
import 'dart:math';
import 'package:quiz_one/pages/drawer/drawer_header.dart';
import 'package:quiz_one/pages/drawer/drawer_list_view.dart';
import 'admin.delete.dart';
import 'admin_create.dart';
import 'admin_update.dart';

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
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      home: const PokemonListScreen(),

    );
  }
}

class Pokemon {
  final String id;
  String name;
  final List<String> types;
  final String imageUrl;
  int hp;
  int atk;
  int def;
  int spd;
  int age;

  Pokemon({
    required this.id,
    required this.name,
    required this.types,
    required this.imageUrl,
    required this.hp,
    required this.atk,
    required this.def,
    required this.spd,
    required this.age,
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
  final List<Pokemon> _pokemons = [
    Pokemon(
      id: '1',
      name: 'Pikachu',
      types: ['Electric'],
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
      hp: 35,
      atk: 55,
      def: 40,
      spd: 90,
      age: 1

    ),
    Pokemon(
      id: '2',
      name: 'Pikachu',
      types: ['Electric'],
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
      hp: 35,
      atk: 55,
      def: 40,
      spd: 90,
      age: 3
    ),
    Pokemon(
      id: '3',
      name: 'Pikachu',
      types: ['Electric'],
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
      hp: 35,
      atk: 55,
      def: 40,
      spd: 90,
      age: 2
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            _buildAppBar('Registered Pokemon'),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _pokemons.length,
                itemBuilder: (context, index) {
                  final pokemon = _pokemons[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          pokemon.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Row(
                        children: [
                          ...pokemon.types.map((type) =>
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _getColorForType(type),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child:
                                Text(
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
                            pokemon.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text("${pokemon.types[0]} · Age: ${pokemon.age}"),
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
                onPokemonAdded: (pokemon) {
                  setState(() {
                    _pokemons.add(pokemon);
                  });
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
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
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPokemonScreen(
                    onPokemonAdded: (pokemon) {
                      setState(() {
                        _pokemons.add(pokemon);
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showActionSheet(BuildContext context, Pokemon pokemon) {
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
                      builder: (context) => UpdatePokemonScreen(
                        pokemon: pokemon,
                        onPokemonUpdated: (updatedPokemon) {
                          setState(() {
                            // Update the pokemon in the list
                            final index = _pokemons.indexWhere((p) => p.id == updatedPokemon.id);
                            if (index != -1) {
                              _pokemons[index] = updatedPokemon;
                            }
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeletePokemonScreen(
                        pokemon: pokemon,
                        onPokemonDeleted: (deletedPokemon) {
                          setState(() {
                            _pokemons.removeWhere((p) => p.id == deletedPokemon.id);
                          });
                        },
                      ),
                    ),
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

