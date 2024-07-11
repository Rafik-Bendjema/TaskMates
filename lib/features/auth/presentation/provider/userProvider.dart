import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmates/features/auth/data/user.dart';

import '../../../friends/data/friends.dart';
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

final friendsProvider = StreamProvider<List<Friend>>((ref) {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots()
      .asyncMap((userDoc) async {
    var data = userDoc.data() as Map<String, dynamic>;
    List<String> friendIds =
        data.containsKey('friends') ? List<String>.from(data['friends']) : [];

    List<Friend> friends = await Future.wait(friendIds.map((friendId) async {
      DocumentSnapshot friendDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(friendId)
          .get();
      var friendData = friendDoc.data() as Map<String, dynamic>;
      QuerySnapshot tasksSnapshot =
          await friendDoc.reference.collection('tasks').get();
      List<Task> tasks = tasksSnapshot.docs
          .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      return Friend.fromSnapshot(friendDoc.id, friendData, tasks);
    }).toList());

    return friends;
  });
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
      .orderBy('creationDate')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            return Task.fromMap(doc.data());
          }).toList());
});
