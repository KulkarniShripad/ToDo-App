import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/assets/mytextfeild.dart';

class resetpassword extends StatefulWidget {
  const resetpassword({super.key});

  @override
  State<resetpassword> createState() => _resetpasswordState();
}

class _resetpasswordState extends State<resetpassword> {
  final resetpass = TextEditingController();

  @override
  void dispose() {
    resetpass.dispose();
    super.dispose();
  }

  Future passwordreset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: resetpass.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text(
                    'Password reset email is sent to your email id, please check your inbox'));
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(content: Text(e.message.toString()));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Enter your Email ID and we will send you and password recovery email',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: MyTextField(
                controller: resetpass,
                hintText: 'Email ID',
                obscureText: false,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            MaterialButton(
              onPressed: passwordreset,
              child: Text(
                'Reset Password',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.black,
            )
          ]),
        ),
      ),
    );
  }
}
