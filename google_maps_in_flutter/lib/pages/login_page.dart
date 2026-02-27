import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Modularized log in page, connects email to firebase db
//Functional, need to improve UI and debug more


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
    try{
      if(isLogin){
        await FirebaseAuth.instance.signInWithEmailAndPassword(   
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        print("User logged in");
      } else{ //if !isLogin
        //registed new user
        await FirebaseAuth.instance.createUserWithEmailAndPassword( 
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        print("User registered!");
      }
    } catch(e) { 
      print("Auth error: $e");
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
              onPressed: submit,
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
