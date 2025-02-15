import 'package:flutter/material.dart';
import 'package:quiz_one/pages/page_free.dart';
import 'package:quiz_one/pages/page_photos.dart';
import 'package:quiz_one/pages/page_picture.dart';
import 'package:quiz_one/pages/page_registration.dart';
import 'package:quiz_one/pages/page_about.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Registration Module",
      home: Scaffold(
        appBar: AppBar(
          title: Container(
            height: 150.0,
            width: double.maxFinite,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('flutimage.jpg'),
                    fit: BoxFit.fill
                ),
                shape: BoxShape.rectangle
            ),
          )
        ),
          body: SingleChildScrollView(
          child: Column(
            children: [
              TxtFieldSection()
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
    return Padding(padding: EdgeInsets.all(30),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(child:
                  Text(
                    "Welcome to the World!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  ),
                ],
              ),
            ]
        )
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
          color: Colors.teal
      ),
      child: Column(
        children:[
          CircleAvatar(
            backgroundImage: AssetImage('avatar.jpg'),
            radius: 40,
          ),
          SizedBox(height: 15,),
          Text(
            "Noel Angelo A. Cansino",
            style: TextStyle(
                color: Colors.white,
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
