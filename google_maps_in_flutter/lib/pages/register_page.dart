///working to differentiate login and register page

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_in_flutter/pages/login_page.dart';
import 'package:google_maps_in_flutter/pages/otp_verification_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = "Email and password are required.");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final url = Uri.parse(
      //http request
      "http://10.0.2.2:5000/register",
    );

    try {
      final response = await http.post(
        //may differentiate login and register methods
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password, "name": email}),
      );

      if (response.statusCode == 200) {
        //if register successful
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => OtpVerificationPage(email: email)),
        );
      } else {
        final body = jsonDecode(response.body);
        setState(() {
          _errorMessage =
              body['error'] ?? body['message'] ?? "Registration failed.";
        });
      }
    } catch (_) {
      setState(() {
        _errorMessage = "Unable to reach server. Please try again.";
      });
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : submit,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Register"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  //if create acc button clicked, route to register page
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: Text("Login to Account"),
            ),
          ],
        ),
      ),
    );
  }
}
