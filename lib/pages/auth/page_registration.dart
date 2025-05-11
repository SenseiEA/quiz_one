import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:quiz_one/main.dart';
import 'package:quiz_one/pages/auth/page_login.dart';
import 'auth_service.dart';

class page_registration extends StatelessWidget {
  const page_registration({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Register User",
      theme: ThemeData(
        fontFamily: 'DM-Sans',
        primaryColor: Color(0xFFFFCC01),
        colorScheme: ColorScheme.light(
          primary: Color(0xFFFFCC01),
          secondary: Colors.black,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFFCC01),
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'DM-Sans',
          ),
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
        appBar: AppBar(
          title: Text("Register Now!"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
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
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _emailError;
  String? _userError;
  String? _passwordError;
  String? _confirmError;

  Future<void> _registerUser() async {
    // Validate inputs
    bool isValid = _validateInputs();
    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.signUp(
        email: _email.text.trim(),
        password: _password.text,
        username: _userName.text.trim(),
        context: context,
      );

      if (result != null) {
        _authService.showSuccessSnackBar(context, "Registration successful!");

        // Clear form fields
        _email.clear();
        _userName.clear();
        _password.clear();
        _confirm.clear();

        // Navigate to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const page_login()),
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

      // Username validation
      if (_userName.text.trim().isEmpty) {
        _userError = "Full Name cannot be empty";
      } else if (_userName.text.trim().length < 3) {
        _userError = "Name must be at least 3 characters";
      } else {
        _userError = null;
      }

      // Password validation
      final password = _password.text;
      final hasUppercase = password.contains(RegExp(r'[A-Z]'));
      final hasLowercase = password.contains(RegExp(r'[a-z]'));
      final hasDigit = password.contains(RegExp(r'[0-9]'));
      final hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      if (password.isEmpty) {
        _passwordError = "Password cannot be empty";
      } else if (password.length < 8) {
        _passwordError = "Password must be at least 8 characters";
      } else if (!hasUppercase) {
        _passwordError = "Password must contain an uppercase letter";
      } else if (!hasLowercase) {
        _passwordError = "Password must contain a lowercase letter";
      } else if (!hasDigit) {
        _passwordError = "Password must contain a number";
      } else if (!hasSpecialChar) {
        _passwordError = "Password must contain a special character";
      } else {
        _passwordError = null;
      }

      // Confirm password validation
      if (_confirm.text != password) {
        _confirmError = "Passwords do not match";
      } else {
        _confirmError = null;
      }
    });

    return _emailError == null &&
        _userError == null &&
        _passwordError == null &&
        _confirmError == null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Create your account",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            "Fill in the form below to register",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),

          SizedBox(height: 24),

          // Email field
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

          SizedBox(height: 16),

          // Full Name field
          TextField(
            controller: _userName,
            decoration: InputDecoration(
              labelText: "Full Name",
              hintText: "Enter your full name",
              prefixIcon: Icon(Icons.person_outline),
              errorText: _userError,
            ),
          ),

          SizedBox(height: 16),

          // Password field
          TextField(
            controller: _password,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Create a strong password",
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

          SizedBox(height: 16),

          // Confirm Password field
          TextField(
            controller: _confirm,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: "Confirm Password",
              hintText: "Confirm your password",
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              errorText: _confirmError,
            ),
          ),

          SizedBox(height: 16),
          SizedBox(height: 24),

          // Register button
          SizedBox(
            width: double.infinity,
            child: _isLoading
                ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFCC01)),
              ),
            )
                : ElevatedButton(
              onPressed: _registerUser,
              child: Text("Register"),
            ),
          ),

          SizedBox(height: 16),

          // Back to login
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => page_login()),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color(0xFFFFCC01)),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Back to Login",
                style: TextStyle(
                  color: Color(0xFFFFCC01),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}