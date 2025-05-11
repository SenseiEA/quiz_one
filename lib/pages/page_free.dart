import 'package:flutter/material.dart';
import 'package:quiz_one/pages/stateless/page_about.dart';
import 'package:quiz_one/pages/page_gallery.dart';
import 'package:quiz_one/pages/auth/page_registration.dart';
import 'package:quiz_one/pages/drawer/drawer_header.dart';
import 'package:quiz_one/pages/drawer/drawer_list_view.dart';

class page_free extends StatefulWidget {
  const page_free({super.key});

  @override
  State<page_free> createState() => _PageFreeState();
}

class _PageFreeState extends State<page_free> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _topAlignmentAnimation = TweenSequence<Alignment>(
      [
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1,
        ),
      ],
    ).animate(_controller);

    _bottomAlignmentAnimation = TweenSequence<Alignment>(
      [
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1,
        ),
      ],
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "POKÉMON CARE 101",
          style: TextStyle(
            fontSize: 22,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrwHeader(),
            DrwListView(currentRoute: "/contact"),
          ],
        ),
      ),
      body: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Color(0xffF6F3FD),
                      Color(0xffFFE2E5),
                      Color(0xffDFECB4),
                    ],
                    begin: _topAlignmentAnimation.value,
                    end: _bottomAlignmentAnimation.value,
                  )
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Title Section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Take Care of Your Pokémon!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    // Pokémon Care Tips Carousel
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() => _currentIndex = index);
                        },
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return _buildCareTipCard(index);
                        },
                      ),
                    ),

                    // Dots Indicator
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) => _buildDotIndicator(index)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }

  Widget _buildCareTipCard(int index) {
    // List of local image paths
    final List<String> imagePaths = [
      'assets/tip1.png',
      'assets/tip2.png',
      'assets/tip3.png',
      'assets/tip4.png',
      'assets/tip5.png',
    ];

    // Get the type color based on index
    Color cardColor;
    switch (index) {
      case 0: // Health - Pink
        cardColor = Color(0xFFFF6B8B);
        break;
      case 1: // Diet - Green
        cardColor = Color(0xFF7AC74C);
        break;
      case 2: // Exercise - Orange
        cardColor = Color(0xFFFF9F45);
        break;
      case 3: // Mental - Purple
        cardColor = Color(0xFF9370DB);
        break;
      case 4: // Grooming - Blue
        cardColor = Color(0xFF3399FF);
        break;
      default:
        cardColor = Colors.blueGrey;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      // Full card image
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: cardColor.withOpacity(0.2),
          ),
          child: Image.asset(
            imagePaths[index],
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildDotIndicator(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: _currentIndex == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentIndex == index ? Colors.amber : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}