import 'package:flutter/material.dart';

// Main StatelessWidget container
class page_photos extends StatelessWidget {
  const page_photos({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Pokemon Gallery",
      home: GalleryHome(),
    );
  }
}

// StatefulWidget for the gallery
class GalleryHome extends StatefulWidget {
  const GalleryHome({super.key});

  @override
  State<GalleryHome> createState() => _GalleryHomeState();
}

// State class for the gallery
class _GalleryHomeState extends State<GalleryHome> {
  int _currentIndex = 0;

  // Images
  final List<GalleryItem> _galleryItems = [
    GalleryItem(
        mainImage: 'squirty.png',
        subImages: ['pikachu.png', 'charizard.png'],
        title: 'Kanto Region Pokemons'
    ),
    GalleryItem(
        mainImage: 'diggerby.png',
        subImages: ['froakie.png', 'chespin.png'],
        title: 'Kalos Region Pokemons'
    ),
    // Can add more. penge suggestions
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Large top image
            Image.asset(
              _galleryItems[_currentIndex].mainImage,
              height: 200,
              width: double.infinity,
              fit: BoxFit.contain,
            ),

            // Row with two square images
            Row(
              children: [
                // Left square image
                Expanded(
                  child: Container(
                    height: 150,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.hardEdge,  // This replaces overflow: Overflow.hidden
                    child: Image.asset(
                      _galleryItems[_currentIndex].subImages[0],
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                // Right square image
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
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Title text
            Text(
              _galleryItems[_currentIndex].title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            // Navigation buttons
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
                  onPressed: _currentIndex < _galleryItems.length - 1 ? _nextGallery : null,
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

// Data model for gallery items
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