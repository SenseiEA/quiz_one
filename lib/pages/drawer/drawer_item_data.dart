import 'package:flutter/material.dart';

class DrawerItemData {
  final String title;
  final String route;
  final String assetPath;
  final Widget page;

  const DrawerItemData({
    required this.title,
    required this.route,
    required this.assetPath,
    required this.page,
  });
}
