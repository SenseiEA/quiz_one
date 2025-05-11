import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CollectionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Get all adopted Pokemon for the current user
  Future<List<Map<String, dynamic>>> getAdoptedPokemon() async {
    if (currentUserId == null) {
      throw Exception('User not logged in');
    }

    try {
      // This query specifically filters for the current user's adopted Pokemon
      final snapshot = await _firestore
          .collection('pokemonAdopted')
          .where('userId', isEqualTo: currentUserId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();

        // Format the adoption date
        String formattedDate = 'Unknown date';
        if (data['adoptedAt'] != null) {
          final timestamp = data['adoptedAt'] as Timestamp;
          final date = timestamp.toDate();
          formattedDate = '${date.day}/${date.month}/${date.year}';
        }

        // Ensure image URL is valid
        String imageUrl = data['imageUrl'] ??
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png';

        if (!(imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))) {
          imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png';
        }

        return {
          'id': doc.id,
          'pokemonId': data['pokemonId']?.toString() ?? '',
          'pokemonOriginalId': data['pokemonOriginalId']?.toString() ?? '',
          'name': data['pokemonName'] ?? 'Unknown Pokemon',
          'nickname': data['nickname'] ?? data['pokemonName'] ?? 'Unknown Pokemon',
          'type': data['type']?.toString()?.toLowerCase() ?? 'normal',
          'image': imageUrl,
          'hp': data['hp'] ?? 50,
          'atk': data['atk'] ?? 50,
          'def': data['def'] ?? 50,
          'description': data['description'] ?? 'A mysterious Pokémon',
          'adoptedAt': formattedDate,
          'adopterName': data['adopterName'] ?? 'Unknown',
          'adopterAddress': data['adopterAddress'] ?? 'Unknown',
          'adopterBirthdate': data['adopterBirthdate'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching adopted Pokemon: $e');
      throw e;
    }
  }

  // Show success snackbar
  void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Show error snackbar
  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
      ),
    );
  }
}