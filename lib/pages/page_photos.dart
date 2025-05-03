import 'package:flutter/material.dart';
import 'package:quiz_one/pages/stateless/page_about.dart';
import 'package:quiz_one/pages/page_free.dart';
import 'package:quiz_one/pages/page_picture.dart';
import 'package:quiz_one/pages/auth/page_registration.dart';

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
  late PageController _pageController;
  int _currentIndex = 0;


  final List<GalleryItem> _galleryItems = [
    GalleryItem(
      image: 'assets/squirty.png',
      title: 'Squirtle',
      description: 'A Water-type Pokémon known for its ability to shoot water from its mouth. Its shell is not just for protection, but also helps in improving its swimming abilities.',
    ),
    GalleryItem(
      image: 'assets/pikachu.png',
      title: 'Pikachu',
      description: 'An Electric-type Pokémon and the most iconic of all Pokémon. Pikachu can generate electricity from the electric sacs in its cheeks.',
    ),
    GalleryItem(
      image: 'assets/charizard.png',
      title: 'Charizard',
      description: 'A Fire/Flying-type Pokémon. Charizard is known for its powerful flame that can melt anything. It flies around the sky in search of powerful opponents.',
    ),
    GalleryItem(
      image: 'assets/diggerby.png',
      title: 'Diggersby',
      description: 'A Normal/Ground-type Pokémon. Diggersby can use its powerful ears as excavation tools and is known for its impressive digging capabilities.',
    ),
    GalleryItem(
      image: 'assets/froakie.png',
      title: 'Froakie',
      description: 'A Water-type Pokémon. Froakie is known for its bubbles on its back and neck, which serve as a cushion and help protect it from attacks.',
    ),
    GalleryItem(
      image: 'assets/chespin.png',
      title: 'Chespin',
      description: 'A Grass-type Pokémon. Chespin has a tough shell covering its head and back. This shell can protect Chespin from powerful attacks.',
    ),
    GalleryItem(
      image: 'assets/victini.png',
      title: 'Victini',
      description: 'A Psychic/Fire-type Mythical Pokémon. Victini is said to bring victory to any Trainer who catches it. It creates an unlimited supply of energy inside its body.',
    ),
    GalleryItem(
      image: 'assets/snivy.png',
      title: 'Snivy',
      description: 'A Grass-type Pokémon. Snivy is very intelligent and calm. It can photosynthesize by exposing its tail to sunlight, which makes it move more quickly.',
    ),
    GalleryItem(
      image: 'assets/tepig.png',
      title: 'Tepig',
      description: 'A Fire-type Pokémon. Tepig can blow fire from its snout. It roasts berries before eating them and has an excellent sense of smell.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextGallery() {
    if (_currentIndex < _galleryItems.length - 1) {
      _pageController.animateToPage(
        _currentIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousGallery() {
    if (_currentIndex > 0) {
      _pageController.animateToPage(
        _currentIndex - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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
                        Navigator.pop(context);
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
                        Navigator.pop(context);
                      }
                  ),
                  ListTile(
                      title: const Text("Show Picture"),
                      leading: const Icon(Icons.photo),
                      onTap: () {
                        Navigator.pop(context);
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
                        Navigator.pop(context);
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
                        Navigator.pop(context);
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
      body: Column(
        children: [
         
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: _galleryItems.length,
              itemBuilder: (context, index) {
                return _buildPokemonCard(_galleryItems[index]);
              },
            ),
          ),

          // Navigation controls at the bottom
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Position indicator
                Text(
                  '${_currentIndex + 1} / ${_galleryItems.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),

                // Arrow buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Previous button
                    _buildArrowButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: _currentIndex > 0 ? _previousGallery : null,
                    ),
                    const SizedBox(width: 40),

                    // Back to main menu button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Back'),
                    ),
                    const SizedBox(width: 40),

                    // Next button
                    _buildArrowButton(
                      icon: Icons.arrow_forward_rounded,
                      onTap: _currentIndex < _galleryItems.length - 1 ? _nextGallery : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build stylized arrow buttons
  Widget _buildArrowButton({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: onTap != null ? const Color(0xFFFFCC01) : Colors.grey[300],
          shape: BoxShape.circle,
          boxShadow: onTap != null ? [
            BoxShadow(
              color: Colors.yellow.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ] : null,
        ),
        child: Icon(
          icon,
          color: onTap != null ? Colors.black : Colors.grey[500],
          size: 24,
        ),
      ),
    );
  }

  // Helper method to build each Pokémon card
  Widget _buildPokemonCard(GalleryItem item) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Pokemon image
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.asset(
                item.image,
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

          const SizedBox(height: 20),

          // Pokemon title
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFCC01),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Pokemon description
          // Pokemon description
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Text(
                item.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GalleryItem {
  final String image;
  final String title;
  final String description;

  GalleryItem({
    required this.image,
    required this.title,
    required this.description,
  });
}