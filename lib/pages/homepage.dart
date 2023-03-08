import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'myprofile.dart';

class homepage extends StatefulWidget {
  homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List<String> todolist = [];
  List<String> foundtodo = [];
  final _todocontroller = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  Future<List<String>> gettasks() async {
    List<String> todolist = [];

    final collectionRef = FirebaseFirestore.instance.collection('todos');
    final querySnapshot =
        await collectionRef.where('id', isEqualTo: user!.uid).get();
    querySnapshot.docs.forEach((document) {
      todolist.add(document.reference.id);
    });

    return todolist;
  }

  getdata() async {
    final collectionRef =
        FirebaseFirestore.instance.collection('collection_name');

    final querySnapshot =
        await collectionRef.where('id', isEqualTo: user!.uid).get();

    String dataField;

    dataField = querySnapshot.toString();

    return dataField;
  }

  Future adduserdetails(String todo) async {
    await FirebaseFirestore.instance
        .collection('todos')
        .doc(todo)
        .set({'id': user!.uid, 'isdone': false});
  }

  @override
  void initState() {
    foundtodo = todolist;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(
                              name: 'Shripad Kulkarni',
                              email: user!.email!,
                              username: 'shripad',
                            )));
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('images/prifile.jpg'),
                radius: 20,
              ),
            ),
            const Text(
              'Welcome Back',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Icon(Icons.logout),
            )
          ]),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  onChanged: (value) => _runFilter(value),
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black38,
                        size: 20,
                      ),
                      prefixIconConstraints:
                          BoxConstraints(maxHeight: 20, maxWidth: 25),
                      border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.black26)),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              child: const Text(
                'All To-Dos',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: gettasks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.black,
                    ));
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final todolist = snapshot.data as List<String>;
                    return ListView.builder(
                      itemCount: todolist.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: toDoItem(todolist[index]),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Center(
          heightFactor: 1,
          widthFactor: 6,
          child: FloatingActionButton(
            onPressed: () {
              _dialogBuilder(context);
            },
            backgroundColor: Colors.black,
            child: const Icon(
              Icons.add,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _todocontroller,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Enter your task'),
                autofocus: true,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: "Raleway",
                ),
              ),
              Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      if (_todocontroller.text.isNotEmpty) {
                        adduserdetails(_todocontroller.text.trim());
                        setState(() {
                          gettasks();
                        });
                        _todocontroller.clear();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Add'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black)),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<bool> getisdone(String todo) async {
    final documentSnapshot =
        await FirebaseFirestore.instance.collection('todos').doc(todo).get();
    final boolValue = documentSnapshot.get('isdone') ?? false;
    return boolValue;
  }

  Future _handleToDoChange(String todo) async {
    final docRef =
        FirebaseFirestore.instance.collection('todos').doc(todo.trim());

    try {
      final documentSnapshot = await docRef.get();

      if (documentSnapshot.exists) {
        bool isDone = documentSnapshot.get('isdone');
        await docRef.update({'isdone': !isDone});
        setState(() {});
      } else {
        print('value does not exist');
      }
    } catch (e) {
      if (e is FirebaseException && e.code == 'not-found') {
        print('Document not found');
      } else {
        print('Error: $e');
      }
    }
  }

  Future<void> _handleToDoDelete(String todo) async {
    final collectionRef = FirebaseFirestore.instance.collection('todos');

    final querySnapshot =
        await collectionRef.where('id', isEqualTo: user!.uid).get();
    querySnapshot.docs.forEach((doc) {
      if (doc.id == todo) {
        doc.reference.delete();
      }
    });

    setState(() {});
  }

  toDoItem(String todo) {
    return FutureBuilder(
      future: getisdone(todo),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        } else if (snapshot.hasData) {
          final isDone = snapshot.data as bool;
          // Use the value of isDone here
          return Container(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              onTap: () async {
                await _handleToDoChange(todo);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              tileColor: Colors.white,
              leading: Icon(
                isDone ? Icons.check_box : Icons.check_box_outline_blank,
                color: Colors.black,
              ),
              title: Text(
                todo,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  color: Colors.white,
                  iconSize: 18,
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await _handleToDoDelete(todo);
                  },
                ),
              ),
            ),
          );
        } else {
          // Handle case where future completes with an error
          return Text('Error: ${snapshot.error}');
        }
      },
    );
  }

  void _runFilter(String enteredkeyword) {
    List<String> result = [];
    if (enteredkeyword.isEmpty) {
      result = todolist;
    } else {
      int index = todolist.length;
      for (int i = 0; i < index; i++) {
        result = todolist
            .where((element) => todolist[i]
                .toString()
                .toLowerCase()
                .contains(enteredkeyword.toLowerCase()))
            .toList();
      }
    }

    setState(() {
      foundtodo = result;
    });
  }
}
