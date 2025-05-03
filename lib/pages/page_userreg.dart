import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_one/pages/page_login.dart';
import 'package:quiz_one/main.dart';

class page_userreg extends StatelessWidget {
  const page_userreg({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Register User",
      home: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/logo.png', height: 100),
                          const SizedBox(height: 16),
                          const Text(
                            "Create an account.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'DM-Sans',
                            ),
                          ),
                          const SizedBox(height: 32),
                          TxtFieldSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
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
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  final TextEditingController _email = TextEditingController();

  String? _emailError, _userError, _passwordError, _confirmError;

  String? validateEmail(String? value) {
    final regex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");
    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

  Future<void> _registerUser() async {
    setState(() {
      _emailError = _email.text.isEmpty ? "Email cannot be empty" : validateEmail(_email.text);
      _userError = _userName.text.isEmpty ? "Full Name cannot be empty" : null;

      final password = _password.text;
      final hasUppercase = password.contains(RegExp(r'[A-Z]'));

      if (password.isEmpty) {
        _passwordError = "Password cannot be empty";
      } else if (password.length < 8) {
        _passwordError = "Password must be at least 8 characters";
      } else if (!hasUppercase) {
        _passwordError = "Password must contain an uppercase letter";
      } else {
        _passwordError = null;
      }

      _confirmError = _confirm.text != password ? "Passwords do not match" : null;
    });

    if (_emailError == null && _userError == null && _passwordError == null && _confirmError == null) {
      try {
        await FirebaseFirestore.instance.collection('pokemonUsers').add({
          'email': _email.text.trim(),
          'username': _userName.text.trim(),
          'password': _password.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        _email.clear();
        _userName.clear();
        _password.clear();
        _confirm.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User registered successfully!")),
        );

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const page_login()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration failed: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTextField("Email", _email, _emailError),
        const SizedBox(height: 24),
        buildTextField("Full Name", _userName, _userError),
        const SizedBox(height: 24),
        buildTextField("Password", _password, _passwordError, isPassword: true),
        const SizedBox(height: 24),
        buildTextField("Confirm Password", _confirm, _confirmError, isPassword: true),
        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _registerUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Register", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),

        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already have an account? "),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const page_login()),
                );
              },
              child: const Text(
                "Log in",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DM-Sans',
                ),
              ),
            ),
          ],
        ),

      ],
    );
  }

  Widget buildTextField(String label, TextEditingController controller, String? errorText, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
