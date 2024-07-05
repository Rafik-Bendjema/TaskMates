import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskmates/features/auth/presentation/pages/Signin.dart';
import 'package:taskmates/features/home/presentation/pages/home.dart';
import 'package:taskmates/features/splash/presentation/pages/Splash.dart';

class Decider extends StatefulWidget {
  const Decider({super.key});

  @override
  State<Decider> createState() => _DeciderState();
}

class _DeciderState extends State<Decider> {
  @override
  Widget build(BuildContext context) {
    print("m here");
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            print("there is data");
            if (snapshot.data == null) {
              return const Signin();
            } else {}
            return const HomePage();
          }
          return const Signin();
        });
  }
}
