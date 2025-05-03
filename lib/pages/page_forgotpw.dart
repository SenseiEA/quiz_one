import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_one/pages/page_login.dart';
import 'package:quiz_one/main.dart';

class page_forgotpw extends StatelessWidget {
  const page_forgotpw({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Forgot Password",
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
                          Image.asset('assets/logo.png', height: 100), // Optional logo
                          const SizedBox(height: 16),
                          const Text(
                            "Reset your password.",
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
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  String? _emailError, _passwordError, _confirmError;

  String? validateEmail(String? value) {
    final regex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");
    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

  Future<void> _resetPassword() async {
    setState(() {
      _emailError = _email.text.isEmpty ? "Email cannot be empty" : validateEmail(_email.text);

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

    if (_emailError == null && _passwordError == null && _confirmError == null) {
      try {
        final query = await FirebaseFirestore.instance
            .collection('pokemonUsers')
            .where('email', isEqualTo: _email.text.trim())
            .get();

        if (query.docs.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('pokemonUsers')
              .doc(query.docs.first.id)
              .update({'password': _password.text}); // 🔒 Consider hashing in production

          _email.clear();
          _password.clear();
          _confirm.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password reset successful!")),
          );

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const page_login()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email not found.")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
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
        buildTextField("New Password", _password, _passwordError, isPassword: true),
        const SizedBox(height: 24),
        buildTextField("Confirm Password", _confirm, _confirmError, isPassword: true),
        const SizedBox(height: 24),
        buildButtons(context),
      ],
    );
  }

  Widget buildTextField(String label, TextEditingController controller, String? error,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        errorText: error,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget buildButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _resetPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text("Submit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MyApp()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text("Back", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ],
    );
  }
}
