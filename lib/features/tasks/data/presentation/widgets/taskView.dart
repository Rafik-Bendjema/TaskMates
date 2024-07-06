import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:taskmates/features/tasks/data/task.dart';

import '../../../../home/presentation/widgets/TaskTile.dart';

class Taskview extends StatelessWidget {
  final List<Task> tasks;
  const Taskview({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: tasks.map((task) {
            return TaskTile(
              Color(task.color),
              task.title,
              task.coTask,
            );
          }).toList(),
        ),
      ],
    );
  }
}
