import 'package:flutter/material.dart';

class page_free extends StatefulWidget {
  const page_free({super.key});

  @override
  State<page_free> createState() => _PageFreeState();
}

class _PageFreeState extends State<page_free> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _colorAnimation1 = ColorTween(
      begin: Colors.blue,
      end: Colors.purple,
    ).animate(_controller);

    _colorAnimation2 = ColorTween(
      begin: Colors.purple,
      end: Colors.blue,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Free Page Module",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Take care of your Pokemon!"),
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
                        Navigator.pushNamed(context, '/registration');
                      },
                    ),
                    ListTile(
                      title: const Text("Photo Album"),
                      leading: const Icon(Icons.photo_album),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/photos');
                      },
                    ),
                    ListTile(
                      title: const Text("Show Picture"),
                      leading: const Icon(Icons.photo),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/picture');
                      },
                    ),
                    ListTile(
                      title: const Text("About"),
                      leading: const Icon(Icons.catching_pokemon),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/about');
                      },
                    ),
                    ListTile(
                      title: const Text("Free Page"),
                      leading: const Icon(Icons.abc),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/freepage');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _colorAnimation1.value!,
                      _colorAnimation2.value!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Centers the children vertically
                  children: [
                    SizedBox(
                      height: 720,
                      child: CarouselView(
                        itemExtent: MediaQuery.sizeOf(context).width - 0,
                        itemSnapping: true,
                        elevation: 4,
                        padding: const EdgeInsets.all(10),
                        children: List.generate(5, (int index) {
                          // List of local image paths
                          final List<String> imagePaths = [
                            'assets/tip1.png',
                            'assets/tip2.png',
                            'assets/tip3.png',
                            'assets/tip4.png',
                            'assets/tip5.png',
                          ];

                          return Container(
                            color: Colors.grey,
                            child: Image.asset(
                              imagePaths[index], // Use local image path
                              fit: BoxFit.cover,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
