import 'package:flutter/material.dart';

class page_form_complete extends StatelessWidget {
  const page_form_complete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the Pokemon nickname from the arguments
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final nickname = arguments?['nickname'] ?? 'your Pokémon';

    return Scaffold(
      appBar: AppBar(
        title: Text('Form Complete'),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              // Menu icon at top left
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Congratulations!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Professor Oak image
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/trainers/professor-oak.png',
                        height: 200,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/professor-oak.png',
                            height: 200,
                          );
                        },
                      ),

                      SizedBox(height: 24),

                      // Congratulations text
                      Text(
                        'Congratulations!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 16),

                      // Message with Pokemon nickname
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          'Time to meet your new partner, $nickname!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Home button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      colors: [
                        Colors.yellow,
                        Colors.pink.shade200,
                      ],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}