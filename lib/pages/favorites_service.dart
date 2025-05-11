import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add a Pokemon to favorites
  Future<void> addToFavorites(String pokemonId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      await _firestore.collection('pokemonUsers').doc(userId).set({
        'favoritesList': FieldValue.arrayUnion([pokemonId])
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error adding to favorites: $e');
      rethrow;
    }
  }

  // Remove a Pokemon from favorites
  Future<void> removeFromFavorites(String pokemonId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      await _firestore.collection('pokemonUsers').doc(userId).update({
        'favoritesList': FieldValue.arrayRemove([pokemonId])
      });
    } catch (e) {
      print('Error removing from favorites: $e');
      rethrow;
    }
  }

  // Get all favorited Pokemon IDs
  Future<List<String>> getFavoriteIds() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        return [];
      }

      final doc = await _firestore.collection('pokemonUsers').doc(userId).get();
      if (!doc.exists || !doc.data()!.containsKey('favoritesList')) {
        return [];
      }

      return List<String>.from(doc.data()!['favoritesList'] ?? []);
    } catch (e) {
      print('Error getting favorite IDs: $e');
      return [];
    }
  }

  // Get full Pokemon documents from favorited IDs
  Future<List<Map<String, dynamic>>> getFavoritePokemon() async {
    try {
      final favoriteIds = await getFavoriteIds();
      if (favoriteIds.isEmpty) {
        return [];
      }

      final snapshot = await _firestore
          .collection('pokemonRegistrations')
          .where(FieldPath.documentId, whereIn: favoriteIds)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        String imageUrl = data['imageUrl'] ??
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png';

        if (!(imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))) {
          imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png';
        }

        return {
          'id': doc.id,
          'pokemonId': data['pokemonId'].toString(),
          'name': data['pokemonName'],
          'nickname': data['nickname'] ?? data['pokemonName'],
          'type': data['type'].toString().toLowerCase(),
          'image': imageUrl,
          'hp': data['hp'] ?? 50,
          'atk': data['atk'] ?? 50,
          'def': data['def'] ?? 50,
          'description': data['description'] ?? 'A mysterious Pokémon',
        };
      }).toList();
    } catch (e) {
      print('Error getting favorite Pokemon: $e');
      return [];
    }
  }

  // Check if a Pokemon is favorited
  Future<bool> isPokemonFavorited(String pokemonId) async {
    try {
      final favoriteIds = await getFavoriteIds();
      return favoriteIds.contains(pokemonId);
    } catch (e) {
      print('Error checking if Pokemon is favorited: $e');
      return false;
    }
  }

  // Show error SnackBar
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

  // Show success SnackBar
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
        duration: Duration(seconds: 3),
      ),
    );
  }
}