import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmates/features/auth/presentation/pages/Signin.dart';
import 'package:taskmates/features/home/presentation/pages/home.dart';
import 'package:taskmates/features/splash/presentation/pages/Splash.dart';
import '../provider/userProvider.dart';

class Decider extends ConsumerWidget {
  const Decider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Splash();
        } else if (snapshot.hasError) {
          return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')));
        } else if (snapshot.hasData) {
          final user = snapshot.data;
          if (user == null) {
            return const Signin();
          }

          // Use a FutureBuilder to defer state update
          return FutureBuilder<void>(
            future: _updateUserId(ref, user.uid),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else if (futureSnapshot.hasError) {
                return Scaffold(
                    body:
                        Center(child: Text('Error: ${futureSnapshot.error}')));
              } else {
                return const HomePage();
              }
            },
          );
        } else {
          return const Signin();
        }
      },
    );
  }

  Future<void> _updateUserId(WidgetRef ref, String userId) async {
    await Future.delayed(const Duration(microseconds: 200));
    ref.read(userIdProvider.notifier).setUserId(userId);
  }
}
