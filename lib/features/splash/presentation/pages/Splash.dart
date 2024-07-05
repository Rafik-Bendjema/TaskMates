import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskmates/core/widgets/background.dart';
import 'package:taskmates/features/auth/presentation/pages/Signin.dart';
import 'package:taskmates/features/auth/presentation/pages/Singup.dart';
import 'package:taskmates/features/auth/presentation/pages/decider.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    waiter();
    super.initState();
  }

  void waiter() async {
    await Future.delayed(const Duration(seconds: 3));
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
        body: Stack(
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
        ));
  }
}
