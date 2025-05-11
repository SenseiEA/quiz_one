import 'package:flutter/material.dart';
import 'package:quiz_one/pages/admin/admin_body.dart';
import 'package:quiz_one/pages/page_favorite.dart';
import 'package:quiz_one/pages/stateless/page_aboutus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer_item.dart';
import 'drawer_item_data.dart';
import 'package:quiz_one/pages/page_free.dart';
import 'package:quiz_one/pages/page_gallery.dart';
import 'package:quiz_one/pages/stateless/page_about.dart';
import 'package:quiz_one/pages/auth/page_login.dart';
import 'package:quiz_one/main.dart';

class DrwListView extends StatefulWidget {
  final String currentRoute;

  const DrwListView({required this.currentRoute, super.key});

  @override
  State<DrwListView> createState() => _DrwListViewState();
}

class _DrwListViewState extends State<DrwListView> {
  String userName = 'Guest';
  String email = 'test@email.com';
  bool isAdmin = false;

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
      isAdmin = prefs.getBool('isAdmin') ?? false;
      //do $userName or $email in Widget texts for testing
    });
  }

  @override
  Widget build(BuildContext context) {
    final drawerItems = [
      DrawerItemData(
        title: "Home",
        route: "/home",
        assetPath: 'assets/home.png',
        page: const MyAppHome(),
      ),
      DrawerItemData(
        title: "Gallery",
        route: "/gallery",
        assetPath: 'assets/gallery.png',
        page: const page_photos(),
      ),
      DrawerItemData(
        title: "Pokemon Favorites",
        route: "/favorite",
        assetPath: 'assets/poke_interest.png',
        page: const page_favorite(),
      ),
      DrawerItemData(
        title: "Adoption Application",
        route: "/adopt",
        assetPath: 'assets/adopt_app.png',
        page: const page_about(),
      ),
      DrawerItemData(
        title: "About",
        route: "/about",
        assetPath: 'assets/about.png',
        page: const page_aboutus(),
      ),
      DrawerItemData(
        title: "Tips",
        route: "/contact",
        assetPath: 'assets/contact.png',
        page: const page_free(),
      ),
    if (isAdmin) ...[
      DrawerItemData(
        title: "Admin",
        route: "/admin",
        assetPath: 'assets/shield-ban.png',
        page: const PokemonAdminApp(),
      ),],
    ];

    return Column(
      children: [
        ...drawerItems.map((item) => DrawerItem(
          title: item.title,
          assetPath: item.assetPath,
          isActive: widget.currentRoute == item.route,
          onTap: () {
            if (widget.currentRoute != item.route) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => item.page),
              );
            }
          },
        )),
        DrawerItem(
          title: "Logout",
          assetPath: 'assets/logout.png',
          isActive: false,
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();
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
