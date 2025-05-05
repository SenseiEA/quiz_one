import 'dart:math';

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



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('✅ Firebase Initialized: ${Firebase.apps.isNotEmpty}');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  print(email);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Poke-Adopt!",
      theme: ThemeData(primarySwatch: Colors.yellow),
      initialRoute: '/login', // Set initial route to login
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "HOMEPAGE",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'DM-Sans'
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
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
  String filter = "";
  String userName = 'Guest';
  String email = 'test@email.com';

  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    super.initState();
    futurePokemonList = PokeApiService().fetchPokemonList(50);
    _loadUserData();

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

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Guest';
      email = prefs.getString('email') ?? 'test@email.com';
    });
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
                  // Location bar with search - using a Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: Row(
                      children: [
                        // Location icon and text
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.pink.shade300, size: 18),
                              SizedBox(width: 4),
                              Text("Muntinlupa, NCR", style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),

                        Spacer(),

                        // Search icon
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            // Search functionality
                          },
                        ),

                        // Menu icon
                        IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      ],
                    ),
                  ),

                  // Adoption Banner Card
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Adopt a pet now at",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "ADOPT",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade300,
                                letterSpacing: 2,
                              ),
                            ),
                            SizedBox(height: 4),
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
                          "Pokemon Types",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: typeColors.entries.map((entry) {
                              String type = entry.key;
                              Map<String, dynamic> typeData = entry.value;

                              return Container(
                                margin: EdgeInsets.only(right: 8),
                                child: Chip(
                                  backgroundColor: typeData['background'],
                                  label: Text(
                                    type.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Adopt A Pokemon",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "View All",
                            style: TextStyle(
                              color: Colors.pink.shade300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Pokemon Cards
                  FutureBuilder<List<Pokemon>>(
                    future: futurePokemonList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No Pokémon found.'));
                      } else {
                        final pokemonList = snapshot.data!;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: pokemonList.length > 5 ? 5 : pokemonList.length, // Show only first 3
                          itemBuilder: (context, index) {
                            final pokemon = pokemonList[index];
                            return PokemonAdoptCard(pokemon);
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            )
        );
      }
    );


  }
}

class PokemonAdoptCard extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonAdoptCard(this.pokemon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pokemon Image
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              children: [
                Image.network(
                  pokemon.image,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    color: typeColors[pokemon.type.toLowerCase()]?['background'] ?? Colors.red,
                    child: Text(
                      pokemon.type.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Pokemon Info
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pokemon.name.substring(0, 1).toUpperCase() + pokemon.name.substring(1),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      pokemon.type.substring(0, 1).toUpperCase() + pokemon.type.substring(1),
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}