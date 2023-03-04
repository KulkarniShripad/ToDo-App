import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/pages/login.dart';
import 'package:to_do_app/pages/mydrawer.dart';
import 'package:to_do_app/pages/myprofile.dart';
import 'pages/homepage.dart';
import 'package:to_do_app/pages/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/pages/mainpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}
