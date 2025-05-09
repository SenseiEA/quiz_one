import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final String assetPath;
  final bool isActive;
  final VoidCallback onTap;

  const DrawerItem({
    required this.title,
    required this.assetPath,
    required this.isActive,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isActive
          ? const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF7FF10), Color(0xFFFFB7D6)],
        ),
      )
          : null,
      child: ListTile(
        leading: Image.asset(assetPath, width: 20, height: 20),
        title: Text(
          title,
          style: const TextStyle(fontFamily: 'DM-Sans'),
        ),
        onTap: onTap,
      ),
    );
  }
}