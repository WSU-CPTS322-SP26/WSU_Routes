import 'package:flutter/material.dart';
import 'dart:convert';
import'package:http/http.dart' as http;
import 'package:google_maps_in_flutter/main.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLogin = true; 

  Future<void> submit() async {
    print("Submission function called"); 
    
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final url = Uri.parse( //if user exists in db
      isLogin 
        ? "http://10.0.2.2:5000/login"
        : "http://10.0.2.2:5000/register"
    );

    try{
      print("Sending request to: $url");

      final response = await http.post(
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


      if(response.statusCode == 200) {
        
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
      appBar: AppBar(title: Text(isLogin ? "Login" : "Register")),
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
              child: Text(isLogin ? "Login" : "Register"),
            ),
            TextButton( 
              onPressed: (){
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(isLogin 
                  ? "Create an account"
                  : "Already have an account?"
              ),
            )
          ]
        )
      ),
    );
  }
}
