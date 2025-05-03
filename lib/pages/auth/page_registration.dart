
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_one/main.dart';
import 'package:quiz_one/pages/page_free.dart';
import 'package:quiz_one/pages/page_photos.dart';
//import 'package:quiz_one/pages/page_picture.dart';
//import 'package:quiz_one/pages/page_registration.dart';
import 'package:quiz_one/models/userInformation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_one/pages/drawer/drawer_header.dart';
import 'package:quiz_one/pages/drawer/drawer_list_view.dart';

class page_registration extends StatelessWidget {
  const page_registration({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Share your Pokemon!",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFFCC01),
          title: Center(
            child: Text(
              "Adopt a Pokemon!",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DM-Sans'
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            /// Content
            SingleChildScrollView(
              child: Column(
                children: [
                  // Container(
                  //   width: double.infinity,
                  //   padding: EdgeInsets.all(16),
                  //   decoration: BoxDecoration(
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.amberAccent.shade400,
                  //         spreadRadius: 5,
                  //         blurRadius: 7,
                  //         offset: Offset(0, 3),
                  //       )
                  //     ],
                  //   ),
                  //   child: Text(
                  //     "Give Your Pokemon A New Home!",
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //       fontFamily: 'DM-Sans',
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  //ImgSection(),
                  TxtFieldSection(),
                  //BtnSection(),
                ],
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrwHeader(),
              DrwListView(currentRoute: "/home"),
            ],
          ),
        ),
      ),
    );
  }
}
class ImgSection extends StatelessWidget{
  const ImgSection ({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(30),
      child:
      Container(
        height: 150.0,
        width: double.maxFinite,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("togepi.png"),
              fit: BoxFit.fill,

            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20)
        ),
      ),
    );
  }
}

class TxtFieldSection extends StatefulWidget {
  @override
  _TxtFieldSection createState() => _TxtFieldSection();
}

class _TxtFieldSection extends State<TxtFieldSection> {
  final TextEditingController _registrantName = TextEditingController();
  final TextEditingController _pokemonName = TextEditingController();
  final TextEditingController _nickname = TextEditingController();
  final TextEditingController _type = TextEditingController();
  final TextEditingController _hp = TextEditingController();
  final TextEditingController _atk = TextEditingController();
  final TextEditingController _def = TextEditingController();
  final TextEditingController _description = TextEditingController();

  bool _validateRegistrant = false;
  bool _validatePokemon = false;
  bool _validateNickname = false;
  bool _validateType = false;
  bool _validateHp = false;
  bool _validateAtk = false;
  bool _validateDef = false;
  bool _validateDesc = false;

  List<userInformation> usersInfo = [];

  Future<void> addPokemonData() async {
    final pokemonData = {
      "registrantName": _registrantName.text,
      "pokemonName": _pokemonName.text,
      "nickname": _nickname.text,
      "type": _type.text,
      "hp": _hp.text,
      "atk": _atk.text,
      "def": _def.text,
      "description": _description.text,
    };

    try {
      await FirebaseFirestore.instance.collection('pokemonRegistrations').add(pokemonData);
      print("Pokémon data added successfully!");
    } catch (e) {
      print("Failed to add Pokémon data: $e");
    }

    // setState(() {
    //   _validateRegistrant = _registrantName.text.isEmpty;
    //   _validatePokemon = _pokemonName.text.isEmpty;
    //   _validateNickname = _nickname.text.isEmpty;
    //   _validateType = _type.text.isEmpty;
    //   _validateHp = _hp.text.isEmpty;
    //   _validateAtk = _atk.text.isEmpty;
    //   _validateDef = _def.text.isEmpty;
    //   _validateDesc = _description.text.isEmpty;
    // });

  }

  Future<void> UpdateInfo() async {
    // Search for the document ID by registrant name
    String? docId = await searchUserDocID(_registrantName.text);

    // If a valid document ID is found
    if (docId != null) {
      try {
        // Check if the document exists before trying to update
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('pokemonRegistrations')
            .doc(docId)
            .get();

        // If the document exists, perform the update
        if (docSnapshot.exists) {
          await FirebaseFirestore.instance
              .collection('pokemonRegistrations')
              .doc(docId)
              .update({
            'registrantName': _registrantName.text,
            'pokemonName': _pokemonName.text,
            'nickname': _nickname.text,
            'type': _type.text,
            'hp': _hp.text,
            'atk': _atk.text,
            'def': _def.text,
            'description': _description.text,
          });

          print('Document updated successfully!');
        } else {
          print('Document does not exist!');
        }
      } catch (e) {
        print('Error updating document: $e');
      }
    } else {
      print('User not found, cannot update.');
    }
  }



  Future<void> DeleteInfo() async {
    String? docId = await searchUserDocID(_registrantName.text);

    if (docId != null) {
      try {
        // Check if the document exists before trying to delete
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('pokemonRegistrations')
            .doc(docId)
            .get();

        // If the document exists, perform the delete
        if (docSnapshot.exists) {
          await FirebaseFirestore.instance
              .collection('pokemonRegistrations')
              .doc(docId)
              .delete(); // Use .delete() to remove the document

          print('Document deleted successfully!');
        } else {
          print('Document does not exist, cannot delete.');
        }
      } catch (e) {
        print('Error deleting document: $e');
      }
    } else {
      print('User not found, cannot delete.');
    }
  }


  Future<String?> searchUserDocID(String userName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('pokemonRegistrations')
          .where('registrantName', isEqualTo: userName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        print('Found Document ID: ${doc.id}');
        print('Data: ${doc.data()}');
        return doc.id;
      } else {
        print('No user found with name $userName');
        return null;
      }
    } catch (e) {
      print('Error searching Firestore: $e');
      return null;
    }
  }

  String userName = 'Guest';
  String email = 'test@email.com';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Guest';
      email = prefs.getString('email') ?? 'test@email.com';
      //do $userName or $email in Widget texts for testing
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabeledTextField("Registrant's Name", _registrantName, _validateRegistrant),
          buildLabeledTextField("Pokemon Name", _pokemonName, _validatePokemon),
          Row(
            children: [
              Expanded(child: buildLabeledTextField("Nickname", _nickname, _validateNickname)),
              const SizedBox(width: 10),
              Expanded(child: buildLabeledTextField("Type", _type, _validateType)),
            ],
          ),
          Row(
            children: [
              Expanded(child: buildLabeledTextField("Hp.", _hp, _validateHp, isNumber: true)),
              const SizedBox(width: 10),
              Expanded(child: buildLabeledTextField("Atk.", _atk, _validateAtk, isNumber: true)),
              const SizedBox(width: 10),
              Expanded(child: buildLabeledTextField("Def.", _def, _validateDef, isNumber: true)),

            ],
          ),
          buildLabeledTextField("Description", _description, _validateDesc, isMultiline: true, ),

          const SizedBox(height: 20),

          // Submit & Back Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          addPokemonData(); // Call your function inside setState
                        });
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
                    )
                    ,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          UpdateInfo(); // Call your function inside setState
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFCC01),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      child: Text(
                        "Update",
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
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          DeleteInfo(); // Call your function inside setState
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFCC01),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      child: Text(
                        "Delete",
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
              SizedBox(width: 10),
              Expanded(child:
              SizedBox(
                  width: 200,
                  height: 200,
                  child:
                  ListView.builder(
                      itemCount: usersInfo.length,
                      itemBuilder: (context, index){
                        return ListTile(
                          title: Text(usersInfo[index].registrantName),
                          subtitle: Text(usersInfo[index].pokemonName),
                        );
                      }
                  )
              ))
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLabeledTextField(
      String label,
      TextEditingController controller,
      bool showError, {
        bool isNumber = false,
        bool isMultiline = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : (isMultiline ? TextInputType.multiline : TextInputType.text),
            inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(4)] : [LengthLimitingTextInputFormatter(50)],
            maxLines: isMultiline ? null : 1,
            minLines: isMultiline ? 6 : 1,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.amber, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.amber, width: 2),
              ),
              hintText: label,
              hintStyle: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black54),
              errorText: showError ? "$label cannot be empty" : null,
            ),
          ),
        ],
      ),
    );
  }
}

//Drawer
// class DrwHeader extends StatefulWidget{
//   @override
//   _Drwheader createState() => _Drwheader();
// }
// class _Drwheader extends State<DrwHeader> {
//   @override
//   Widget build(BuildContext context){
//     return DrawerHeader(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage("pokebanner.jpg"), // Replace with your actual image path
//           fit: BoxFit.cover, // Ensures the image covers the entire background
//         ),
//       ),
//       child: Column(
//         children:[
//           CircleAvatar(
//             backgroundImage: AssetImage('avatar.png'),
//             radius: 40,
//           ),
//           SizedBox(height: 10,),
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
//             decoration: BoxDecoration(
//               color: Colors.black, // Translucent background
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Text(
//               'Amado Ketchum',
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'DM-Sans'
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// class DrwListView extends StatefulWidget{
//   @override
//   _DrwListView createState() => _DrwListView();
// }
// class _DrwListView extends State<DrwListView>{
//   @override
//   Widget build(BuildContext context){
//     return Padding(padding: EdgeInsets.zero,
//       child:Column(
//         children: [
//           ListTile(
//               title: Text("Register your Pokemon",
//                 style: TextStyle(
//                     fontFamily: 'DM-Sans'),
//               ),
//               leading: Icon(Icons.login_outlined),
//               onTap: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder:
//                       (context) => const page_registration()),
//                 )
//               }
//           ),
//           ListTile(
//               title: Text("Photo Album",
//                 style: TextStyle(
//                     fontFamily: 'DM-Sans'
//                 ),),
//               leading: Icon(Icons.photo_album),
//               onTap: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder:
//                       (context) => const page_photos()),
//                 )
//               }
//           ),
//           // ListTile(
//           //     title: Text("Show Picture"),
//           //     leading: Icon(Icons.photo),
//           //     onTap: () => {
//           //       Navigator.push(
//           //         context,
//           //         MaterialPageRoute(builder:
//           //             (context) => const page_picture()),
//           //       )
//           //     }
//           // ),
//           // ListTile(
//           //     title: Text("About"),
//           //     leading: Icon(Icons.book_online),
//           //     onTap: () => {
//           //       Navigator.push(
//           //         context,
//           //         MaterialPageRoute(builder:
//           //             (context) => const page_about()),
//           //       )
//           //     }
//           // ),
//           ListTile(
//               title: Text("Care 101"),
//               leading: Icon(Icons.catching_pokemon_sharp),
//               onTap: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder:
//                       (context) => const page_free()),
//                 )
//               }
//           )
//         ],
//       ),
//     );
//   }
// }
