import 'package:flutter/material.dart';

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
        )
    );
  }
}
