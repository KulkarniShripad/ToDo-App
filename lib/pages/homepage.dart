import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:to_do_app/assets/stream.dart';
import 'package:to_do_app/pages/mydrawer.dart';
import 'package:to_do_app/assets/todo.dart';
import 'package:to_do_app/assets/todoitem.dart';

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

  final User = FirebaseAuth.instance.currentUser;

  Future<List<String>> gettasks() async {
    List<String> todolist = [];

    await FirebaseFirestore.instance
        .collection(User!.uid)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((document) {
        todolist.add(document.reference.id);
      });
    });

    return todolist;
  }

  Future<String> getname(String name) async {
    final documentSnapshot =
        await FirebaseFirestore.instance.collection(User!.uid).doc().get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return data[name] ?? 'loading';
  }

  Future adduserdetails(
      String name, String username, String email, ToDo toDo) async {
    await FirebaseFirestore.instance.collection(email).doc(toDo.id).set({
      'name': name,
      'username': username,
      'todo': toDo.todoText,
      'isDone': toDo.isDone,
    });
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
                        builder: (context) => profile(
                              name: 'shripad kulkarni',
                              email: User!.email!,
                              username: 'shripad',
                            )));
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('images/prifile.jpg'),
                radius: 20,
              ),
            ),
            Text(
              'Welcome Back',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              child: Icon(Icons.logout),
            )
          ]),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
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
              margin: EdgeInsets.only(top: 20, bottom: 10),
              child: const Text(
                'All To-Dos',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            FutureBuilder(
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
                  return Flexible(
                      child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return ListTile(
                              title: ToDoItem(
                                todoid: todolist[index],
                                onToDoChanged:
                                    _handleToDochange(todolist[index]),
                                onDeleteItem:
                                    _handleToDoDelete(todolist[index]),
                              ),
                            );
                          },
                          childCount: todolist.length,
                        ),
                      ),
                    ],
                  ));
                }
              },
            )
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

  _handleToDochange(String todoid) async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection(User!.uid)
        .doc(todoid)
        .get();
    bool boolValue = documentSnapshot.data()!['isDone'];
    if (boolValue) {
      await FirebaseFirestore.instance.collection(User!.uid).doc(todoid).set({
        'isDone': false,
      });
    }

    setState(() {});
  }

  _handleToDoDelete(String todoid) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection(User!.uid).doc(todoid);
    documentReference.delete().whenComplete(() => null);
  }

  // void addtodoitems(String todo) {
  //   setState(() {
  //     // adduserdetails(name, username, email, toDo)
  //   });
  //   _todocontroller.clear();
  // }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _todocontroller,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Enter your task'),
                autofocus: true,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Raleway",
                ),
              ),
              Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      if (_todocontroller.text.isNotEmpty) {
                        ToDo newtodo = ToDo(
                            id: DateTime.now().second.toString(),
                            todoText: _todocontroller.text);
                        await adduserdetails(
                            getname('name').toString(),
                            getname('username').toString(),
                            User!.email!,
                            newtodo);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Add'),
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

  void _runFilter(String enteredkeyword) {
    List<String> result = [];
    if (enteredkeyword.isEmpty) {
      result = todolist;
    } else {
      result = todolist
          .where((element) => getname('todo')
              .toString()
              .toLowerCase()
              .contains(enteredkeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      foundtodo = result;
    });
  }
}
