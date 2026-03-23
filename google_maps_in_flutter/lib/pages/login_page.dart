import 'package:flutter/material.dart';
import 'package:google_maps_in_flutter/pages/register_page.dart';
import 'package:google_maps_in_flutter/pages/otp_verification_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_in_flutter/main.dart';

//currently working to separate login and register page (to implement email auth, password reset, etc.)
//implement snack bar widget (for smaller/temporary messages to user)

//finished front end of improved login, need to work on flask integration for password reset

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> submit() async {
    setState(() {
      //default state, waiting for input, no current errors
      _isLoading = true;
      _errorMessage = null;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Please enter your email and password.";
        _isLoading = false;
      });
      return;
    }

    final url = Uri.parse(
      //http request
      "http://10.0.2.2:5000/login",
    );

    try {
      final response = await http.post(
        //may differentiate login and register methods
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password, "name": email}),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        //if login/register successful

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else if (response.statusCode == 403) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OtpVerificationPage(email: email)),
        );
      } else {
        //want to add specific message if email exists but password is wrong vs email dne
        final body = jsonDecode(response.body);
        setState(() {
          _errorMessage =
              body['error'] ??
              body['message'] ??
              "Login failed. Please check your credentials.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Other error";
      });
    } finally {
      //mark end of loading regardless of outcome
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _sendPasswordReset() async {
    //process for resetting password
    final email = emailController.text.trim();

    if (email.isEmpty) {
      setState(() => _errorMessage = "Enter your email to reset your password");
      return;
    }
    //need to add verification to this state, http method dne yet
    final url = Uri.parse(
      "http://10.0.2.2:5000/reset-password",
    ); //add logic to allow password reset (user can reset password for given email?)
    //need Flask server integration, backend should recieve email, generate reset token, and send email to user with coresponding token
    try {
      final response = await http.post(
        //begin process to send reset link
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );
      final body = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(body['message'] ?? "Attempting to send reset link"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error occurred")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ), //text style for error messages
              ),
            ],

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isLoading ? null : submit,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Login"),
            ),

            Align(
              //button for password reset
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _sendPasswordReset,
                child: const Text("Forgot password?"),
              ),
            ),

            TextButton(
              //button to route to register page instead
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              child: Text("Create an account"),
            ),
          ],
        ),
      ),
    );
  }
}
