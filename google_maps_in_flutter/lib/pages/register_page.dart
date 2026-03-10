///working to differentiate login and register page

import 'package:flutter/material.dart';
import 'package:google_maps_in_flutter/pages/login_page.dart';
import 'dart:convert';
import'package:http/http.dart' as http;
import 'package:google_maps_in_flutter/main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> submit() async {
    print("Submission function called"); 
    
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final url = Uri.parse( //http request
        "http://10.0.2.2:5000/register"
    );

    try{
      print("Sending request to: $url");

      final response = await http.post( //may differentiate login and register methods
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "name": email,
        }),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("BODY: ${response.body}");


      if(response.statusCode == 200) { //if register successful
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        print("Server error, rejected request: ${response.body}");
      }
    }
    catch (e) {
      print("Some error: $e");
    }
  }


  @override
  Widget build(BuildContext context){
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
            const SizedBox(height: 30),
            ElevatedButton( 
              onPressed: (){
                print("Confirm button press");
                submit();
              },
              child: Text("Register"),
            ),
            TextButton( 
              onPressed: (){
              Navigator.pushReplacement( //if create acc button clicked, route to register page
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              );
              },
              child: Text(
                  "Login to Account"
              ),
            )
          ]
        )
      ),
    );
  }

}