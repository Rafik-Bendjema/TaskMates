import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    print("this is the co task ${t.coTask_id}  and the uid ${t.coTask}");
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    try {
      await db
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(t.id)
          .set(t.toMap());
      if (t.coTask != null) {
        String id = await db
            .collection('users')
            .doc(uid)
            .get()
            .then((v) => (v.data() as Map<String, dynamic>)['id']);
        String coTaskuid = t.coTask!;
        t.coTask = uid;
        t.coTask_id = id;
        await db
            .collection('users')
            .doc(coTaskuid)
            .collection('tasks')
            .doc(t.id)
            .set(t.toMap());
      }
      return t;
    } catch (e) {
      print("here is the error ${e.toString()}");
      return null;
    }
  }

  @override
  Future<bool> deleteTask(Task t) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;
    try {
      await db
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(t.id)
          .delete();
      if (t.coTask != null) {
        await db
            .collection('users')
            .doc(t.coTask)
            .collection('tasks')
            .doc(t.id)
            .delete();
      }
      return true;
    } catch (e) {
      print("error deleting doc ${e.toString()}");
      return false;
    }
  }

  @override
  Future<Task?> editTask(Task t) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    try {
      await db
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(t.id)
          .set(t.toMap());
      if (t.coTask != null) {
        String id = await db
            .collection('users')
            .doc(uid)
            .get()
            .then((v) => (v.data() as Map<String, dynamic>)['id']);
        String coTaskuid = t.coTask!;
        t.coTask = uid;
        t.coTask_id = id;
        await db
            .collection('users')
            .doc(coTaskuid)
            .collection('tasks')
            .doc(t.id)
            .set(t.toMap());
      }
      return t;
    } catch (e) {
      print('error');
      return null;
    }
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
