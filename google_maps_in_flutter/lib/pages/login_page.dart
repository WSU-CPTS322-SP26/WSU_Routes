import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:google_maps_in_flutter/container_classes/profile.dart';
=======
import 'package:google_maps_in_flutter/pages/register_page.dart';
import 'package:google_maps_in_flutter/pages/verification_page.dart';
import 'package:google_maps_in_flutter/pages/password_reset_page.dart';
>>>>>>> 6d0f7c62a0dc46b48a6aac5f3836fe1a24aa2954
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:google_maps_in_flutter/main.dart';
import '../pages/map.dart';

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
      //default state, wait for input no current errors
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

    final url = Uri.parse( //destination for http request
      "http://10.0.2.2:5000/login",
    );

    try {
      final response = await http.post( //send profile fields to backend method
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password, "name": email}),
      ).timeout(const Duration(seconds: 15));

      print("STATUS CODE: ${response.statusCode}"); //denotes whether request worked (i.e user exists)
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {//success
        final body = jsonDecode(response.body); //retrieve user id (allows preference changes)
        final String userId = body['id'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MapPage(userId: userId)),
        );

        final profile = CurProfile(); //Get's instance of singleton 
        profile.email = emailController.text.trim(); //set email

      } else {
        //may add specific message to differentiate if email exists but password is wrong vs email dne
        final body = jsonDecode(response.body);
        setState(() {
          _errorMessage =
              body['error'] ??
              body['message'] ??
              "Login failed. Either your password is incorrect or you need to create an account";
        });
      }
    //other fail cases
    } on TimeoutException {
      setState(() {
        _errorMessage = "Request timed out. Please try again.";
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Unable to reach server. Please try again.";
      });
    } finally {
      setState(() => _isLoading = false); //spinner stops if failed
    }
  }

  @override
  void dispose() { //clear memory of email and password objects after exit
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PasswordResetPage(
                        initialEmail: emailController.text.trim(),
                      ),
                    ),
                  );
                },
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
