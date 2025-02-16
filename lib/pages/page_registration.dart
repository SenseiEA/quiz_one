import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_one/pages/page_free.dart';
import 'package:quiz_one/pages/page_photos.dart';
import 'package:quiz_one/pages/page_picture.dart';
import 'package:quiz_one/pages/page_about.dart';
import 'package:quiz_one/pages/page_registration.dart';

class page_registration extends StatelessWidget {
  const page_registration({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Register Pokemon",
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
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Text(
                    "Register a Pokemon",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
              // ImgSection(),
                  TxtFieldSection(),
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

// class ImgSection extends StatelessWidget{
//   const ImgSection ({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(padding: EdgeInsets.all(30),
//       child:
//       Container(
//         height: 150.0,
//         width: double.maxFinite,
//         decoration: BoxDecoration(
//             image: DecorationImage(image:
//             AssetImage('assets/ms2.png'),
//                 fit: BoxFit.fill
//             ),
//             shape: BoxShape.rectangle
//         ),
//       ),
//     );
//   }
// }

class TxtFieldSection extends StatelessWidget{
  const TxtFieldSection ({super.key});

  @override
  Widget build(BuildContext context){
    return Padding(padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 30),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Registrant's Name",
                  hintStyle: TextStyle(fontWeight: FontWeight.bold)
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Pokemon Name",
                  hintStyle: TextStyle(fontWeight: FontWeight.bold)
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Nickname",
                      hintMaxLines: 2,
                      hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Type",
                      hintMaxLines: 2,
                      hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Hp.",
                      hintMaxLines: 2,
                      hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Atk.",
                      hintMaxLines: 2,
                      hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Def.",
                      hintMaxLines: 2,
                      hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10),
            child: TextField(
              maxLines: null,
              minLines: 6,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Description",
                  hintMaxLines: 8,
                  hintStyle: TextStyle(fontWeight: FontWeight.bold)
              ),
            ),
          ),
        ],
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
                    // Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFCC01),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                  child: Text(
                    "Submit",
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

          // Back Button
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 300),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const page_free(),
                    //   ),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFCC01),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                  child: Text(
                    "Back",
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