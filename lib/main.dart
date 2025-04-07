import 'package:flutter/material.dart';
import 'package:quiz_one/pages/page_free.dart';
import 'package:quiz_one/pages/page_photos.dart';
import 'package:quiz_one/pages/page_picture.dart';
import 'package:quiz_one/pages/page_registration.dart';
import 'package:quiz_one/pages/page_about.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        drawer: Drawer(
          child: ListView(
            children: [
              DrwHeader(),
              DrwListView(),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> pokemonList = [
    {"name": "Biyomon", "type": "Flying", "image": 'assets/biyomon.png'},
    {"name": "Charizard", "type": "Fire", "image": "assets/charizard.png"},
    {"name": "Chespin", "type": "Grass", "image": "assets/chespin.png"},
    {"name": "Diggerby", "type": "Ground", "image": "assets/diggerby.png"},
    {"name": "Froakie", "type": "Water", "image": "assets/froakie.png"},
    {"name": "Greymon", "type": "Fire", "image": "assets/greymon.png"},
    {"name": "Pawmi", "type": "Electric", "image": "assets/Pawmi.png"},
    {"name": "Pikachu", "type": "Electric", "image": "assets/pikachu.png"},
    {"name": "Shoutmon", "type": "Fire", "image": "assets/shoutmon.png"},
    {"name": "Snivy", "type": "Grass", "image": "assets/snivy.png"},
    {"name": "Squirtle", "type": "Water", "image": "assets/squirty.png"},
    {"name": "Tepig", "type": "Fire", "image": "assets/tepig.png"},
    {"name": "Togepi", "type": "Fairy", "image": "assets/togepi.png"},
    {"name": "Victini", "type": "Psychic", "image": "assets/victini.png"},
  ];
  String filter = "";
  String selectedType = "";

  Map<String, dynamic> getTypeProperties(String type) {
    switch (type) {
      case "Electric":
        return {"icon": Icons.flash_on, "color": Colors.yellow};
      case "Fire":
        return {"icon": Icons.local_fire_department, "color": Colors.red};
      case "Water":
        return {"icon": Icons.water_drop, "color": Colors.blue};
      case "Grass":
        return {"icon": Icons.grass, "color": Colors.green};
      case "Ice":
        return {"icon": Icons.ac_unit, "color": Colors.tealAccent};
      case "Psychic":
        return {"icon": Icons.adjust_rounded, "color": Colors.deepPurple};
      case "Fairy":
        return {"icon": Icons.local_florist, "color": Colors.lime};
      default:
        return {"icon": Icons.help_outline, "color": Colors.grey};
    }
  }

  Widget getPokemonImage(String imagePath) {
    if (imagePath.isEmpty || !imagePath.contains("assets/")) {
      return Image.asset("assets/placeholder.png", height: 300);
    }
    return Image.asset(imagePath, height: 300);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ["Electric", "Fire", "Water", "Grass", "Ice", "Psychic", "Fairy"].map((type) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: FilterChip(
                  label: Icon(getTypeProperties(type)['icon']),
                  backgroundColor: getTypeProperties(type)['color'],
                  selected: selectedType == type,
                  onSelected: (selected) {
                    setState(() {
                      selectedType = selected ? type : "";
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                getPokemonImage("assets/Pawmi.png"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Pawmi",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Icon(getTypeProperties("Electric")['icon'], color: getTypeProperties("Electric")['color']),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: pokemonList
                .where((pokemon) {
              bool nameMatches = pokemon["name"]!.toLowerCase().contains(filter);
              bool typeMatches = selectedType.isEmpty || pokemon["type"] == selectedType;
              return nameMatches && typeMatches;
            })
                .map((pokemon) => PokemonCard(pokemon, getTypeProperties))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class PokemonCard extends StatelessWidget {
  final Map<String, String> pokemon;
  final Function getTypeProperties;

  const PokemonCard(this.pokemon, this.getTypeProperties, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typeProperties = getTypeProperties(pokemon["type"]!);

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Image.asset(pokemon["image"]!, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(
          pokemon["name"]!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(pokemon["type"]!),
        trailing: Icon(typeProperties['icon'], color: typeProperties['color']),
      ),
    );
  }
}


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

class DrwHeader extends StatefulWidget{
  @override
  _Drwheader createState() => _Drwheader();
}
class _Drwheader extends State<DrwHeader> {
  @override
  Widget build(BuildContext context){
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/pokebanner.jpg"), // Replace with your actual image path
          fit: BoxFit.cover, // Ensures the image covers the entire background
        ),
      ),
      child: Column(
        children:[
          CircleAvatar(
            backgroundImage: AssetImage('assets/avatar.png'),
            radius: 40,
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6), // Translucent background
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Amado Ketchum',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                  fontFamily: 'DM-Sans'
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class DrwListView extends StatefulWidget{
  @override
  _DrwListView createState() => _DrwListView();
}
class _DrwListView extends State<DrwListView>{
  @override
  Widget build(BuildContext context){
    return Padding(padding: EdgeInsets.zero,
      child:Column(
        children: [
          ListTile(
              title: Text("Register your Pokemon",
                style: TextStyle(
                    fontFamily: 'DM-Sans'),
              ),
              leading: Icon(Icons.login_outlined),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:
                      (context) => const page_registration()),
                )
              }
          ),
          ListTile(
              title: Text("Photo Album",
                style: TextStyle(
                    fontFamily: 'DM-Sans'
                ),),
              leading: Icon(Icons.photo_album),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:
                      (context) => const page_photos()),
                )
              }
          ),
          // ListTile(
          //     title: Text("Show Picture"),
          //     leading: Icon(Icons.photo),
          //     onTap: () => {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder:
          //             (context) => const page_picture()),
          //       )
          //     }
          // ),
          ListTile(
              title: Text("About"),
              leading: Icon(Icons.book_online),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:
                      (context) => const page_about()),
                )
              }
          ),
          ListTile(
              title: Text("Care 101"),
              leading: Icon(Icons.catching_pokemon_sharp),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:
                      (context) => const page_free()),
                )
              }
          )
        ],
      ),
    );
  }
}
