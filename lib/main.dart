import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quiz_one/pages/page_free.dart';
import 'package:quiz_one/pages/page_photos.dart';
import 'package:quiz_one/pages/page_registration.dart';
import 'package:quiz_one/pages/page_about.dart';
import 'pokeapi_service.dart';
import 'pokemon.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:quiz_one/pages/page_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      },
    );
  }
}

class MyAppHome extends StatelessWidget {
  const MyAppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Poke-Adopt!",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            "HOMEPAGE",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'DM-Sans'
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const HomePage(),
        drawer: const CustomDrawer(),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF333333),
        child: Column(
          children: [
            Container(
              color: Colors.black,
              padding: EdgeInsets.only(top: 50, bottom: 20),
              child: const Row(
                children: [
                  SizedBox(width: 20),
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 15),
                  Text(
                    "Hello, Ash!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            DrawerListItem(
              icon: Icons.home,
              title: "Home",
              isSelected: true,
              onTap: () => Navigator.pop(context),
            ),
            DrawerListItem(
              icon: Icons.photo_album,
              title: "Gallery",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const page_photos()),
                );
              },
            ),
            DrawerListItem(
              icon: Icons.catching_pokemon,
              title: "Pokemon Interests",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const page_free()),
                );
              },
            ),
            DrawerListItem(
              icon: Icons.app_registration,
              title: "Adoption Application",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const page_registration()),
                );
              },
            ),
            DrawerListItem(
              icon: Icons.info_outline,
              title: "About",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const page_about()),
                );
              },
            ),
            DrawerListItem(
              icon: Icons.contact_mail,
              title: "Contact",
              onTap: () {},
            ),
            DrawerListItem(
              icon: Icons.logout,
              title: "Logout",
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('userName');
                await prefs.remove('email');
                await prefs.setBool('isLoggedIn', false);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const page_login()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;
  final bool isSelected;

  const DrawerListItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected ? Colors.yellow : Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.black : Colors.white),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
          ),
        ),
        onTap: () => onTap(),
      ),
    );
  }
}

final Map<String, Map<String, dynamic>> typeColors = {
  "normal": {"icon": Icons.circle, "color": Colors.grey},
  "fire": {"icon": Icons.local_fire_department, "color": Colors.red},
  "water": {"icon": Icons.water_drop, "color": Colors.blue},
  "electric": {"icon": Icons.flash_on, "color": Colors.amber},
  "grass": {"icon": Icons.grass, "color": Colors.green},
  "ice": {"icon": Icons.ac_unit, "color": Colors.cyanAccent},
  "fighting": {"icon": Icons.sports_mma, "color": Colors.orange},
  "poison": {"icon": Icons.coronavirus, "color": Colors.purple},
  "ground": {"icon": Icons.landscape, "color": Colors.brown},
  "flying": {"icon": Icons.air, "color": Colors.indigo},
  "psychic": {"icon": Icons.remove_red_eye, "color": Colors.deepPurple},
  "bug": {"icon": Icons.bug_report, "color": Colors.lightGreen},
  "rock": {"icon": Icons.terrain, "color": Colors.brown.shade300},
  "ghost": {"icon": Icons.nightlight_round, "color": Colors.deepPurpleAccent},
  "dragon": {"icon": Icons.whatshot, "color": Colors.indigoAccent},
  "dark": {"icon": Icons.dark_mode, "color": Colors.black87},
  "steel": {"icon": Icons.build, "color": Colors.blueGrey},
  "fairy": {"icon": Icons.local_florist, "color": Colors.pinkAccent},
};

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Pokemon>> futurePokemonList;
  String filter = "";
  List<String> types = [
    "normal", "fire", "water", "electric", "grass", "ice",
    "fighting", "poison", "ground", "flying", "psychic",
    "bug", "rock", "ghost", "dragon", "dark", "steel", "fairy"
  ];

  @override
  void initState() {
    super.initState();
    futurePokemonList = PokeApiService().fetchPokemonList(50);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Location header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.redAccent, size: 20),
              SizedBox(width: 4),
              Text(
                "Muntinlupa, NCR",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Icon(Icons.search, size: 20),
              SizedBox(width: 12),
              Icon(Icons.menu, size: 20),
            ],
          ),
        ),

        // Adopt banner
        Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Column(
              children: [
                Text(
                  "Adopt a pet now at",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ADOPT",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.catching_pokemon,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Type filters
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          alignment: Alignment.centerLeft,
          child: Text(
            "Pokemon Types",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.pink[300],
            ),
          ),
        ),

        Container(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: types.map((type) {
              return Container(
                margin: EdgeInsets.only(right: 8),
                child: Chip(
                  backgroundColor: typeColors[type]!['color'],
                  label: Text(
                    type.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  avatar: Icon(
                    typeColors[type]!['icon'],
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Adopt a Pokemon section
        Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Adopt a Pokemon",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[300],
                ),
              ),
              Text(
                "View All",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),

        // Pokémon List (filtered)
        Expanded(
          child: FutureBuilder<List<Pokemon>>(
            future: futurePokemonList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No Pokémon found.'));
              } else {
                final pokemonList = snapshot.data!.where((pokemon) {
                  return pokemon.name.toLowerCase().contains(filter);
                }).toList();

                return ListView.builder(
                  itemCount: pokemonList.length,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final pokemon = pokemonList[index];
                    return PokemonCard(pokemon);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class PokemonCard extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonCard(this.pokemon, {super.key});

  @override
  _PokemonCardState createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  bool isFavorite = false;

  Color getTypeColor(String type) {
    final typeColor = typeColors[type.toLowerCase()]?['color'];
    return typeColor ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  widget.pokemon.image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: getTypeColor(widget.pokemon.type),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.pokemon.type.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pokemon.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.pokemon.type,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
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