import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:quiz_one/main.dart';
import 'package:quiz_one/pages/auth/page_login.dart';
import 'auth_service.dart';

class page_forgotpw extends StatelessWidget {
  const page_forgotpw({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Forgot Password",
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
          title: Text("Forgot Password"),
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
  final TextEditingController _email = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  String? _emailError;

  Future<void> _resetPassword() async {
    // Validate email
    setState(() {
      if (_email.text.trim().isEmpty) {
        _emailError = "Email cannot be empty";
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_email.text.trim())) {
        _emailError = "Please enter a valid email address";
      } else {
        _emailError = null;
      }
    });

    if (_emailError != null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await _authService.resetPassword(
        email: _email.text.trim(),
        context: context,
      );

      if (success) {
        _authService.showSuccessSnackBar(
            context,
            "Password reset email sent! Check your inbox."
        );

        // Clear email field
        _email.clear();

        // Navigate back to login after a short delay
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const page_login()),
          );
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Reset Your Password",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            "Enter your email address and we'll send you a link to reset your password",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),

          SizedBox(height: 32),

          // Email field
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Enter your email address",
              prefixIcon: Icon(Icons.email_outlined),
              errorText: _emailError,
            ),
          ),

          SizedBox(height: 32),

          // Reset Password button
          SizedBox(
            width: double.infinity,
            child: _isLoading
                ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFCC01)),
              ),
            )
                : ElevatedButton(
              onPressed: _resetPassword,
              child: Text("Send Reset Link"),
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