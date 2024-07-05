import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userIdProvider = StateNotifierProvider<UseridNotifier, String?>((ref) {
  return UseridNotifier();
});

class UseridNotifier extends StateNotifier<String?> {
  UseridNotifier() : super(null);

  void setUserId(String? userId) {
    state = userId;
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

final tasksProvider =
    StreamProvider.family<QuerySnapshot<Map<String, dynamic>>, String>(
        (ref, userId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('tasks')
      .snapshots();
});
