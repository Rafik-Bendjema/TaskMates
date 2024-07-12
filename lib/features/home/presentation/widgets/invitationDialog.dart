import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmates/features/auth/domain/firebase/userDb.dart';
import 'package:taskmates/features/home/presentation/pages/Timer.dart';
import 'package:taskmates/features/tasks/data/task.dart';

class InvitationsDialog extends StatelessWidget {
  final DocumentSnapshot? invitationsData;

  const InvitationsDialog({super.key, this.invitationsData});

  @override
  Widget build(BuildContext context) {
    List<dynamic> invitations = [];
    List<dynamic> coTaskInvitations = [];

    if (invitationsData != null && invitationsData!.exists) {
      var data = invitationsData!.data() as Map<String, dynamic>;
      if (data.containsKey('invitation')) {
        invitations = data['invitation'];
      }
      if (data.containsKey('coTask_inv') &&
          (data['coTask_inv'] as List)[1] == false) {
        coTaskInvitations = data['coTask_inv'];
      }
    }

    /* List<dynamic> allInvitations = invitations +
        coTaskInvitations
            .where((inv) =>
                inv is List<dynamic> && inv.length == 2 && inv[1] == false)
            .toList(); 
            */

    return Dialog(
      child: SizedBox(
        width: 200,
        height: 500,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              ' Invitations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "  Co-Task invitations",
                  style: TextStyle(fontSize: 20),
                )),
            coTaskInvitations.isNotEmpty
                ? FutureBuilder<Object>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('tasks')
                        .doc(coTaskInvitations[0]!)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        DocumentSnapshot data =
                            snapshot.data as DocumentSnapshot;
                        String title =
                            (data.data() as Map<String, dynamic>)['title'];
                        return Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(title),
                              TextButton(
                                  onPressed: () async {
                                    List list = [];
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .get()
                                        .then((v) {
                                      List invit = v.get('coTask_inv');
                                      invit[1] = true;
                                      list = invit;
                                    });
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .update({'coTask_inv': list});
                                    Task t = Task.fromMap(
                                        data.data() as Map<String, dynamic>);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TimerScreen(task: t)));
                                  },
                                  child: const Text("accept"))
                            ],
                          ),
                        );
                      }
                      return const Text("no coTask invitations");
                    })
                : const Text("no co Task invitations"),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "  friend invitations",
                  style: TextStyle(fontSize: 20),
                )),
            Expanded(
              child: invitations.isEmpty
                  ? const Center(child: Text('No invitations found.'))
                  : Padding(
                      padding: const EdgeInsets.all(13),
                      child: ListView.builder(
                        itemCount: invitations.length,
                        itemBuilder: (BuildContext context, int index) {
                          var invitation = invitations[index];
                          String invitationText = invitation is String
                              ? invitation
                              : 'Task Invitation: ${(invitation as List<dynamic>)[0]}';

                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color.fromARGB(255, 229, 229, 229),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(invitationText),
                                Consumer(
                                  builder: (context, ref, _) => TextButton(
                                    onPressed: () async {
                                      UserDb userDb = UserDbImpl();
                                      bool result =
                                          await userDb.acceptInvitation(
                                              invitationText, ref);
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
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
