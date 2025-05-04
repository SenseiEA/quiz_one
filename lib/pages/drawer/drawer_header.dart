import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrwHeader extends StatefulWidget {
  const DrwHeader({super.key});

  @override
  State<DrwHeader> createState() => _Drwheader();
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
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      currentAccountPicture: const CircleAvatar(
        backgroundImage: AssetImage('assets/avatar.png'),
        radius: 28,
      ),
      accountName: Text(
        userName,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'DM-Sans',
        ),
      ),
      accountEmail: Text(
        email,
        style: const TextStyle(
          color: Colors.black54,
          fontFamily: 'DM-Sans',
        ),
      ),
    );
  }
}
