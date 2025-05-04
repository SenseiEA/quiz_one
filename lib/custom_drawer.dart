import 'package:flutter/material.dart';
import 'package:quiz_one/pages/page_about.dart';
import 'package:quiz_one/pages/page_free.dart';
import 'package:quiz_one/pages/page_photos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'pages/page_login.dart';

// Drawer Header Widget
class DrwHeader extends StatefulWidget {
  @override
  _DrwHeaderState createState() => _DrwHeaderState();
}

class _DrwHeaderState extends State<DrwHeader> {
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
  Widget build(BuildContext context) {
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

// Drawer List Items
class DrwListView extends StatelessWidget {
  final String currentRoute;
  DrwListView({required this.currentRoute});

  Widget buildListTile({
    required BuildContext context,
    required String title,
    required String route,
    required String assetPath,
    required Widget page,
  }) {
    bool isActive = currentRoute == route;

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
        leading: Image.asset(assetPath, width: 20, height: 20),
        title: Text(title, style: TextStyle(fontFamily: 'DM-Sans')),
        onTap: () {
          if (!isActive) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildListTile(
          context: context,
          title: "Home",
          route: "/home",
          assetPath: 'assets/home.png',
          page: const MyAppHome(),
        ),
        buildListTile(
          context: context,
          title: "Gallery",
          route: "/gallery",
          assetPath: 'assets/gallery.png',
          page: const page_photos(),
        ),
        buildListTile(
          context: context,
          title: "Pokemon Interests",
          route: "/interests",
          assetPath: 'assets/poke_interest.png',
          page: const page_about(),
        ),
        buildListTile(
          context: context,
          title: "Adoption Application",
          route: "/adopt",
          assetPath: 'assets/adopt_app.png',
          page: const page_about(),
        ),
        buildListTile(
          context: context,
          title: "About",
          route: "/about",
          assetPath: 'assets/about.png',
          page: const page_about(),
        ),
        buildListTile(
          context: context,
          title: "Contact",
          route: "/contact",
          assetPath: 'assets/contact.png',
          page: const page_free(),
        ),
        ListTile(
          leading: Image.asset('assets/logout.png', width: 20, height: 20),
          title: Text("Logout"),
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('userName');
            await prefs.remove('email');
            await prefs.setBool('isLoggedIn', false);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const page_login()),
            );
          },
        ),
      ],
    );
  }
}

// Combined Drawer Widget
class CustomDrawer extends StatelessWidget {
  final String currentRoute;
  const CustomDrawer({required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrwHeader(),
          DrwListView(currentRoute: currentRoute),
        ],
      ),
    );
  }
}
