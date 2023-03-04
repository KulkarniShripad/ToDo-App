// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:to_do_app/assets/mytextfeild.dart';
import 'package:to_do_app/pages/homepage.dart';
import 'package:to_do_app/pages/mainpage.dart';
import 'package:to_do_app/pages/resetpassword.dart';
import 'package:to_do_app/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class login extends StatefulWidget {
  final VoidCallback showregisterpage;
  login({super.key, required this.showregisterpage});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future log_in() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        });

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.toString().trim(),
      password: passwordController.text,
    );

    Navigator.of(context).pop();
  }

  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  signInWithGoogle() async {
    final GoogleSignInAccount? user = await GoogleSignIn().signIn();

    GoogleSignInAuthentication auth = await user!.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken, idToken: auth.idToken);

    return await FirebaseAuth.instance.signInWithCredential(credential);
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
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/login.jpg'),

              SizedBox(height: 50),

              // welcome back, you've been missed!
              Text(
                'Welcome to your To-Do App!',
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 45),

              // username textfield
              Container(
                margin: EdgeInsets.symmetric(horizontal: 28),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: TextField(
                    controller: emailController,
                    obscureText: false,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: 'Email ID',
                        hintStyle: TextStyle(color: Colors.grey[500])),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // password textfield
              Container(
                margin: EdgeInsets.symmetric(horizontal: 28),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey[500])),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // forgot password?
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => resetpassword()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // sign in button
              GestureDetector(
                onTap: log_in,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(horizontal: 80),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // google + apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google button
                  GestureDetector(
                    onTap: () {
                      signInWithGoogle();
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[200],
                      ),
                      child: Image.asset(
                        'images/google.jpeg',
                        height: 30,
                      ),
                    ),
                  ),

                  SizedBox(width: 25),

                  // apple button
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[200],
                      ),
                      child: Image.asset(
                        'images/twitter.jpeg',
                        height: 30,
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(height: 30),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.showregisterpage,
                    child: Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
