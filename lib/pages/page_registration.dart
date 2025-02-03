import 'package:flutter/material.dart';

class page_registration extends StatelessWidget {
  const page_registration({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Registration Module",
        home: Scaffold(
          appBar: AppBar(
            title:Text("Registration Module"),

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
