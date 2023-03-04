// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:to_do_app/assets/todo.dart';
// import 'package:to_do_app/assets/todoitem.dart';

// // class ToDoList extends StatefulWidget {
// //   @override
// //   _ToDoListState createState() => _ToDoListState();
// // }

// // class _ToDoListState extends State<ToDoList> {
// //   final User = FirebaseAuth.instance.currentUser;

// //   final CollectionReference _todoCollection =
// //       FirebaseFirestore.instance.collection(User!.uid);

// //   Stream<QuerySnapshot> getTasksStream() {
// //     return _todoCollection
// //         .doc()
// //         .collection(User!.uid)
// //         .orderBy('created_at', descending: true)
// //         .snapshots();
// //   }

// //   Future<void> _handleToDochange(String todoid, bool isDone) async {
// //     try {
// //       await _todoCollection
// //           .doc(todoid)
// //           .collection(User!.uid)
// //           .doc(todoid)
// //           .update({'isDone': isDone});
// //     } catch (e) {
// //       print('Error while updating todo: $e');
// //     }
// //   }

// //   Future<void> _handleToDoDelete(String todoid) async {
// //     try {
// //       await _todoCollection
// //           .doc(todoid)
// //           .collection(User!.uid)
// //           .doc(todoid)
// //           .delete();
// //     } catch (e) {
// //       print('Error while deleting todo: $e');
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return StreamBuilder<QuerySnapshot>(
// //       stream: getTasksStream(),
// //       builder: (context, snapshot) {
// //         if (snapshot.hasError) {
// //           return Text('Something went wrong');
// //         }

// //         if (snapshot.connectionState == ConnectionState.waiting) {
// //           return Center(child: CircularProgressIndicator());
// //         }

// //         final documents = snapshot.data!.docs;

// //         return Expanded(
// //           child: ListView.builder(
// //             itemCount: documents.length,
// //             itemBuilder: (context, index) {
// //               final document = documents[index];
// //               final todo = ToDo.fromSnapshot(document);

// //               return ToDoItem(
// //                 todoid: todo.id!,
// //                 onToDoChanged: (bool isDone) {
// //                   _handleToDochange(todo.id!, isDone);
// //                 },
// //                 onDeleteItem: () {
// //                   _handleToDoDelete(todo.id!);
// //                 },
// //               );
// //             },
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

// class ToDoList extends StatefulWidget {
//   const ToDoList({super.key});

//   @override
//   State<ToDoList> createState() => _ToDoListState();
// }

// class _ToDoListState extends State<ToDoList> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: FutureBuilder(
//               future: gettasks(),
//               builder: (context, snapshot) {
//                 return Expanded(
//                   child: ListView.builder(
//                     itemCount: todolist.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: ToDoItem(
//                             todoid: todolist[index],
//                             onToDoChanged: _handleToDochange(todolist[index]),
//                             onDeleteItem: _handleToDoDelete(todolist[index])),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }