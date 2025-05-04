import 'package:flutter/material.dart';

import '../drawer/drawer_header.dart';
import '../drawer/drawer_list_view.dart';

class page_pokeinfo extends StatelessWidget {
  final Map<String, dynamic> pokemonData = {
    "name": "Kyle",
    "species": "Charmander",
    "type": "fire",
    "description":
    "Charmander is a bipedal, reptilian Pokémon. Most of its body is colored orange, while its underbelly is light yellow and it has blue eyes. It has a flame at the end of its tail, which is said to signify its health.",
    "gender": "Male",
    "height": "2'00\"",
    "weight": "8.5 kg",
    "vaccinated": true,
    "likes": ["Walking outside", "Showers"],
    "stats": {
      "HP": 45,
      "ATK": 49,
      "DEF": 49,
      "SPD": 45,
      "SPD-2": 45,
    },
  };

  final Map<String, Map<String, dynamic>> typeColors = {
    "fire": {
      "icon": Icons.local_fire_department,
      "color": Colors.red,
      "background": Color(0xFFFF6B43)
    },
    // Add more types as needed...
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrwHeader(),
            DrwListView(currentRoute: "/interests"),
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 600;
          return isWide
              ? Row(
            children: [
              Expanded(flex: 1, child: _buildImageSection()),
              Expanded(flex: 1, child: _buildDetailsSection(context)),
            ],
          )
              : SingleChildScrollView(
            child: Column(
              children: [
                _buildImageSection(),
                _buildDetailsSection(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/landscape_1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    final type = pokemonData['type'];
    final typeColor = typeColors[type];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: typeColor?['background'],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              type.toString().toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Name & Species
          Text(
            pokemonData['name'],
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            pokemonData['species'],
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          //Description divider
          Text(
            "About Pokemon",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            pokemonData['description'],
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          //Basic Info divider
          Text(
            "Basic Info",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          // Basic Info
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _infoChip(Icons.male, pokemonData['gender']),
              _infoChip(Icons.height, pokemonData['height']),
              _infoChip(Icons.monitor_weight, pokemonData['weight']),
              _infoChip(
                Icons.verified,
                pokemonData['vaccinated'] ? "Vaccinated" : "Not Vaccinated",
                color: pokemonData['vaccinated'] ? Colors.green : Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 16),
          //Additional Info divider
          Text(
            "Likes",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          // Likes / Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List<Widget>.from(
              pokemonData['likes'].map<Widget>((tag) => _tagChip(tag)),
            ),
          ),
          const SizedBox(height: 16),

          // Stats Bars
          Column(
            children: (pokemonData['stats'] as Map<String, dynamic>)
                .entries
                .map((entry) => _statBar(entry.key, entry.value))
                .toList(),
          ),
          const SizedBox(height: 24),

          // Adopt Button
          Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF7FF10), Color(0xFFFFB7D6)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Add functionality here later
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "ADOPT",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF7FF10), Color(0xFFFFB7D6)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.black),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }


  Widget _tagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF7FF10), Color(0xFFFFB7D6)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _statBar(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 50, child: Text(label)),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.grey.shade300,
              color: Colors.blue,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(value.toString()),
        ],
      ),
    );
  }
}
