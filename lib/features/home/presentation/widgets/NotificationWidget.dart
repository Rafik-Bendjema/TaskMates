import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskmates/features/home/presentation/widgets/invitationDialog.dart';

class NotificationsWidget extends StatelessWidget {
  const NotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        int invitationCount = 0;
        int coTaskInvitationCount = 0;

        if (snapshot.hasError) {
          return IconButton(
            onPressed: () {},
            icon: const Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.notifications),
                Positioned(
                  bottom: -6,
                  right: 0,
                  child: Text(
                    '!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.data != null &&
            snapshot.data!.exists) {
          var data = snapshot.data!.data() as Map<String, dynamic>;

          // Count invitations
          if (data.containsKey('invitation')) {
            List<dynamic> invitations = data['invitation'];
            invitationCount = invitations.length;
          }

          // Count task invitations
          if (data.containsKey('coTask_inv')) {
            List<dynamic> coTaskInvitation = data['coTask_inv'];
            print("this is the co task val $coTaskInvitation");
            if (coTaskInvitation[1] == false) {
              coTaskInvitationCount = 1;
            }
          }
        }

        int totalInvitationCount = invitationCount + coTaskInvitationCount;
        print("this is coTask inv $coTaskInvitationCount");

        return IconButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (context) => InvitationsDialog(
                invitationsData: snapshot.data,
              ),
            );
          },
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications),
              if (totalInvitationCount > 0)
                Positioned(
                  bottom: -6,
                  right: 0,
                  child: Text(
                    '$totalInvitationCount',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
