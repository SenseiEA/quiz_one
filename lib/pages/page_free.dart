import 'package:flutter/material.dart';
import 'package:quiz_one/pages/stateless/page_about.dart';
import 'package:quiz_one/pages/page_photos.dart';
import 'package:quiz_one/pages/auth/page_registration.dart';
import 'package:quiz_one/pages/drawer/drawer_header.dart';
import 'package:quiz_one/pages/drawer/drawer_list_view.dart';
import 'page_picture.dart';

class page_free extends StatefulWidget {
  const page_free({super.key});

  @override
  State<page_free> createState() => _PageFreeState();
}

class _PageFreeState extends State<page_free> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _colorAnimation1 = ColorTween(
      begin: Colors.blue,
      end: Colors.purple,
    ).animate(_controller);

    _colorAnimation2 = ColorTween(
      begin: Colors.purple,
      end: Colors.blue,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Taking Care",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Take care of your Pokemon!"),
          backgroundColor: Colors.yellow,
        ),
        drawer: Drawer(
            child: ListView(
              children: [
                const DrwHeader(),
                DrwListView(currentRoute: "/home")

              ],
            )
        ),
        body: SafeArea(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _colorAnimation1.value!,
                      _colorAnimation2.value!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Centers the children vertically
                  children: [
                    SizedBox(
                      height: 720,
                      child: CarouselView(
                        itemExtent: MediaQuery.sizeOf(context).width - 0,
                        itemSnapping: true,
                        elevation: 4,
                        padding: const EdgeInsets.all(10),
                        children: List.generate(5, (int index) {
                          // List of local image paths
                          final List<String> imagePaths = [
                            'assets/tip1.png',
                            'assets/tip2.png',
                            'assets/tip3.png',
                            'assets/tip4.png',
                            'assets/tip5.png',
                          ];

                          return Container(
                            color: Colors.grey,
                            child: Image.asset(
                              imagePaths[index], // Use local image path
                              fit: BoxFit.cover,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
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
//           image: AssetImage("assets/pokebanner.jpg"), // Replace with your actual image path
//           fit: BoxFit.cover, // Ensures the image covers the entire background
//         ),
//       ),
//       child: Column(
//         children:[
//           CircleAvatar(
//             backgroundImage: AssetImage('assets/avatar.png'),
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
//
//
