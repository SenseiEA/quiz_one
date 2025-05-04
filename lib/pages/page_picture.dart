import 'package:flutter/material.dart';
import 'package:quiz_one/pages/page_about.dart';
import 'package:quiz_one/pages/page_free.dart';
import 'package:quiz_one/pages/page_photos.dart';
import 'package:quiz_one/pages/page_registration.dart';

import '../custom_drawer.dart';

class page_picture extends StatelessWidget {
  const page_picture({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Picture Module",
        home: Scaffold(
          appBar: AppBar(
            title:Text("Picture Module"),

          ),
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back'),
            ),
          ),
          //Copy here for drawer
          drawer:
          CustomDrawer(currentRoute: '/'),//replace home with current page
          //End Copy
        )
    );
  }
}


