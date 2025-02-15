import 'package:flutter/material.dart';
import 'package:quiz_one/pages/page_free.dart';
import 'package:quiz_one/pages/page_photos.dart';
import 'package:quiz_one/pages/page_picture.dart';
import 'package:quiz_one/pages/page_registration.dart';


class page_about extends StatelessWidget {
  const page_about({super.key});

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "About Pokemon",
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFFFCC01),
            title: Center(
              child: Text(
                "ADOPT A POKEMON",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          body: SingleChildScrollView(
              child: Column(
                children: [
                  TxtFieldSection(),
                  ImgSection(),
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
                  border: Border(
                    bottom: BorderSide(color: Colors.grey),
                  )
                ),
                child: Text(
                  "About Pokemon",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
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
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  "It has beady brown eyes and a tiny nose. Its forelimbs are considerably large, and it has a tuft of fur on top of its head. Pawmi can stand on its hind legs, but barely.",
                  style: TextStyle(
                    fontSize: 20,
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
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white60,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(
                    "Previous",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
                    backgroundColor: Colors.white60,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
          color: Color(0xFFFFCC01)
      ),
      child: Column(
        children:[
          CircleAvatar(
            backgroundImage: AssetImage('avatar.jpg'),
            radius: 40,
          ),
          SizedBox(height: 15,),
          Text(
            "User",
            style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold
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
              title: Text("Registration"),
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
              title: Text("Photo Album"),
              leading: Icon(Icons.photo_album),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:
                      (context) => const page_photos()),
                )
              }
          ),
          ListTile(
              title: Text("Show Picture"),
              leading: Icon(Icons.photo),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:
                      (context) => const page_picture()),
                )
              }
          ),
          ListTile(
              title: Text("About"),
              leading: Icon(Icons.catching_pokemon),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:
                      (context) => const page_about()),
                )
              }
          ),
          ListTile(
              title: Text("Free Page"),
              leading: Icon(Icons.abc),
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

