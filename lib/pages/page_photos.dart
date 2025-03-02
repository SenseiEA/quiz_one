import 'package:flutter/material.dart';
import 'package:quiz_one/pages/page_about.dart';
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
        mainImage: 'assets/victini.png',
        subImages: ['assets/snivy.png', 'assets/tepig.png'],
        title: 'Unova Region Pokemons'),
    GalleryItem(
        mainImage: 'assets/greymon.png',
        subImages: ['assets/shoutmon.png', 'assets/biyomon.png'],
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
                      title: const Text("Registration"),
                      leading: const Icon(Icons.login_outlined),
                      onTap: () {
                        Navigator.pop(context); // Close drawer first
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder:
                              (context) => const page_registration()),
                        );
                      }
                  ),
                  ListTile(
                      title: const Text("Photo Album"),
                      leading: const Icon(Icons.photo_album),
                      onTap: () {
                        Navigator.pop(context); // Just close drawer, already on this page
                      }
                  ),
                  ListTile(
                      title: const Text("Show Picture"),
                      leading: const Icon(Icons.photo),
                      onTap: () {
                        Navigator.pop(context); // Close drawer first
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder:
                              (context) => const page_picture()),
                        );
                      }
                  ),
                  ListTile(
                      title: const Text("About"),
                      leading: const Icon(Icons.catching_pokemon),
                      onTap: () {
                        Navigator.pop(context); // Close drawer first
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder:
                              (context) => const page_about()),
                        );
                      }
                  ),
                  ListTile(
                      title: const Text("Free Page"),
                      leading: const Icon(Icons.abc),
                      onTap: () {
                        Navigator.pop(context); // Close drawer first
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder:
                              (context) => const page_free()),
                        );
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
            // Main image container with proper error handling
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Image.asset(
                _galleryItems[_currentIndex].mainImage,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Text('Image not available'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Sub-images row with consistent spacing and styling
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 150,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      _galleryItems[_currentIndex].subImages[0],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Text('Image not available'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 150,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      _galleryItems[_currentIndex].subImages[1],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Text('Image not available'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Title with proper styling
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFCC01).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _galleryItems[_currentIndex].title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            // Navigation buttons with consistent Pokemon theme
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _currentIndex > 0 ? _previousGallery : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFCC01),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(120, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, size: 16),
                      SizedBox(width: 4),
                      Text('Previous'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed:
                  _currentIndex < _galleryItems.length - 1 ? _nextGallery : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFCC01),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(120, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Next'),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Back button with distinct styling
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(120, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
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