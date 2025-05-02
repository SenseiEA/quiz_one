import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import 'package:quiz_one/main.dart';
//import 'package:quiz_one/pages/page_registration.dart';
import 'package:quiz_one/pages/page_login.dart';
//import 'package:quiz_one/models/userInformation.dart';


class page_forgotpw extends StatelessWidget {
  const page_forgotpw({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Forgot Password",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFFCC01),
          title: Center(
            child: Text(
              "Forgot Password",
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
  _TxtFieldSection createState() => _TxtFieldSection();
}

class _TxtFieldSection extends State<TxtFieldSection> {
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  final TextEditingController _email = TextEditingController();
  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabeledTextField("Email", _email, _emailError),
          buildLabeledTextField("New Password", _password, _passwordError, isPassword: true),
          buildLabeledTextField("Confirm Password", _confirm, _confirmError, isPassword: true),

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
                      onPressed: () async {
                        setState(() {
                          _emailError = _email.text.isEmpty
                              ? "Email cannot be empty"
                              : validateEmail(_email.text);

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

                          _confirmError = _confirm.text != password
                              ? "Confirm Password must match Password"
                              : null;
                        });

                        if (_emailError == null &&
                            _passwordError == null &&
                            _confirmError == null) {
                          try {
                            final query = await FirebaseFirestore.instance
                                .collection('pokemonUsers')
                                .where('email', isEqualTo: _email.text.trim())
                                .get();

                            if (query.docs.isNotEmpty) {
                              // User exists, update password
                              await FirebaseFirestore.instance
                                  .collection('pokemonUsers')
                                  .doc(query.docs.first.id)
                                  .update({'password': _password.text}); //  Insecure in production!

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Password reset successful!")),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const page_login()),
                              );
                            } else {
                              // Email not found
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Email not found.")),
                              );
                            }

                            _email.clear();
                            _password.clear();
                            _confirm.clear();

                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Password Update failed: ${e.toString()}")),
                            );
                          }
                        }
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
              SizedBox(width: 10)
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLabeledTextField(
      String label,
      TextEditingController controller,
      String? errorMessage, {
        bool isNumber = false,
        bool isMultiline = false,
        bool isPassword = false,
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
                color: Colors.black),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: isNumber
                ? TextInputType.number
                : (isMultiline ? TextInputType.multiline : TextInputType.text),
            inputFormatters: isNumber
                ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4)
            ]
                : [LengthLimitingTextInputFormatter(50)],
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
              hintStyle: const TextStyle(
                  fontWeight: FontWeight.w400, color: Colors.black54),
              errorText: errorMessage,
            ),
          ),
        ],
      ),
    );
  }
}