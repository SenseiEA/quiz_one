import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class page_form extends StatefulWidget {
  const page_form({Key? key}) : super(key: key);

  @override
  State<page_form> createState() => _page_formState();
}

class _page_formState extends State<page_form> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingPokemon = true;
  String? _errorMessage;
  DateTime? _selectedDate;
  String? _userId;

  // Pokemon data received from arguments
  String? pokemonId;

  // Pokemon data fetched from Firestore
  Map<String, dynamic> pokemonData = {};

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    if (email != null) {
      try {
        // Query pokemonUsers collection to find the user document by email
        final querySnapshot = await FirebaseFirestore.instance
            .collection('pokemonUsers')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            _userId = querySnapshot.docs.first.id;
          });
        } else {
          setState(() {
            _errorMessage = 'User not found. Please log in again.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error loading user data: ${e.toString()}';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Not logged in. Please log in first.';
      });
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get arguments passed from navigation
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments != null && arguments.containsKey('pokemonId')) {
      pokemonId = arguments['pokemonId'];
      _fetchPokemonDetails();
    } else {
      setState(() {
        _isLoadingPokemon = false;
        _errorMessage = 'No Pokemon ID provided';
      });
    }
  }

  Future<void> _fetchPokemonDetails() async {
    if (pokemonId == null) return;

    setState(() {
      _isLoadingPokemon = true;
      _errorMessage = null;
    });

    try {
      // Fetch Pokemon details from Firestore
      final pokemonDoc = await FirebaseFirestore.instance
          .collection('pokemonRegistrations')
          .doc(pokemonId)
          .get();

      if (!pokemonDoc.exists) {
        setState(() {
          _isLoadingPokemon = false;
          _errorMessage = 'Pokemon not found';
        });
        return;
      }

      final data = pokemonDoc.data()!;

      // Format the data for display
      setState(() {
        pokemonData = {
          'id': pokemonDoc.id,
          'pokemonId': data['pokemonId']?.toString() ?? '',
          'pokemonName': data['pokemonName'] ?? 'Unknown Pokemon',
          'nickname': data['nickname'] ?? data['pokemonName'] ?? 'Unknown Pokemon',
          'type': data['type']?.toString().toLowerCase() ?? 'normal',
          'imageUrl': data['imageUrl'] ?? 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
          'hp': data['hp'] ?? 50,
          'atk': data['atk'] ?? 50,
          'def': data['def'] ?? 50,
          'description': data['description'] ?? 'A mysterious Pokémon',
        };
        _isLoadingPokemon = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingPokemon = false;
        _errorMessage = 'Error fetching Pokemon: ${e.toString()}';
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _getTypeColor(pokemonData['type'] ?? 'normal'),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Format the date as YYYY-MM-DD
        _birthdateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _adoptPokemon() async {
    if (_formKey.currentState!.validate()) {
      if (_userId == null) {
        setState(() {
          _errorMessage = 'User ID not found. Please log in again.';
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        // Get the nickname or use default name
        final nickname = _nicknameController.text.trim().isEmpty
            ? pokemonData['pokemonName']
            : _nicknameController.text.trim();

        // Create adoption record in the new pokemonAdopted collection
        await FirebaseFirestore.instance.collection('pokemonAdopted').add({
          'userId': _userId,
          'adopterName': _nameController.text.trim(),
          'adopterAddress': _addressController.text.trim(),
          'adopterBirthdate': _selectedDate,
          'pokemonId': pokemonData['id'],
          'pokemonOriginalId': pokemonData['pokemonId'],
          'pokemonName': pokemonData['pokemonName'],
          'nickname': nickname,
          'adoptedAt': FieldValue.serverTimestamp(),
          'type': pokemonData['type'],
          'imageUrl': pokemonData['imageUrl'],
          'hp': pokemonData['hp'],
          'atk': pokemonData['atk'],
          'def': pokemonData['def'],
          'description': pokemonData['description'],
        });

        // Update original Pokemon document to show it's adopted
        await FirebaseFirestore.instance
            .collection('pokemonRegistrations')
            .doc(pokemonId)
            .update({
          'adoptedBy': _userId,
          'adopterName': _nameController.text.trim(),
          'adoptedAt': FieldValue.serverTimestamp(),
          'nickname': nickname,
        });

        // Navigate to completion page
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            '/form_complete',
            arguments: {
              'nickname': nickname,
              'imageUrl': pokemonData['imageUrl'],
            },
          );
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
          child: _isLoadingPokemon
              ? Center(
            child: CircularProgressIndicator(),
          )
              : SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Pokemon Image
                  if (pokemonData.isNotEmpty && pokemonData['imageUrl'] != null)
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
                          pokemonData['imageUrl'],
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
                  if (pokemonData.isNotEmpty && pokemonData['pokemonName'] != null)
                    Text(
                      pokemonData['pokemonName'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  if (pokemonData.isNotEmpty && pokemonData['type'] != null)
                    Chip(
                      label: Text(
                        pokemonData['type'].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: _getTypeColor(pokemonData['type']),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),

                  SizedBox(height: 16),

                  // Pokemon Stats
                  if (pokemonData.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Stats', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          SizedBox(height: 8),

                          // HP Stat
                          Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: Text(
                                  'HP',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: (pokemonData['hp'] as int) / 100,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('${pokemonData['hp']}'),
                            ],
                          ),
                          SizedBox(height: 6),

                          // Attack Stat
                          Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: Text(
                                  'Attack',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: (pokemonData['atk'] as int) / 100,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('${pokemonData['atk']}'),
                            ],
                          ),
                          SizedBox(height: 6),

                          // Defense Stat
                          Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: Text(
                                  'Defense',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: (pokemonData['def'] as int) / 100,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('${pokemonData['def']}'),
                            ],
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 24),

                  // Description
                  if (pokemonData.isNotEmpty && pokemonData['description'] != null)
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          SizedBox(height: 8),
                          Text(
                            pokemonData['description'],
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 32),

                  // Adopter Information Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Adopter Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Adopter's Name
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Your Name',
                            hintText: 'Enter your full name',
                            filled: true,
                            fillColor: Colors.grey[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Adopter's Address
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Your Address',
                            hintText: 'Enter your address',
                            filled: true,
                            fillColor: Colors.grey[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.home),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                          maxLines: 3,
                        ),
                        SizedBox(height: 16),

                        // Adopter's Birthdate
                        TextFormField(
                          controller: _birthdateController,
                          decoration: InputDecoration(
                            labelText: 'Your Birthdate',
                            hintText: 'YYYY-MM-DD',
                            filled: true,
                            fillColor: Colors.grey[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.calendar_today),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_month),
                              onPressed: () => _selectDate(context),
                            ),
                          ),
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please select your birthdate';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Pokemon Nickname Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Give your Pokémon a nickname',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
                            fillColor: Colors.grey[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.pets),
                          ),
                          maxLength: 20,
                        ),
                      ],
                    ),
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
                      backgroundColor: pokemonData.isNotEmpty
                          ? _getTypeColor(pokemonData['type'])
                          : Colors.pink,
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

                  SizedBox(height: 40),
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