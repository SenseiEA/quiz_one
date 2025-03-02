import 'package:flutter/material.dart';
import 'package:quiz_one/pages/page_free.dart';
import 'package:quiz_one/pages/page_photos.dart';
import 'package:quiz_one/pages/page_picture.dart';
import 'package:quiz_one/pages/page_registration.dart';

import '../main.dart';


class page_about extends StatelessWidget {
  const page_about({super.key});

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "About the Pokemon",
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFFFCC01),
            title: Center(
              child: Text(
                "ADOPT A POKEMON",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DM-Sans'
                ),
              ),
            ),
          ),

          body: SingleChildScrollView(
              child: Column(
                children: [
                  TxtFieldSection(),
                  ImgSection(),
                  DetailSection(),
                  TextSection(),
                  BtnSection(),

                ],
              )
          ),
          drawer: Drawer(
              child: ListView(
                children: [
                  DrwHeader(),
                  DrwListView()

                ],
              )
          ),
        )
    );
  }
}

class TxtFieldSection extends StatelessWidget {
  const TxtFieldSection ({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity, // Makes the border span the full width
                padding: EdgeInsets.only(left: 10, bottom: 8),
                decoration: BoxDecoration(
                ),
              )
            ]
        )
    );
  }
}
class ImgSection extends StatelessWidget {
  const ImgSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: 50),
      child: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 300,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFD6EAFE),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Image.asset(
                  'assets/Pawmi.png',
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pawmi",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                          fontFamily: 'DM-Sans'

                      ),
                    ),

                    // Type Icon
                    Image.asset(
                      'assets/Electro.png',
                      height: 30,
                      width: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
class DetailSection extends StatelessWidget {
  const DetailSection({super.key});

  Widget _buildDetailBox(String text, String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: textColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDetailBox("50", "HP", Colors.green, Colors.green[800]!),
          _buildDetailBox("2.5kg", "Weight", Colors.pink, Colors.pink[800]!),
          _buildDetailBox("0.3m", "Height", Colors.blue, Colors.blue[800]!),
          _buildDetailBox("Ground", "Weakness", Colors.red, Colors.red[800]!),
        ],
      ),
    );
  }
}
class TextSection extends StatelessWidget {
  const TextSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 600,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  "Pawmi is a small, quadrupedal, rodent-like Pokémon that has a body that is almost entirely orange, with cream colorations on its lower forelimbs, snout, and tail, and green on the insides of its ears.",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'DM-Sans'
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  "It has beady brown eyes and a tiny nose. Its forelimbs are considerably large, and it has a tuft of fur on top of its head. Pawmi can stand on its hind legs, but barely.",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'DM-Sans'
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class BtnSection extends StatefulWidget {
  const BtnSection({super.key});
  @override
  _BtnSectionState createState() => _BtnSectionState();
}
class _BtnSectionState extends State<BtnSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous Button
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 300),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Previous",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'DM-Sans'
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 10),

          // Next Button
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 300),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const page_free(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'DM-Sans'
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class DrwHeader extends StatefulWidget{
  @override
  _Drwheader createState() => _Drwheader();
}
class _Drwheader extends State<DrwHeader> {
  @override
  Widget build(BuildContext context){
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("pokebanner.jpg"), // Replace with your actual image path
          fit: BoxFit.cover, // Ensures the image covers the entire background
        ),
      ),
      child: Column(
        children:[
          CircleAvatar(
            backgroundImage: AssetImage('avatar.png'),
            radius: 40,
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6), // Translucent background
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Amado Ketchum',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DM-Sans'
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class DrwListView extends StatefulWidget{
  @override
  _DrwListView createState() => _DrwListView();
}
class _DrwListView extends State<DrwListView>{
  @override
  Widget build(BuildContext context){
    return Padding(padding: EdgeInsets.zero,
      child:Column(
        children: [
          ListTile(
              title: Text("Register your Pokemon",
                style: TextStyle(
                    fontFamily: 'DM-Sans'),
              ),
              leading: Icon(Icons.login_outlined),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:
                      (context) => const page_registration()),
                )
              }
          ),
          ListTile(
              title: Text("Photo Album",
                style: TextStyle(
                    fontFamily: 'DM-Sans'
                ),),
              leading: Icon(Icons.photo_album),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:
                      (context) => const page_photos()),
                )
              }
          ),
          // ListTile(
          //     title: Text("Show Picture"),
          //     leading: Icon(Icons.photo),
          //     onTap: () => {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder:
          //             (context) => const page_picture()),
          //       )
          //     }
          // ),
          ListTile(
              title: Text("About"),
              leading: Icon(Icons.book_online),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:
                      (context) => const page_about()),
                )
              }
          ),
          ListTile(
              title: Text("Care 101"),
              leading: Icon(Icons.catching_pokemon_sharp),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:
                      (context) => const page_free()),
                )
              }
          )
        ],
      ),
    );
  }
}


