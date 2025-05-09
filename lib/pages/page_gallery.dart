import 'package:flutter/material.dart';
import 'package:quiz_one/pages/drawer/drawer_header.dart';
import 'package:quiz_one/pages/drawer/drawer_list_view.dart';

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
  final List<GalleryItem> _galleryItems = [
    GalleryItem(
      image: 'assets/squirty.png',
      title: 'Squirtle',
      description: 'A Water-type Pokémon known for its ability to shoot water from its mouth. Its shell is not just for protection, but also helps in improving its swimming abilities.',
      widthRatio: 1.0,
      heightRatio: 1.0,
    ),
    GalleryItem(
      image: 'assets/pikachu.png',
      title: 'Pikachu',
      description: 'An Electric-type Pokémon and the most iconic of all Pokémon. Pikachu can generate electricity from the electric sacs in its cheeks.',
      widthRatio: 0.85,
      heightRatio: 1.15,
    ),
    GalleryItem(
      image: 'assets/charizard.png',
      title: 'Charizard',
      description: 'A Fire/Flying-type Pokémon. Charizard is known for its powerful flame that can melt anything. It flies around the sky in search of powerful opponents.',
      widthRatio: 1.25,
      heightRatio: 0.75,
    ),
    GalleryItem(
      image: 'assets/diggerby.png',
      title: 'Diggersby',
      description: 'A Normal/Ground-type Pokémon. Diggersby can use its powerful ears as excavation tools and is known for its impressive digging capabilities.',
      widthRatio: 1.18,
      heightRatio: 0.82,
    ),
    GalleryItem(
      image: 'assets/froakie.png',
      title: 'Froakie',
      description: 'A Water-type Pokémon. Froakie is known for its bubbles on its back and neck, which serve as a cushion and help protect it from attacks.',
      widthRatio: 0.75,
      heightRatio: 1.25,
    ),
    GalleryItem(
      image: 'assets/chespin.png',
      title: 'Chespin',
      description: 'A Grass-type Pokémon. Chespin has a tough shell covering its head and back. This shell can protect Chespin from powerful attacks.',
      widthRatio: 0.95,
      heightRatio: 1.05,
    ),
    GalleryItem(
      image: 'assets/victini.png',
      title: 'Victini',
      description: 'A Psychic/Fire-type Mythical Pokémon. Victini is said to bring victory to any Trainer who catches it. It creates an unlimited supply of energy inside its body.',
      widthRatio: 0.83,
      heightRatio: 1.17,
    ),
    GalleryItem(
      image: 'assets/snivy.png',
      title: 'Snivy',
      description: 'A Grass-type Pokémon. Snivy is very intelligent and calm. It can photosynthesize by exposing its tail to sunlight, which makes it move more quickly.',
      widthRatio: 1.15,
      heightRatio: 0.85,
    ),
    GalleryItem(
      image: 'assets/tepig.png',
      title: 'Tepig',
      description: 'A Fire-type Pokémon. Tepig can blow fire from its snout. It roasts berries before eating them and has an excellent sense of smell.',
      widthRatio: 0.92,
      heightRatio: 1.08,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokemon Gallery"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Forces sharp 90° corners
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrwHeader(),
            DrwListView(currentRoute: "/gallery"),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemCount: _galleryItems.length,
            itemBuilder: (context, index) {
              final item = _galleryItems[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => GalleryDetailView(
                        galleryItems: _galleryItems,
                        initialIndex: index,
                      ),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;
                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Create non-uniform dimensions
                      final double itemSize = constraints.maxWidth;
                      final double adjustedHeight = itemSize * (item.heightRatio / item.widthRatio);

                      return Hero(
                        tag: 'pokemon-$index',
                        child: Container(
                          height: adjustedHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              item.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class GalleryDetailView extends StatefulWidget {
  final List<GalleryItem> galleryItems;
  final int initialIndex;

  const GalleryDetailView({
    super.key,
    required this.galleryItems,
    required this.initialIndex,
  });

  @override
  State<GalleryDetailView> createState() => _GalleryDetailViewState();
}

class _GalleryDetailViewState extends State<GalleryDetailView> {
  late PageController _pageController;
  late int _currentIndex;
  late double _currentPage;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _currentPage = widget.initialIndex.toDouble();
    _pageController = PageController(initialPage: _currentIndex);
    _pageController.addListener(_pageListener);
  }

  void _pageListener() {
    setState(() {
      _currentPage = _pageController.page!;
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }

  void _nextGallery() {
    if (_currentIndex < widget.galleryItems.length - 1) {
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
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background with blurred current pokemon
          Positioned.fill(
            child: _currentIndex < widget.galleryItems.length
                ? ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                widget.galleryItems[_currentIndex].image,
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.2),
              ),
            )
                : Container(color: Colors.black),
          ),

          // Main Content
          Column(
            children: [
              // PageView for swiping through Pokemon
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: widget.galleryItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.galleryItems[index];
                    final scale = 1.0 - (0.1 * (_currentPage - index).abs());

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Pokemon image
                          Expanded(
                            flex: 5,
                            child: Center(
                              child: Hero(
                                tag: 'pokemon-$index',
                                child: Transform.scale(
                                  scale: scale.clamp(0.8, 1.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.yellow.withOpacity(0.3),
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      item.image,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
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
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.withOpacity(0.3)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
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
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Indicator dots
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.galleryItems.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: _currentIndex == index ? 12 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index ? const Color(0xFFFFCC01) : Colors.grey,
                      ),
                    );
                  }),
                ),
              ),

              // Navigation controls at the bottom
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
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
                      '${_currentIndex + 1} / ${widget.galleryItems.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
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
                          child: const Text('Back to Gallery'),
                        ),
                        const SizedBox(width: 40),

                        // Next button
                        _buildArrowButton(
                          icon: Icons.arrow_forward_rounded,
                          onTap: _currentIndex < widget.galleryItems.length - 1 ? _nextGallery : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
          color: onTap != null ? const Color(0xFFFFCC01) : Colors.grey[700],
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
}

class GalleryItem {
  final String image;
  final String title;
  final String description;
  final double widthRatio;
  final double heightRatio;

  GalleryItem({
    required this.image,
    required this.title,
    required this.description,
    this.widthRatio = 1.0,
    this.heightRatio = 1.0,
  });
}