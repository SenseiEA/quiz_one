import 'package:flutter/material.dart';
import 'package:quiz_one/pages/page_about.dart';
import 'package:quiz_one/pages/page_free.dart';
import 'package:quiz_one/pages/page_photos.dart';
import 'package:quiz_one/pages/page_picture.dart';
import 'package:quiz_one/pages/page_registration.dart';
import 'package:quiz_one/pages/page_about.dart';

import '../main.dart';

class page_photos extends StatelessWidget {
  const page_photos({super.key});

  @override
  Widget build(BuildContext context) {
    return const GalleryHome();
  }
}

class GalleryHome extends StatefulWidget {
  const GalleryHome({super.key});

  @override
  State<GalleryHome> createState() => _GalleryHomeState();
}

class _GalleryHomeState extends State<GalleryHome> {
  int _currentIndex = 0;

  final List<GalleryItem> _galleryItems = [
    GalleryItem(
        mainImage: 'assets/squirty.png',
        subImages: ['assets/pikachu.png', 'assets/charizard.png'],
        title: 'Kanto Region Pokemons',
        description: "The Original Kanto Region! Meet Squirtle, our strong-willed turtle friend, our best friend Pikachu, and Charmander, our lovable flame-lizard!"),
    GalleryItem(
        mainImage: 'assets/diggerby.png',
        subImages: ['assets/froakie.png', 'assets/chespin.png'],
        title: 'Kalos Region Pokemons',
        description:
        "In the Kalos Region, Diggersby can help you borrow tunnels, Froakie can move silently when the enemies don't look around, and Chespin, the spunky grass warrior!"),
    GalleryItem(
        mainImage: 'victini.png',
        subImages: ['snivy.png', 'tepig.png'],
        title: 'Unova Region Pokemons',
        description:
        "The Unovans have agreed to donate lost pokemons who are in needing of a home! Meet Victini, they love victory, Snivy, the chill guy, and Tepig, the adorable flame piggy!"),
    GalleryItem(
        mainImage: 'greymon.png',
        subImages: ['shoutmon.png', 'biyomon.png'],
        title: 'Digimon',
        description:
        "Wait a second... These aren’t Pokémon! These are Digimons! Where did they come from?! It's Greymon the fierce fire-breathing dinosaur with its energetic friend, Shoutmon, and Biyomon, the skypiercer! They need our attention too!"),
  ];


  void _nextGallery() {
    setState(() {
      if (_currentIndex < _galleryItems.length - 1) {
        _currentIndex++;
      }
    });
  }

  void _previousGallery() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokemon Gallery"),
        backgroundColor: Colors.yellow,
      ),
      drawer: Drawer(
          child: ListView(
            children: [
              DrwHeader(),
              DrwListView()

            ],
          )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              _galleryItems[_currentIndex].mainImage,
              height: 200,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 150,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      _galleryItems[_currentIndex].subImages[0],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 150,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      _galleryItems[_currentIndex].subImages[1],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              _galleryItems[_currentIndex].title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _galleryItems[_currentIndex].description,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 300),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _currentIndex > 0 ? _previousGallery : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFCC01),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                        child: Text(
                          "Previous",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // Back Button
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 300),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                        _currentIndex < _galleryItems.length - 1 ? _nextGallery : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFCC01),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                child: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GalleryItem {
  final String mainImage;
  final List<String> subImages;
  final String title;
  final String description;

  GalleryItem({
    required this.mainImage,
    required this.subImages,
    required this.title,
    required this.description,
  });
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
          image: AssetImage("pokebanner.jpg"), // Replace with your actual image path
          fit: BoxFit.cover, // Ensures the image covers the entire background
        ),
      ),
      child: Column(
        children:[
          CircleAvatar(
            backgroundImage: AssetImage('avatar.png'),
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



