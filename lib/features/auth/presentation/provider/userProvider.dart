import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmates/features/auth/data/user.dart';

import '../../../tasks/data/task.dart';

final userIdProvider = StateNotifierProvider<UseridNotifier, UserModel?>((ref) {
  return UseridNotifier();
});

class UseridNotifier extends StateNotifier<UserModel?> {
  UseridNotifier() : super(null);

  void setUserId(String? userId) async {
    UserModel? u;
    print("this is the uid $userId");
    if (userId != null) {
      var snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      print(snapshot.data());
      u = UserModel.fromJson(userId, snapshot.data()!);
      //friendsProvider(userId);
      //tasksProvider(userId);
    }

    state = u;
  }
}

final userInfoProvider =
    StreamProvider.family<DocumentSnapshot<Map<String, dynamic>>, String>(
        (ref, userId) {
  return FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
});

final friendsProvider =
    StreamProvider.family<QuerySnapshot<Map<String, dynamic>>, String>(
        (ref, userId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('friends')
      .snapshots();
});

final tasksProvider = StreamProvider<List<Task>>((ref) {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // Return an empty stream if user is not logged in
    return Stream.value([]);
  }
  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('tasks')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            return Task.fromMap(doc.data());
          }).toList());
});
