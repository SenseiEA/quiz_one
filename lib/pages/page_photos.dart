import 'package:flutter/material.dart';

class page_photos extends StatelessWidget {
  const page_photos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Photos Module",
        home: Scaffold(
          appBar: AppBar(
            title:Text("Photos Module"),

          ),
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back'),
            ),
          ),
        )
    );
  }
}
