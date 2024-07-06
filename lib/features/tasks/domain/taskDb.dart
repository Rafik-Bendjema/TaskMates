import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmates/features/tasks/data/task.dart';

abstract class Taskdb {
  Future<List<Task>> getTasks();
  Future<Task?> createTask(Task t);
  Future<bool> deleteTask(Task t);
  Future<Task?> editTask(Task t);
}

class TaskDb_impl extends Taskdb {
  var db = FirebaseFirestore.instance;
  @override
  Future<Task?> createTask(Task t) async {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteTask(Task t) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<Task?> editTask(Task t) {
    // TODO: implement editTask
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> getTasks() async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        throw Exception("user doesn't not logged in");
      }
      await db
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('tasks')
          .get()
          .then((v) {
        for (QueryDocumentSnapshot docSnapshot in v.docs) {
          // Print the document data
          print("here is the content");
          print(docSnapshot.data());
        }
      });
      return [];
    } catch (e) {
      return [];
    }
  }
}
