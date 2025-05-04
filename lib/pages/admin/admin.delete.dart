import 'package:flutter/material.dart';
import 'admin_body.dart';

class DeletePokemonScreen extends StatefulWidget {
  final Pokemon pokemon;
  final Function(Pokemon) onPokemonDeleted;

  const DeletePokemonScreen({
    super.key,
    required this.pokemon,
    required this.onPokemonDeleted,
  });

  @override
  State<DeletePokemonScreen> createState() => _DeletePokemonScreenState();
}

class _DeletePokemonScreenState extends State<DeletePokemonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF77FF86), // Light green background
        child: Column(
          children: [
            _buildAppBar('Delete a Pokemon'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                          child: Image.network(
                            widget.pokemon.imageUrl,
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
                    const SizedBox(height: 16),
                    const Text(
                      'Pokemon Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.pokemon.name,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStatsBar('HP', widget.pokemon.hp),
                    const SizedBox(height: 8),
                    _buildStatsBar('ATK', widget.pokemon.atk),
                    const SizedBox(height: 8),
                    _buildStatsBar('DEF', widget.pokemon.def),
                    const SizedBox(height: 8),
                    _buildStatsBar('SPD', widget.pokemon.spd),
                    const SizedBox(height: 8),
                    _buildStatsBar('AGE', widget.pokemon.age),
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
                              widget.onPokemonDeleted(widget.pokemon);
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Delete',
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