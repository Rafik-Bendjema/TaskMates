import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmates/core/widgets/background.dart';
import 'package:taskmates/features/auth/presentation/pages/decider.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isDone = false;
  @override
  void initState() {
    waiter();
    super.initState();
  }

  void waiter() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Decider()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0XFF8EE18E),
        body: Consumer(
          builder: (c, ref, _) {
            return Stack(
              children: [
                background(context),
                const Center(
                  child: Text(
                    "TaskMates",
                    style: TextStyle(
                        fontFamily: 'Kalam',
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                        color: Colors.white),
                  ),
                )
              ],
            );
          },
        ));
  }
}
