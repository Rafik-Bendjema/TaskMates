import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmates/features/auth/data/user.dart';
import 'package:taskmates/features/auth/presentation/provider/userProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmates/features/home/presentation/widgets/NotificationWidget.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 110,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person),
                  ),
                  Consumer(
                    builder: (context, ref, w) {
                      UserModel? user = ref.watch(userIdProvider);
                      return Text(user?.id ?? '...');
                    },
                  )
                ],
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                child: const Row(
                  children: [Text("Logout"), Icon(Icons.logout)],
                ),
              ),
              const NotificationsWidget(),
            ],
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Good Morning",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
