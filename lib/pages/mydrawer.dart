// import 'dart:js';

import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/pages/homepage.dart';
import 'package:to_do_app/pages/myprofile.dart';

class mydrawer extends StatelessWidget {
  List todolist;
  mydrawer({super.key, required this.todolist});

  final User = FirebaseAuth.instance.currentUser;

  Future<String> getname(String name) async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection(User!.uid)
        .doc(todolist[1])
        .get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return data[name] ?? 'loading';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromRGBO(0, 0, 0, 1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 1)),
                accountName: Text(
                  getname('name').toString().trim(),
                  style: TextStyle(color: Colors.white),
                ),
                accountEmail: Text(
                  User!.email!,
                  style: TextStyle(color: Colors.white),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('images/prifile.jpg'),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.white,
                size: 30,
              ),
              title: TextButton(
                style: ButtonStyle(alignment: Alignment.centerLeft),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => homepage(),
                    ),
                  );
                  // setDefaultVar();
                },
                child: Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 30,
              ),
              title: TextButton(
                style: ButtonStyle(alignment: Alignment.centerLeft),
                onPressed: () async {
                  String name = await getname('name');
                  String username = await getname('username');
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => profile(
                                name: name,
                                email: User!.email!,
                                username: username,
                              )));
                },
                child: const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white,
                size: 30,
              ),
              title: TextButton(
                style: ButtonStyle(alignment: Alignment.centerLeft),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Text(
                  'Log Out',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
