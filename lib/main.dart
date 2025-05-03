import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quiz_one/pages/page_free.dart';
import 'package:quiz_one/pages/page_photos.dart';
//import 'package:quiz_one/pages/page_picture.dart';
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
class MyAppHome extends StatelessWidget {
  //final String userName;  // Add the userName variable
  const MyAppHome({super.key});//, required this.userName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Poke-Adopt!",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow,
          title: const Text(
            "Poke-Adopt!",
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
              DrwHeader(),
              DrwListView(currentRoute: "/home"),//Replace "home" with current route
            ],
          ),
        ),
        //End Copy
      ),
    );
  }
}

class DrwHeader extends StatefulWidget{
  @override
  _Drwheader createState() => _Drwheader();
}
class _Drwheader extends State<DrwHeader> {
  String userName = 'Guest';
  String email = 'test@email.com';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Guest';
      email = prefs.getString('email') ?? 'test@email.com';
      //do $userName or $email in Widget texts for testing
    });
  }

  @override
  Widget build(BuildContext context){
    return DrawerHeader(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/avatar.png'),
            radius: 28,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Hello, $userName!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'DM-Sans',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class DrwListView extends StatefulWidget {
  final String currentRoute;
  DrwListView({required this.currentRoute});

  @override
  _DrwListView createState() => _DrwListView();
}
class _DrwListView extends State<DrwListView> {
  Widget buildListTile({
    required String title,
    required String route,
    required String assetPath,
    required Widget page,
  }) {
    bool isActive = widget.currentRoute == route;

    return Container(
      decoration: isActive
          ? BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF7FF10), // custom yellow
            Color(0xFFFFB7D6), // custom pink
          ],
        ),
      )
          : null,
      child: ListTile(
        leading: Image.asset(
          assetPath,
          width: 20,
          height: 20,
        ),
        title: Text(
          title,
          style: TextStyle(fontFamily: 'DM-Sans'),
        ),
        onTap: () {
          if (!isActive) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          buildListTile(
            title: "Home",
            route: "/home",
            assetPath: 'assets/home.png',
            page: const MyAppHome(),
          ),
          buildListTile(
            title: "Gallery",
            route: "/gallery",
            assetPath: 'assets/gallery.png',
            page: const page_photos(),
          ),
          buildListTile(
            title: "Pokemon Interests",
            route: "/interests",
            assetPath: 'assets/poke_interest.png',
            page: const page_about(),
          ),
          buildListTile(
            title: "Adoption Application",
            route: "/adopt",
            assetPath: 'assets/adopt_app.png',
            page: const page_about(),
          ),
          buildListTile(
            title: "About",
            route: "/about",
            assetPath: 'assets/about.png',
            page: const page_about(),
          ),
          buildListTile(
            title: "Contact",
            route: "/contact",
            assetPath: 'assets/contact.png',
            page: const page_free(),
          ),
          Container(
            child: ListTile(
              leading: Image.asset(
                'assets/logout.png',
                width: 20,
                height: 20,
              ),
              title: Text("Logout"),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('userName');
                await prefs.remove('email');
                await prefs.setBool('isLoggedIn', false);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const page_login()),
                );
              },
            ),
          )
        ],
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


class TxtFieldSection extends StatelessWidget {
  const TxtFieldSection ({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(30),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(child:
                  Text(
                    "K E V I N .exe",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  ),
                ],
              ),
            ]
        )
    );
  }
}

//WITHOUT API
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
//
// class _HomePageState extends State<HomePage> {
//   final List<Map<String, String>> pokemonList = [
//     {"name": "Biyomon", "type": "Flying", "image": 'assets/biyomon.png'},
//     {"name": "Charizard", "type": "Fire", "image": "assets/charizard.png"},
//     {"name": "Chespin", "type": "Grass", "image": "assets/chespin.png"},
//     {"name": "Diggerby", "type": "Ground", "image": "assets/diggerby.png"},
//     {"name": "Froakie", "type": "Water", "image": "assets/froakie.png"},
//     {"name": "Greymon", "type": "Fire", "image": "assets/greymon.png"},
//     {"name": "Pawmi", "type": "Electric", "image": "assets/Pawmi.png"},
//     {"name": "Pikachu", "type": "Electric", "image": "assets/pikachu.png"},
//     {"name": "Shoutmon", "type": "Fire", "image": "assets/shoutmon.png"},
//     {"name": "Snivy", "type": "Grass", "image": "assets/snivy.png"},
//     {"name": "Squirtle", "type": "Water", "image": "assets/squirty.png"},
//     {"name": "Tepig", "type": "Fire", "image": "assets/tepig.png"},
//     {"name": "Togepi", "type": "Fairy", "image": "assets/togepi.png"},
//     {"name": "Victini", "type": "Psychic", "image": "assets/victini.png"},
//   ];
//   String filter = "";
//

//
//
//         Expanded(
//           child: ListView(
//             children: pokemonList
//                 .where((pokemon) => pokemon["name"]!.toLowerCase().contains(filter))
//                 .map((pokemon) => PokemonCard(pokemon, typeColors))
//                 .toList(),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class PokemonCard extends StatelessWidget {
//   final Map<String, String> pokemon;
//   final Map<String, Map<String, dynamic>> typeColors;
//   const PokemonCard(this.pokemon, this.typeColors, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       child: ListTile(
//         leading: Image.asset(pokemon["image"]!, width: 50, height: 50),
//         title: Text(pokemon["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
//         trailing: Icon(
//           typeColors[pokemon["type"]]?["icon"] ?? Icons.help_outline,
//           color: typeColors[pokemon["type"]]?["color"] ?? Colors.grey,
//         ),
//       ),
//     );
//   }
// }
//

//WITH API

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Pokemon>> futurePokemonList;
  String filter = "";
  Pokemon? featuredPokemon; // Add this to hold a random Pokémon
  String userName = 'Guest';
  String email = 'test@email.com';

  @override
  void initState() {
    super.initState();
    futurePokemonList = PokeApiService().fetchPokemonList(50);
    futurePokemonList.then((list) {
      if (list.isNotEmpty) {
        final random = Random();
        setState(() {
          featuredPokemon = list[random.nextInt(list.length)];
        });
      }
    });

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Guest';
      email = prefs.getString('email') ?? 'test@email.com';
      //do $userName or $email in Widget texts for testing
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔻 Location header
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: Colors.amber),
              SizedBox(width: 5),
              Text("Manila, PH", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),

        // 🔻 Search bar
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search Pokemon...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                filter = value.toLowerCase();
              });
            },
          ),
        ),

        // 🔻 Type filters (optional)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: typeColors.keys.map((type) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: FilterChip(
                  label: Icon(typeColors[type]!['icon']),
                  backgroundColor: typeColors[type]!['color'],
                  onSelected: (selected) {}, // Filtering logic here if needed
                ),
              );
            }).toList(),
          ),
        ),

        // 🔻 Featured Pokémon card
        if (featuredPokemon != null)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Image.network(featuredPokemon!.image, height: 300),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          featuredPokemon!.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          typeColors[featuredPokemon!.type]?['icon'] ?? Icons.catching_pokemon,
                          color: typeColors[featuredPokemon!.type]?['color'] ?? Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonCard(this.pokemon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Image.network(pokemon.image, width: 50, height: 50), // Access pokemon.image
        title: Text(pokemon.name, style: const TextStyle(fontWeight: FontWeight.bold)), // Access pokemon.name
        subtitle: Text(pokemon.type, style: TextStyle(color: Colors.grey)), // Access pokemon.type
      ),
    );
  }
}