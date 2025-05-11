import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_one/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quiz_one/pages/auth/page_registration.dart';
import 'package:quiz_one/pages/auth/page_forgotpw.dart';
import 'auth_service.dart';

class page_login extends StatelessWidget {
  const page_login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login User",
      theme: ThemeData(
        fontFamily: 'DM-Sans',
        primaryColor: Color(0xFFFFCC01),
        colorScheme: ColorScheme.light(
          primary: Color(0xFFFFCC01),
          secondary: Colors.black,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFFFCC01), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFCC01),
            foregroundColor: Colors.black,
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'DM-Sans',
            ),
          ),
        ),
      ),
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
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  String? _emailError;
  String? _passwordError;

  Future<void> _loginUser() async {
    // Validate inputs
    bool isValid = _validateInputs();
    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.signIn(
        email: _email.text.trim(),
        password: _password.text,
        context: context,
      );

      if (result != null) {
        _authService.showSuccessSnackBar(context, "Login successful!");

        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext ctx) => MyAppHome()),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _validateInputs() {
    setState(() {
      // Email validation
      if (_email.text.trim().isEmpty) {
        _emailError = "Email cannot be empty";
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_email.text.trim())) {
        _emailError = "Please enter a valid email address";
      } else {
        _emailError = null;
      }

      // Password validation
      if (_password.text.isEmpty) {
        _passwordError = "Password cannot be empty";
      } else {
        _passwordError = null;
      }
    });

    return _emailError == null && _passwordError == null;
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
                      "Welcome to Poke-Adopt!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Log in to continue",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Email input
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Enter your email",
                        prefixIcon: Icon(Icons.email_outlined),
                        errorText: _emailError,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Password input
                    TextField(
                      controller: _password,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Enter your password",
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        errorText: _passwordError,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Forgot password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const page_forgotpw(),
                            ),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: _isLoading
                          ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFCC01)),
                        ),
                      )
                          : ElevatedButton(
                        onPressed: _loginUser,
                        child: const Text("Log In"),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Sign up prompt
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const page_registration(),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFCC01),
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