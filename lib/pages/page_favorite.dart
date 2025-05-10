import 'package:flutter/material.dart';
import 'package:quiz_one/pages/drawer/drawer_header.dart';
import 'package:quiz_one/pages/drawer/drawer_list_view.dart';

class page_favorite extends StatelessWidget {
  const page_favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return const FavoritePage();
  }
}

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  // List of favorite Pokemon
  final List<FavoritePokemon> _favoritePokemon = [
    FavoritePokemon(
      id: '1',
      name: 'Pikachu',
      type: 'Electric',
      category: 'Mouse',
      isFavorite: true,
      image: 'assets/pikachu.png',
    ),
    FavoritePokemon(
      id: '2',
      name: 'Pikachu',
      type: 'Electric',
      category: 'Mouse',
      isFavorite: false,
      image: 'assets/pikachu.png',
    ),
    FavoritePokemon(
      id: '3',
      name: 'Pikachu',
      type: 'Electric',
      category: 'Mouse',
      isFavorite: false,
      image: 'assets/pikachu.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.white,
        // Add drawer button
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
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
            DrwListView(currentRoute: "/favorite"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Pokemon card list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _favoritePokemon.length,
              itemBuilder: (context, index) {
                return _buildPokemonCard(_favoritePokemon[index]);
              },
            ),
          ),

          // Interests gradient button at bottom
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/interests');
              },
              child: _buildInterestsButton(),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build each Pokemon card
  Widget _buildPokemonCard(FavoritePokemon pokemon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            pokemon.image,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Row(
          children: [
            // Type badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFFCC01),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                pokemon.type,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Pokemon name
            Text(
              pokemon.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Text(
          pokemon.category,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            pokemon.isFavorite ? Icons.favorite : Icons.add,
            color: pokemon.isFavorite ? Colors.black : Colors.black,
          ),
          onPressed: () {
            setState(() {
              pokemon.isFavorite = !pokemon.isFavorite;
            });
          },
        ),
      ),
    );
  }

  // Helper method to create the gradient interests button
  Widget _buildInterestsButton() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Colors.pink],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Center(
        child: Text(
          'Interests',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class FavoritePokemon {
  final String id;
  final String name;
  final String type;
  final String category;
  bool isFavorite;
  final String image;

  FavoritePokemon({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.isFavorite,
    required this.image,
  });
}