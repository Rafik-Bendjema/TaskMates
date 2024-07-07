import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Taskstats extends StatefulWidget {
  const Taskstats({super.key});

  @override
  State<Taskstats> createState() => _TaskstatsState();
}

class _TaskstatsState extends State<Taskstats> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Task stats"),
    );
  }
}
