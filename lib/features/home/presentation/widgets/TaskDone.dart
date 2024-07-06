import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmates/features/home/presentation/widgets/TaskTile.dart';
import 'package:taskmates/features/tasks/data/task.dart';

class TaskDone extends ConsumerStatefulWidget {
  final List<Task> tasks;

  const TaskDone({super.key, required this.tasks});

  @override
  _TaskDoneState createState() => _TaskDoneState();
}

class _TaskDoneState extends ConsumerState<TaskDone>
    with SingleTickerProviderStateMixin {
  late List<Task> tasks;

  @override
  void initState() {
    tasks = widget.tasks;
    print("here is length ${tasks.length}");
    super.initState();
  }

  bool isExtended = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          Row(
            children: [
              const Text("done"),
              const SizedBox(
                width: 20,
              ),
              const Expanded(child: Divider()),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      isExtended = !isExtended;
                    });
                  },
                  icon: Icon(isExtended
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down)),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 100),
            child: Column(
              children: [
                if (isExtended)
                  Column(
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
                      const Divider(
                        indent: 100,
                        endIndent: 100,
                      )
                    ],
                  ),
              ],
            ),
          )
        ]));
  }
}
