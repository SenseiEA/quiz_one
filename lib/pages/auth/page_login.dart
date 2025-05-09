import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_one/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:quiz_one/pages/page_registration.dart';
import 'package:quiz_one/pages/auth/page_userreg.dart';
import 'package:quiz_one/pages/auth/page_forgotpw.dart';


class page_login extends StatelessWidget {
  const page_login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login User",
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Content
            SingleChildScrollView(
              child: Column(
                children: [
                  TxtFieldSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class TxtFieldSection extends StatefulWidget {
  @override
  _TxtFieldSectionState createState() => _TxtFieldSectionState();
}

class _TxtFieldSectionState extends State<TxtFieldSection> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  String? _emailError;
  String? _passwordError;

  Future<void> _loginUser() async {
    final email = _email.text.trim();
    final password = _password.text;

    setState(() {
      _emailError = email.isEmpty ? "Email cannot be empty" : null;
      _passwordError = password.isEmpty ? "Password cannot be empty" : null;
    });

    if (_emailError != null || _passwordError != null) return;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('pokemonUsers')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        final userEm = userData['email'];
        final userName = userData['username'] ?? 'User';

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', userName); // Save username
        await prefs.setString('email', userEm); // Save username
        await prefs.setBool('isLoggedIn', true); // Set logged-in status to true

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext ctx) => MyAppHome()));
        // Navigate to home or another screen if needed
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid email or password")),
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 96, // 48 top + 48 bottom
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ensures vertical centering
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ADOPT logo
                    Center(
                      child: Image.asset(
                        'assets/logo.png',
                        height: 100,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      "Log in now.",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        fontFamily: 'DM-Sans',
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Email input
                    TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorText: _emailError,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Password input
                    TextField(
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorText: _passwordError,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'DM-Sans',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Sign up prompt
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don’t have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const page_userreg()),
                            );
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'DM-Sans',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const page_forgotpw()),
                            );
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'DM-Sans',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// class PageLogin extends StatelessWidget {
//   const PageLogin({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Login"),
//         backgroundColor: Colors.yellow,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               "Welcome to Poke-Adopt!",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'DM-Sans',
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               decoration: InputDecoration(
//                 hintText: "Username",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               obscureText: true,
//               decoration: InputDecoration(
//                 hintText: "Password",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () {
//                 // Navigate to main home page after successful login
//                 Navigator.pushReplacementNamed(context, '/home');
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.yellow,
//               ),
//               child: const Text(
//                 "Login",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder:
//                       (context) => const page_userreg()),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.yellow,
//               ),
//               child: const Text(
//                 "Register",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
