import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/assets/mytextfeild.dart';

class SignUp extends StatefulWidget {
  final VoidCallback showloginpage;
  const SignUp({Key? key, required this.showloginpage}) : super(key: key);

  @override
  State<SignUp> createState() => SignupState();
}

final User? user = FirebaseAuth.instance.currentUser;

class SignupState extends State<SignUp> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _cpassword = TextEditingController();

  Future<void> adduserdetails(String name, String username) async {
    await FirebaseFirestore.instance.collection('userdetails').doc(name).set({
      'id': user!.uid,
      'username': username,
    });
  }

  Future<void> signup() async {
    if (_password.text.trim() == _cpassword.text.trim()) {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        },
      );
      try {
        // Create user in Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text.toString().trim(),
          password: _password.text,
        );

        adduserdetails(_name.text, _username.text.trim());

        Navigator.of(context).pop();
      } catch (e) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(e.toString()),
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Enter correct password'),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _cpassword.dispose();
    _username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/signup.jpg'),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Create Your To-Do Account',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: MyTextField(
                      controller: _name,
                      hintText: 'Enter your Name',
                      obscureText: false),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: MyTextField(
                      controller: _email,
                      hintText: 'Enter your Email Id',
                      obscureText: false),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: MyTextField(
                      controller: _username,
                      hintText: 'Create a Username',
                      obscureText: false),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: MyTextField(
                      controller: _password,
                      hintText: 'Create a Password',
                      obscureText: true),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: MyTextField(
                      controller: _cpassword,
                      hintText: 'Confirm your Password',
                      obscureText: true),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton.icon(
                  onPressed: signup,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  icon: Icon(Icons.person_add_alt_rounded),
                  label: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Register Now',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: widget.showloginpage,
                      child: Text(
                        'Login here',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
