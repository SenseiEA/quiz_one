import 'package:flutter/material.dart';

class page_free extends StatelessWidget {
  const page_free({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Free Page Module",
        home: Scaffold(
          appBar: AppBar(
            title:Text("Free Page Module"),

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
