import 'package:flutter/material.dart';
import 'package:quiz_one/pages/page_free.dart';
import 'package:quiz_one/pages/page_photos.dart';
import 'package:quiz_one/pages/page_picture.dart';
import 'package:quiz_one/pages/page_registration.dart';

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
        title: 'Kanto Region Pokemons'),
    GalleryItem(
        mainImage: 'assets/diggerby.png',
        subImages: ['assets/froakie.png', 'assets/chespin.png'],
        title: 'Kalos Region Pokemons'),
    GalleryItem(
        mainImage: 'victini.png',
        subImages: ['snivy.png', 'tepig.png'],
        title: 'Unova Region Pokemons'),
    GalleryItem(
        mainImage: 'greymon.png',
        subImages: ['shoutmon.png', 'biyomon.png'],
        title: 'Digimon'),
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
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFFFFCC01),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/avatar.jpg'),
                    radius: 40,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "User",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                      title: Text("Registration"),
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
                      title: Text("Photo Album"),
                      leading: Icon(Icons.photo_album),
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder:
                              (context) => const page_photos()),
                        )
                      }
                  ),
                  ListTile(
                      title: Text("Show Picture"),
                      leading: Icon(Icons.photo),
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder:
                              (context) => const page_picture()),
                        )
                      }
                  ),
                  ListTile(
                      title: Text("About"),
                      leading: Icon(Icons.catching_pokemon),
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder:
                              (context) => const page_picture()),
                        )
                      }
                  ),
                  ListTile(
                      title: Text("Free Page"),
                      leading: Icon(Icons.abc),
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
            ),
          ],
        ),
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
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _currentIndex > 0 ? _previousGallery : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    minimumSize: const Size(120, 40),
                  ),
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed:
                  _currentIndex < _galleryItems.length - 1 ? _nextGallery : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    minimumSize: const Size(120, 40),
                  ),
                  child: const Text('Next'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
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

  GalleryItem({
    required this.mainImage,
    required this.subImages,
    required this.title,
  });
}
