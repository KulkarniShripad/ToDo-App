import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/assets/todo.dart';

class ToDoItem extends StatelessWidget {
  final String todoid;
  final onToDoChanged;
  final onDeleteItem;

  ToDoItem({
    Key? key,
    required this.todoid,
    required this.onToDoChanged,
    required this.onDeleteItem,
  }) : super(key: key);

  final User = FirebaseAuth.instance.currentUser;

  Future<String> gettodo() async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection(User!.uid)
        .doc(todoid)
        .get();
    Map<String, dynamic> data =
        await documentSnapshot.data() as Map<String, dynamic>;
    return data['todo'] ?? 'loading';
  }

  Future<bool> getisdone() async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection(User!.uid)
        .doc(todoid)
        .get();
    final boolValue = documentSnapshot.get('isDone') ?? false;
    return boolValue;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([gettodo(), getisdone()]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        } else {
          final todo = snapshot.data![0] as String;
          final isDone = snapshot.data![1] as bool;
          return Container(
            margin: EdgeInsets.all(15),
            child: ListTile(
              onTap: () {
                onToDoChanged(todoid);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.symmetric(vertical: 12),
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  color: Colors.white,
                  iconSize: 18,
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    onDeleteItem(todoid);
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
