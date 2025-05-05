import 'package:flutter/material.dart';

import '../drawer/drawer_header.dart';
import '../drawer/drawer_list_view.dart';

class page_aboutus extends StatelessWidget {
  const page_aboutus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "About Poke-Adapt",
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "About",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DM-Sans'
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [const Color(0xFFD0FB7B), Colors.white],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft
                )
            ),
          ),
          elevation: 0,
        ),
        body: AboutPage(),
        drawer: Drawer(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Forces sharp 90° corners
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrwHeader(),
              DrwListView(currentRoute: "/about"),//Replace "home" with current route
            ],
          ),
        ),
      )
    );
  }
}

class AboutPage extends StatelessWidget{
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              padding: const EdgeInsets.all(16.0),
              color: const Color(0xFFCAFF70),
              child: Column(
                  children: [
                    const Text(
                      'Welcome to Poke-Adopt!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Connecting trainers with Pokémon seeking loving homes since 2024',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/pokeball_logo.png', // Add your logo asset
                          height: 70,
                          width: 70,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.catching_pokemon, size: 70, color: Colors.red),
                        ),
                      ),
                    ),
                    _buildSection(
                      title: 'Our Mission',
                      content: 'At Poke-Adapt, we believe every Pokémon deserves a loving trainer. '
                          'Our platform connects trainers looking for their perfect partner with '
                          'Pokémon in need of care and companionship. Through our extensive matching '
                          'system, we ensure compatibility based on personality, care requirements, '
                          'and battle style preferences.',
                      icon: Icons.favorite,
                      color: Colors.red.shade100,
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        children: [
                          _buildPokemonCard(
                            image: 'assets/pokemon1.jpg',
                            name: 'Lugia',
                            type: 'Psychic/Flying',
                            context: context,
                            fallbackColor: Colors.blue.shade200,
                          ),
                          _buildPokemonCard(
                            image: 'assets/pokemon2.jpg',
                            name: 'Leafeon',
                            type: 'Grass',
                            context: context,
                            fallbackColor: Colors.green.shade200,
                          ),
                          _buildPokemonCard(
                            image: 'assets/pokemon3.jpg',
                            name: 'Absol',
                            type: 'Dark',
                            context: context,
                            fallbackColor: Colors.purple.shade200,
                          ),
                          _buildPokemonCard(
                            image: 'assets/pokemon4.jpg',
                            name: 'Gardevoir',
                            type: 'Psychic/Fairy',
                            context: context,
                            fallbackColor: Colors.pink.shade200,
                          ),
                        ],
                      ),
                    ),
                    _buildSection(
                      title: 'How It Works',
                      content: '',
                      icon: Icons.help_outline,
                      color: Colors.amber.shade100,
                      child: Column(
                        children: [
                          _buildStepItem(
                            number: '1',
                            title: 'Create Your Profile',
                            description: 'Tell us about your trainer style, preferences, and home environment.',
                          ),
                          _buildStepItem(
                            number: '2',
                            title: 'Browse Available Pokémon',
                            description: 'Explore detailed profiles showcasing each Pokémon\'s stats, personality, and care needs.',
                          ),
                          _buildStepItem(
                            number: '3',
                            title: 'Meet & Match',
                            description: 'Schedule a meeting with your potential partner to ensure compatibility.',
                          ),
                          _buildStepItem(
                            number: '4',
                            title: 'Welcome Home',
                            description: 'Complete the adoption process and begin your journey together!',
                          ),
                        ],
                      ),
                    ),
                    _buildSection(
                      title: 'Trainer Testimonials',
                      content: '',
                      icon: Icons.star,
                      color: Colors.teal.shade100,
                      child: Column(
                        children: [
                          _buildTestimonialCard(
                            quote: "Finding my Growlithe through Poke-Adapt was life-changing. The matching process was spot-on!",
                            trainer: "Trainer Ashley, Cerulean City",
                          ),
                          const SizedBox(height: 12),
                          _buildTestimonialCard(
                            quote: "I never thought I'd connect so deeply with a Psychic-type, but thanks to Poke-Adapt, my Espeon and I are inseparable.",
                            trainer: "Trainer Marcus, Saffron City",
                          ),
                        ],
                      ),
                    ),
                    _buildSection(
                      title: 'Our Values',
                      content: '',
                      icon: Icons.shield,
                      color: Colors.indigo.shade100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildValueItem(Icons.health_and_safety, 'Pokémon Welfare'),
                          _buildValueItem(Icons.handshake, 'Ethical Matching'),
                          _buildValueItem(Icons.history_edu, 'Trainer Education'),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(16.0),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.yellow.shade300, Colors.orange.shade300],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Ready to meet your perfect partner?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Navigation to adoption page
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade400,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'ADOPT NOW!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.grey.shade200,
                      child: Column(
                        children: [
                          const Text(
                            '© 2025 Poke-Adapt. All rights reserved.',
                            style: TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.public),
                                onPressed: () {},
                                color: Colors.black54,
                              ),
                              IconButton(
                                icon: const Icon(Icons.mail),
                                onPressed: () {},
                                color: Colors.black54,
                              ),
                              IconButton(
                                icon: const Icon(Icons.phone),
                                onPressed: () {},
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]
              ),
          )
        ],
      ),
    );
  }
}

Widget _buildSection({
  required String title,
  required String content,
  required IconData icon,
  required Color color,
  Widget? child,
}) {
  return Container(
    margin: const EdgeInsets.all(16.0),
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 28, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        if (content.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
        if (child != null) ...[
          const SizedBox(height: 16),
          child,
        ],
      ],
    ),
  );
}

Widget _buildPokemonCard({
  required String image,
  required String name,
  required String type,
  required BuildContext context,
  required Color fallbackColor,
}) {
  return Container(
    width: 150,
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          child: Container(
            height: 120,
            width: double.infinity,
            color: fallbackColor,
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Center(child: Icon(Icons.catching_pokemon, size: 50, color: Colors.white)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                type,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildStepItem({
  required String number,
  required String title,
  required String description,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amber,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildTestimonialCard({
  required String quote,
  required String trainer,
}) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 3,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.format_quote, color: Colors.teal, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                quote,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            '— $trainer',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildValueItem(IconData icon, String value) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, size: 28, color: Colors.indigo),
      ),
      const SizedBox(height: 8),
      Text(
        value,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

