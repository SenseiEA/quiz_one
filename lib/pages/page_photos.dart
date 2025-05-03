import 'package:flutter/material.dart';
import 'package:quiz_one/pages/page_about.dart';
import 'package:quiz_one/pages/page_free.dart';
import 'package:quiz_one/pages/page_picture.dart';
import 'package:quiz_one/pages/page_registration.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      widthRatio: 0.9,
      heightRatio: 1.1,
    ),
    GalleryItem(
      image: 'assets/charizard.png',
      title: 'Charizard',
      description: 'A Fire/Flying-type Pokémon. Charizard is known for its powerful flame that can melt anything. It flies around the sky in search of powerful opponents.',
      widthRatio: 1.2,
      heightRatio: 0.8,
    ),
    GalleryItem(
      image: 'assets/diggerby.png',
      title: 'Diggersby',
      description: 'A Normal/Ground-type Pokémon. Diggersby can use its powerful ears as excavation tools and is known for its impressive digging capabilities.',
      widthRatio: 1.1,
      heightRatio: 0.9,
    ),
    GalleryItem(
      image: 'assets/froakie.png',
      title: 'Froakie',
      description: 'A Water-type Pokémon. Froakie is known for its bubbles on its back and neck, which serve as a cushion and help protect it from attacks.',
      widthRatio: 0.8,
      heightRatio: 1.2,
    ),
    GalleryItem(
      image: 'assets/chespin.png',
      title: 'Chespin',
      description: 'A Grass-type Pokémon. Chespin has a tough shell covering its head and back. This shell can protect Chespin from powerful attacks.',
      widthRatio: 1.0,
      heightRatio: 1.0,
    ),
    GalleryItem(
      image: 'assets/victini.png',
      title: 'Victini',
      description: 'A Psychic/Fire-type Mythical Pokémon. Victini is said to bring victory to any Trainer who catches it. It creates an unlimited supply of energy inside its body.',
      widthRatio: 0.9,
      heightRatio: 1.1,
    ),
    GalleryItem(
      image: 'assets/snivy.png',
      title: 'Snivy',
      description: 'A Grass-type Pokémon. Snivy is very intelligent and calm. It can photosynthesize by exposing its tail to sunlight, which makes it move more quickly.',
      widthRatio: 1.1,
      heightRatio: 0.9,
    ),
    GalleryItem(
      image: 'assets/tepig.png',
      title: 'Tepig',
      description: 'A Fire-type Pokémon. Tepig can blow fire from its snout. It roasts berries before eating them and has an excellent sense of smell.',
      widthRatio: 1.0,
      heightRatio: 1.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GALLERY"),
        backgroundColor: Colors.yellow,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrwHeader(),
            DrwListView(currentRoute: "/gallery"),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFFFF0F5),  // Very light pink
              Color(0xFFFFD1DC),  // Light pink
              Color(0xFFFFB6C1),  // Light magenta
            ],
            stops: [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.8,
            ),
            itemCount: _galleryItems.length,
            itemBuilder: (context, index) {
              final item = _galleryItems[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GalleryDetailView(
                        galleryItems: _galleryItems,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'image-$index',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      item.image,
                      fit: BoxFit.cover,
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
  _GalleryDetailViewState createState() => _GalleryDetailViewState();
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
      backgroundColor: Colors.transparent, // Make scaffold transparent
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5), // Semi-transparent black
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Blurred background that shows the gallery
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[800]!.withOpacity(0.85), // Dark gray with transparency
            ),
          ),

          // Page view for images
          _buildPageView(),

          // Indicator dots
          _buildIndicator(),

          // Info panel at bottom
          _buildInfoPanel(),
        ],
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.galleryItems.length,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemBuilder: (context, index) {
        final item = widget.galleryItems[index];
        final scale = 1.0 - (0.1 * (_currentPage - index).abs());

        return Center(
          child: Hero(
            tag: 'image-$index',
            child: Transform.scale(
              scale: scale.clamp(0.8, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
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
        );
      },
    );
  }

  Widget _buildIndicator() {
    return Positioned(
      top: 40,
      left: 0,
      right: 0,
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
              color: _currentIndex == index ? Colors.white : Colors.white54,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildInfoPanel() {
    final item = widget.galleryItems[_currentIndex];

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
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

// Keep all the drawer-related classes (DrwHeader, DrwListView) exactly the same as in your original code
class DrwHeader extends StatefulWidget {
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
    required IconData icon,
    required String route,
    required Function() onTap,
  }) {
    bool isActive = widget.currentRoute == route;

    return Container(
      decoration: isActive
          ? BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF7FF10),
            Color(0xFFFFB7D6),
          ],
        ),
      )
          : null,
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: TextStyle(fontFamily: 'DM-Sans'),
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        buildListTile(
          title: "Registration",
          icon: Icons.login_outlined,
          route: "/registration",
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const page_registration()),
            );
          },
        ),
        buildListTile(
          title: "Photo Album",
          icon: Icons.photo_album,
          route: "/gallery",
          onTap: () {
            Navigator.pop(context);
          },
        ),
        buildListTile(
          title: "Show Picture",
          icon: Icons.photo,
          route: "/picture",
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const page_picture()),
            );
          },
        ),
        buildListTile(
          title: "About",
          icon: Icons.catching_pokemon,
          route: "/about",
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const page_about()),
            );
          },
        ),
        buildListTile(
          title: "Free Page",
          icon: Icons.abc,
          route: "/free",
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const page_free()),
            );
          },
        ),
      ],
    );
  }
}