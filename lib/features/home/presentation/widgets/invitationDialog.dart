import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmates/features/auth/domain/firebase/userDb.dart';

class InvitationsDialog extends StatelessWidget {
  const InvitationsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 200,
        height: 500,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Invitations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<dynamic> invitations = [];

                  if (snapshot.data!.exists) {
                    var data = snapshot.data!.data() as Map<String, dynamic>;
                    if (data.containsKey('invitation')) {
                      invitations = data['invitation'];
                    }
                  }

                  if (invitations.isEmpty) {
                    return const Center(child: Text('No invitations found.'));
                  }

                  return Padding(
                    padding: const EdgeInsets.all(13),
                    child: ListView.builder(
                      itemCount: invitations.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color.fromARGB(255, 229, 229, 229),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(invitations[index]),
                              Consumer(
                                builder: (context, ref, _) => TextButton(
                                  onPressed: () async {
                                    UserDb userDb = UserDbImpl();
                                    bool result = await userDb.acceptInvitation(
                                        invitations[index], ref);
                                    if (!result) {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const AlertDialog(
                                                title: Text("error"),
                                                content: Text(
                                                    "error accepting friend's invitation"),
                                              ));
                                    }
                                  },
                                  child: const Text("accept"),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
