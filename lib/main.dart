import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_one/pages/page_free.dart';
import 'package:quiz_one/pages/page_gallery.dart';
import 'package:quiz_one/pages/auth/page_registration.dart';
import 'package:quiz_one/pages/stateless/page_about.dart';
import 'package:quiz_one/pages/auth/page_login.dart';
import 'pokeapi_service.dart';
import 'pokemon.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_one/pages/drawer/drawer_header.dart';
import 'package:quiz_one/pages/drawer/drawer_list_view.dart';

// Firebase Favorites Service
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
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('✅ Firebase Initialized: ${Firebase.apps.isNotEmpty}');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  print(email);
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final lastRoute = prefs.getString('lastRoute');

  // Determine where to start the app
  final initialRoute = isLoggedIn
      ? (lastRoute ?? '/home')  // Use last visited route or default to /home
      : '/login';

  runApp(MyApp(initialRoute: initialRoute));
}


class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Poke-Adopt!",
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        fontFamily: 'DM-Sans',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'DM-Sans',
          ),
        ),
      ),
      initialRoute: initialRoute, // Set initial route to login
      routes: {
        '/login': (context) => const page_login(), // Route to page_login.dart
        '/home': (context) => const MyAppHome(), // Route to your main screen
        '/gallery': (context) => const page_photos(),
        '/about': (context) => const page_about(),
        '/interests': (context) => const page_free(),
        '/adoption': (context) => const page_registration(),
        '/contact': (context) => const page_registration(),
        '/logout': (context) => const page_login(),
      },
    );
  }
}

// Extract your previous main widget (home screen) to a separate class
class MyAppHome extends StatefulWidget {
  const MyAppHome({super.key});
  @override
  State<MyAppHome> createState() => _MyAppHomeState();
}

class _MyAppHomeState extends State<MyAppHome> with SingleTickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Poke-Adopt!",
      home: Scaffold(
        extendBodyBehindAppBar: true, // Make body extend behind AppBar
        appBar: AppBar(
          title: const Text(
            "POKE-ADOPT",
            style: TextStyle(
              fontSize: 22,
              letterSpacing: 1.2,
            ),
          ),
        ),
        body: const HomePage(),
        //Copy here for drawer
        drawer: Drawer(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Forces sharp 90° corners
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrwHeader(),
              DrwListView(currentRoute: "/home"),//Replace "home" with current route
            ],
          ),
        ),
        //End Copy
      ),
    );
  }
}

final Map<String, Map<String, dynamic>> typeColors = {
  "normal": {"icon": Icons.circle, "color": Colors.grey, "background": Color(0xFFAAAAAA)},
  "fire": {"icon": Icons.local_fire_department, "color": Colors.red, "background": Color(0xFFFF6B43)},
  "water": {"icon": Icons.water_drop, "color": Colors.blue, "background": Color(0xFF3399FF)},
  "electric": {"icon": Icons.flash_on, "color": Colors.amber, "background": Color(0xFFFFD700)},
  "grass": {"icon": Icons.grass, "color": Colors.green, "background": Color(0xFF7AC74C)},
  "ice": {"icon": Icons.ac_unit, "color": Colors.cyanAccent, "background": Color(0xFF96D9D6)},
  "fighting": {"icon": Icons.sports_mma, "color": Colors.orange, "background": Color(0xFFC22E28)},
  "poison": {"icon": Icons.coronavirus, "color": Colors.purple, "background": Color(0xFFA33EA1)},
  "ground": {"icon": Icons.landscape, "color": Colors.brown, "background": Color(0xFFE2BF65)},
  "flying": {"icon": Icons.air, "color": Colors.indigo, "background": Color(0xFFA98FF3)},
  "psychic": {"icon": Icons.remove_red_eye, "color": Colors.deepPurple, "background": Color(0xFFF95587)},
  "bug": {"icon": Icons.bug_report, "color": Colors.lightGreen, "background": Color(0xFFA6B91A)},
  "rock": {"icon": Icons.terrain, "color": Colors.brown.shade300, "background": Color(0xFFB6A136)},
  "ghost": {"icon": Icons.nightlight_round, "color": Colors.deepPurpleAccent, "background": Color(0xFF735797)},
  "dragon": {"icon": Icons.whatshot, "color": Colors.indigoAccent, "background": Color(0xFF6F35FC)},
  "dark": {"icon": Icons.dark_mode, "color": Colors.black87, "background": Color(0xFF705746)},
  "steel": {"icon": Icons.build, "color": Colors.blueGrey, "background": Color(0xFFB7B7CE)},
  "fairy": {"icon": Icons.local_florist, "color": Colors.pinkAccent, "background": Color(0xFFD685AD)},
};


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  late Future<List<Pokemon>> futurePokemonList;
  List<Map<String, dynamic>> firebasePokemonList = [];
  List<Map<String, dynamic>> filteredPokemonList = [];
  String searchQuery = "";
  String userName = 'Guest';
  String email = 'test@email.com';
  bool isLoading = true;
  final FavoritesService _favoritesService = FavoritesService();
  Map<String, bool> isFavorited = {};
  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futurePokemonList = PokeApiService().fetchPokemonList(50);
    _loadUserData();
    _fetchFirebasePokemon();

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _topAlignmentAnimation = TweenSequence<Alignment>(
      [
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1,
        ),
      ],
    ).animate(_controller);
    _bottomAlignmentAnimation =  TweenSequence<Alignment>(
      [
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1,
        ),
      ],
    ).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Guest';
      email = prefs.getString('email') ?? 'test@email.com';
    });
  }

  Future<void> _fetchFirebasePokemon() async {
    setState(() {
      isLoading = true;
    });

    try{
      final snapshot = await FirebaseFirestore.instance
          .collection('pokemonRegistrations')
          .get();

      List<Map<String, dynamic>> templist = [];

      for(var doc in snapshot.docs){
        final data = doc.data();

        String imageUrl = data['imageUrl'] ??
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png';

        if(!(imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))){
          imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png';
        }

        templist.add({
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
        });
      }

      // Check favorite status for each Pokemon
      for (var pokemon in templist) {
        bool favorited = await _favoritesService.isPokemonFavorited(pokemon['id']);
        isFavorited[pokemon['id']] = favorited;
      }

      setState(() {
        firebasePokemonList = templist;
        filteredPokemonList = templist;
        isLoading = false;
      });
    }
    catch(e){
      print('Error catching pokemon from Firebase: $e');
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Pokemon: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _filterPokemon(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      if (searchQuery.isEmpty) {
        filteredPokemonList = firebasePokemonList;
      } else {
        filteredPokemonList = firebasePokemonList.where((pokemon) {
          return pokemon['name'].toString().toLowerCase().contains(searchQuery) ||
              pokemon['nickname'].toString().toLowerCase().contains(searchQuery) ||
              pokemon['type'].toString().toLowerCase().contains(searchQuery);
        }).toList();
      }
    });
  }

  Future<void> _toggleFavorite(String pokemonId) async {
    try {
      bool currentStatus = isFavorited[pokemonId] ?? false;

      if (currentStatus) {
        await _favoritesService.removeFromFavorites(pokemonId);
      } else {
        await _favoritesService.addToFavorites(pokemonId);
      }

      setState(() {
        isFavorited[pokemonId] = !currentStatus;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(currentStatus
              ? 'Removed from favorites'
              : 'Added to favorites'),
          backgroundColor: currentStatus ? Colors.grey : Colors.pink,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showPokemonDetails(Map<String, dynamic> pokemon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.all(16),
            child: ListView(
              controller: scrollController,
              children: [
                // Handle indicator
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(bottom: 16),
                  ),
                ),

                // Pokemon image
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: typeColors[pokemon['type'].toString().toLowerCase()]?['background'] ?? Colors.grey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: pokemon['image'],
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                  ),
                ),

                SizedBox(height: 16),

                // Pokemon nickname and name
                Text(
                  pokemon['nickname'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '#${pokemon['pokemonId']} ${pokemon['name']}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),

                // Type chip
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        backgroundColor: typeColors[pokemon['type'].toString().toLowerCase()]?['background'] ?? Colors.grey,
                        label: Text(
                          pokemon['type'].toString().toUpperCase(),
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                // Stats
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
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
                              value: (pokemon['hp'] as int) / 100,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('${pokemon['hp']}'),
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
                              value: (pokemon['atk'] as int) / 100,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('${pokemon['atk']}'),
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
                              value: (pokemon['def'] as int) / 100,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('${pokemon['def']}'),
                        ],
                      ),
                    ],
                  ),
                ),

                // Description
                SizedBox(height: 16),
                Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 8),
                Text(
                  pokemon['description'],
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),

                // Adoption button
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close sheet
                    Navigator.pushNamed(context, '/adoption'); // Navigate to adoption page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: typeColors[pokemon['type'].toString().toLowerCase()]?['background'] ?? Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Adopt This Pokemon', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context,_) {
          return Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Color(0xffF6F3FD),
                      Color(0xffFFE2E5),
                      Color(0xffDFECB4),
                    ],
                    begin: _topAlignmentAnimation.value,
                    end: _bottomAlignmentAnimation.value,
                  )
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Add padding for the AppBar
                    SizedBox(height: AppBar().preferredSize.height + MediaQuery.of(context).padding.top),

                    // Search bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _filterPokemon,
                          decoration: InputDecoration(
                            hintText: "Search Pokémon...",
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                    ),

                    // Adoption Banner Card
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 2,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Color(0xFFF0F8FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Adopt a pet now at",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "POKE-ADOPT",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade400,
                                  letterSpacing: 2,
                                ),
                              ),
                              SizedBox(height: 6),
                              Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Pokemon Types section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pokémon Types",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: typeColors.entries.map((entry) {
                                String type = entry.key;
                                Map<String, dynamic> typeData = entry.value;

                                return Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Chip(
                                    backgroundColor: typeData['background'],
                                    avatar: Icon(
                                      typeData['icon'],
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    label: Text(
                                      type.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Adopt A Pokemon section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Adopt A Pokémon",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, '/gallery');
                            },
                            icon: Icon(Icons.pets, size: 18, color: Colors.pink.shade400),
                            label: Text(
                              "View All",
                              style: TextStyle(
                                color: Colors.pink.shade400,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    isLoading
                        ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.pink.shade300),
                        ))
                        : filteredPokemonList.isEmpty
                        ? Center(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Icon(Icons.search_off, size: 64, color: Colors.grey),
                          Text(
                            'No Pokémon found',
                            style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10),
                          TextButton.icon(
                            onPressed: () {
                              _searchController.clear();
                              _filterPokemon("");
                            },
                            icon: Icon(Icons.refresh),
                            label: Text('Clear Search'),
                          ),
                        ],
                      ),
                    ) : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredPokemonList.length > 5 ? 5 : filteredPokemonList.length,
                      itemBuilder: (context, index){
                        final pokemon = filteredPokemonList[index];
                        return FirebasePokemonAdoptCard(
                          pokemon: pokemon,
                          isFavorited: isFavorited[pokemon['id']] ?? false,
                          onTap: () => _showPokemonDetails(pokemon),
                          onFavoriteToggle: () => _toggleFavorite(pokemon['id']),
                        );
                      },
                    ),

                    if(firebasePokemonList.isEmpty && !isLoading)
                      FutureBuilder<List<Pokemon>>(
                        future: futurePokemonList,
                        builder: (context, snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError){
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if(!snapshot.hasData || snapshot.data!.isEmpty){
                            return const Center(child: Text('No Pokémon Found'));
                          } else {
                            final pokemonList = snapshot.data!;

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: pokemonList.length > 5 ? 5 : pokemonList.length,
                              itemBuilder: (context, index) {
                                final pokemon = pokemonList[index];
                                return PokemonAdoptCard(pokemon);
                              },
                            );
                          }
                        },
                      ),

                    // Bottom padding
                    SizedBox(height: 20),
                  ],
                ),
              )
          );
        }
    );
  }
}

class FirebasePokemonAdoptCard extends StatelessWidget {
  final Map<String, dynamic> pokemon;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final bool isFavorited;

  const FirebasePokemonAdoptCard({
    required this.pokemon,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.isFavorited,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pokemon Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: pokemon['image'],
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              typeColors[pokemon['type'].toString().toLowerCase()]?['background'] ?? Colors.grey
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.error, size: 40),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: typeColors[pokemon['type'].toString().toLowerCase()]?['background'] ?? Colors.grey,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(12)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            typeColors[pokemon['type'].toString().toLowerCase()]?['icon'] ?? Icons.circle,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            pokemon['type'].toString().toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Pokemon Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pokemon['nickname'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '#${pokemon['pokemonId']} ${pokemon['name']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : Colors.grey,
                      size: 28,
                    ),
                    onPressed: onFavoriteToggle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PokemonAdoptCard extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonAdoptCard(this.pokemon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pokemon Image
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.network(
                  pokemon.image,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 180,
                      color: Colors.grey[200],
                      child: Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: typeColors[pokemon.type.toLowerCase()]?['background'] ?? Colors.grey,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(12)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          typeColors[pokemon.type.toLowerCase()]?['icon'] ?? Icons.circle,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          pokemon.type.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Pokemon Info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pokemon.name.substring(0, 1).toUpperCase() + pokemon.name.substring(1),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      pokemon.type.substring(0, 1).toUpperCase() + pokemon.type.substring(1),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cannot favorite API Pokémon. Try registered ones!'),
                        backgroundColor: Colors.orange,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}