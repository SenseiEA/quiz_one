import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class page_form extends StatefulWidget {
  const page_form({Key? key}) : super(key: key);

  @override
  State<page_form> createState() => _page_formState();
}

class _page_formState extends State<page_form> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  // Pokemon data received from arguments
  String? pokemonId;
  String? pokemonName;
  String? pokemonImage;
  String? pokemonType;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get arguments passed from navigation
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      pokemonId = arguments['pokemonId'];
      pokemonName = arguments['pokemonName'];
      pokemonImage = arguments['pokemonImage'];
      pokemonType = arguments['pokemonType'];
    }
  }

  Future<void> _adoptPokemon() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        // Check if user is logged in
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          setState(() {
            _errorMessage = 'You must be logged in to adopt a Pokémon';
            _isLoading = false;
          });
          return;
        }

        // Get the nickname or use default name
        final nickname = _nicknameController.text.trim().isEmpty
            ? pokemonName
            : _nicknameController.text.trim();

        // Get user details
        final prefs = await SharedPreferences.getInstance();
        final userName = prefs.getString('userName') ?? 'Unknown User';

        // Reference to the document of this specific Pokemon
        final pokemonRef = FirebaseFirestore.instance
            .collection('pokemonRegistrations')
            .doc(pokemonId);

        // Get the original Pokemon data
        final pokemonDoc = await pokemonRef.get();

        if (!pokemonDoc.exists) {
          setState(() {
            _errorMessage = 'Pokemon not found';
            _isLoading = false;
          });
          return;
        }

        // Create adoption record
        await FirebaseFirestore.instance.collection('adoptions').add({
          'userId': user.uid,
          'userName': userName,
          'pokemonId': pokemonId,
          'pokemonName': pokemonName,
          'nickname': nickname,
          'adoptedAt': FieldValue.serverTimestamp(),
          'type': pokemonType,
          'imageUrl': pokemonImage,
        });

        // Update original Pokemon document to show it's adopted
        await pokemonRef.update({
          'adoptedBy': user.uid,
          'adoptedAt': FieldValue.serverTimestamp(),
          'nickname': nickname,
        });

        // Show success message and navigate back
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully adopted $nickname!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate back to home
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error adopting Pokémon: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adopt a Pokémon'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.pink.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Pokemon Image
                  if (pokemonImage != null)
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          pokemonImage!,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.broken_image, size: 80);
                          },
                        ),
                      ),
                    ),

                  SizedBox(height: 24),

                  // Pokemon Name
                  if (pokemonName != null)
                    Text(
                      pokemonName!,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  if (pokemonType != null)
                    Chip(
                      label: Text(
                        pokemonType!.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: _getTypeColor(pokemonType!),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),

                  SizedBox(height: 32),

                  // Form fields
                  Text(
                    'Give your Pokémon a nickname',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Leave blank to use its original name',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Nickname field
                  TextFormField(
                    controller: _nicknameController,
                    decoration: InputDecoration(
                      hintText: 'Nickname (optional)',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.pets),
                    ),
                    maxLength: 20,
                  ),

                  SizedBox(height: 20),

                  // Error message if any
                  if (_errorMessage != null)
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red.shade800),
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 32),

                  // Submit button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _adoptPokemon,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(double.infinity, 56),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                      'Adopt This Pokémon',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to get color based on Pokemon type
  Color _getTypeColor(String type) {
    final typeColor = {
      "normal": Colors.grey,
      "fire": Colors.red,
      "water": Colors.blue,
      "electric": Colors.amber,
      "grass": Colors.green,
      "ice": Colors.cyanAccent,
      "fighting": Colors.orange,
      "poison": Colors.purple,
      "ground": Colors.brown,
      "flying": Colors.indigo,
      "psychic": Colors.deepPurple,
      "bug": Colors.lightGreen,
      "rock": Colors.brown.shade300,
      "ghost": Colors.deepPurpleAccent,
      "dragon": Colors.indigoAccent,
      "dark": Colors.black87,
      "steel": Colors.blueGrey,
      "fairy": Colors.pinkAccent,
    };

    return typeColor[type.toLowerCase()] ?? Colors.grey;
  }
}