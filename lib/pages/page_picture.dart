import 'package:flutter/material.dart';
import 'package:quiz_one/pages/stateless/page_about.dart';
import 'package:quiz_one/pages/page_free.dart';
import 'package:quiz_one/pages/page_gallery.dart';
import 'package:quiz_one/pages/auth/page_registration.dart';
import 'package:quiz_one/pages/drawer/drawer_header.dart';
import 'package:quiz_one/pages/drawer/drawer_list_view.dart';
class page_picture extends StatelessWidget {
  const page_picture({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
//               color: Colors.black.withOpacity(0.6), // Translucent background
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
//           ListTile(
//               title: Text("About"),
//               leading: Icon(Icons.book_online),
//               onTap: () => {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder:
//                       (context) => const page_about()),
//                 )
//               }
//           ),
//           ListTile(
//               title: Text("Free Page"),
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
//
