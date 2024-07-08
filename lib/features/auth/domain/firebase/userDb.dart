import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmates/features/auth/data/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskmates/features/auth/presentation/provider/userProvider.dart';

abstract class UserDb {
  Future<UserModel?> singUp(UserModel u);
  Future<String?> singIn(String email, String pwd);
  Future<String?> addFriend(String id, WidgetRef ref);
}

class UserDbImpl extends UserDb {
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Future<String?> singIn(String email, String pwd) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pwd);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        print("Wrong password provided for that user.");
        return 'Wrong password provided for that user.';
      }
    }
    return null;
  }

  @override
  Future<UserModel?> singUp(UserModel u) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: u.email,
        password: u.pwd,
      );
      u.firebaseId = credential.user?.uid;

      db
          .collection("users")
          .doc(u.firebaseId)
          .set(u.toJson())
          .onError((e, _) => print("Error writing document: $e"));

      if (FirebaseAuth.instance.currentUser != null) {
        FirebaseAuth.instance.signOut();
      }

      return u;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<String> addFriend(String id, WidgetRef ref) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return "No user is connected.";

    UserModel? currentUser = ref.read(userIdProvider);
    if (currentUser == null) {
      return "User not found.";
    }

    if (currentUser.id == id) {
      return "It's you, dummy!";
    }

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: id)
          .get();

      if (querySnapshot.size == 0) {
        return "User not found.";
      }
      var mydoc = await db.collection('users').doc(uid).get();
      List<String>? invitaion =
          (mydoc.data() as Map<String, dynamic>)['invitaion'] as List<String>?;
      if (invitaion != null && invitaion.contains(uid)) {
        //here add friend later
      }
      DocumentSnapshot doc = querySnapshot.docs.first;

      await doc.reference.update({
        'invitation': FieldValue.arrayUnion([currentUser.id])
      });

      return "Invitation sent.";
    } catch (e) {
      print("Error adding friend: $e");
      return "Error sending invitation.";
    }
  }
}
