import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
      image: 'assets/pikachu.png',
      title: 'Pikachu',
      description: 'An Electric-type Pokémon and the most iconic of all Pokémon. Pikachu can generate electricity from the electric sacs in its cheeks.',
      crossAxisCellCount: 2,
      mainAxisCellCount: 2,
    ),
    GalleryItem(
      image: 'assets/charizard.png',
      title: 'Charizard',
      description: 'A Fire/Flying-type Pokémon. Charizard is known for its powerful flame that can melt anything. It flies around the sky in search of powerful opponents.',
      crossAxisCellCount: 1,
      mainAxisCellCount: 1,
    ),
    GalleryItem(
      image: 'assets/squirty.png',
      title: 'Squirtle',
      description: 'A Water-type Pokémon known for its ability to shoot water from its mouth. Its shell is not just for protection, but also helps in improving its swimming abilities.',
      crossAxisCellCount: 1,
      mainAxisCellCount: 1,
    ),
    GalleryItem(
      image: 'assets/victini.png',
      title: 'Victini',
      description: 'A Psychic/Fire-type Mythical Pokémon. Victini is said to bring victory to any Trainer who catches it. It creates an unlimited supply of energy inside its body.',
      crossAxisCellCount: 2,
      mainAxisCellCount: 1,
    ),
    GalleryItem(
      image: 'assets/froakie.png',
      title: 'Froakie',
      description: 'A Water-type Pokémon. Froakie is known for its bubbles on its back and neck, which serve as a cushion and help protect it from attacks.',
      crossAxisCellCount: 1,
      mainAxisCellCount: 1,
    ),
    GalleryItem(
      image: 'assets/diggerby.png',
      title: 'Diggersby',
      description: 'A Normal/Ground-type Pokémon. Diggersby can use its powerful ears as excavation tools and is known for its impressive digging capabilities.',
      crossAxisCellCount: 1,
      mainAxisCellCount: 1,
    ),
    GalleryItem(
      image: 'assets/chespin.png',
      title: 'Chespin',
      description: 'A Grass-type Pokémon. Chespin has a tough shell covering its head and back. This shell can protect Chespin from powerful attacks.',
      crossAxisCellCount: 1,
      mainAxisCellCount: 2,
    ),
    GalleryItem(
      image: 'assets/snivy.png',
      title: 'Snivy',
      description: 'A Grass-type Pokémon. Snivy is very intelligent and calm. It can photosynthesize by exposing its tail to sunlight, which makes it move more quickly.',
      crossAxisCellCount: 1,
      mainAxisCellCount: 1,
    ),
    GalleryItem(
      image: 'assets/tepig.png',
      title: 'Tepig',
      description: 'A Fire-type Pokémon. Tepig can blow fire from its snout. It roasts berries before eating them and has an excellent sense of smell.',
      crossAxisCellCount: 1,
      mainAxisCellCount: 1,
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
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: MasonryGridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
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
                child: Hero(
                  tag: 'pokemon-$index',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        item.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
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
                                  child: Image.asset(
                                    item.image,
                                    fit: BoxFit.contain,
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
                  ],
                ),
              ),
            ],
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
  final int crossAxisCellCount;
  final int mainAxisCellCount;

  GalleryItem({
    required this.image,
    required this.title,
    required this.description,
    this.crossAxisCellCount = 1,
    this.mainAxisCellCount = 1,
  });
}