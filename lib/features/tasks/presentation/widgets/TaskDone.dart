import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmates/features/tasks/presentation/widgets/TaskTile.dart';
import 'package:taskmates/features/tasks/data/task.dart';

import '../../domain/taskDb.dart';

class TaskDone extends ConsumerStatefulWidget {
  final bool ignore;
  final List<Task> tasks;

  const TaskDone({super.key, required this.tasks, this.ignore = false});

  @override
  _TaskDoneState createState() => _TaskDoneState();
}

class _TaskDoneState extends ConsumerState<TaskDone>
    with SingleTickerProviderStateMixin {
  double _dragExtent = 0.0;

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
            child: IgnorePointer(
              ignoring: widget.ignore,
              child: Column(
                children: [
                  if (isExtended)
                    Column(
                      children: [
                        Column(
                          children: widget.tasks.map((task) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return GestureDetector(
                                  onHorizontalDragUpdate: (details) {
                                    setState(() {
                                      _dragExtent = details.primaryDelta! + 20;
                                    });
                                  },
                                  onHorizontalDragEnd: (details) async {
                                    if (_dragExtent > 20) {
                                      setState(() {
                                        _dragExtent = 0.0;
                                      });
                                      print('Delete ${task.title}');
                                      Taskdb taskdb = TaskDb_impl();
                                      task.isDone = !task.isDone;
                                      await taskdb.editTask(task);
                                    } else {
                                      setState(() {
                                        _dragExtent = 0.0;
                                      });
                                    }
                                  },
                                  child: Transform.translate(
                                    offset: Offset(_dragExtent, 0),
                                    child: TaskTile(
                                      Color(task.color),
                                      task.title,
                                      task.coTask_id,
                                    ),
                                  ),
                                );
                              },
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
            ),
          )
        ]));
  }
}
