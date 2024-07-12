import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskmates/features/home/presentation/pages/Timer.dart';
import 'package:taskmates/features/tasks/data/task.dart';
import 'package:taskmates/features/tasks/domain/taskDb.dart';
import 'package:taskmates/features/tasks/presentation/pages/addtask.dart';
import 'TaskTile.dart';

class TaskView extends StatefulWidget {
  final List<Task> tasks;
  final bool ignore;
  const TaskView({super.key, required this.tasks, this.ignore = false});

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  void navigateToTimerScreen(BuildContext context, Task task) {
    Navigator.of(context).pop(); // Close the dialog
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TimerScreen(task: task),
    ));
  }

  double _dragExtent = 0.0;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.ignore,
      child: Column(
        children: widget.tasks.map((task) {
          return StatefulBuilder(
            builder: (context, setState) {
              return GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _dragExtent = details.primaryDelta! + 20;
                  });
                },
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text("deletion check"),
                            content: const Text(
                                "you sure want to delete this task ?"),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    Taskdb taskdb = TaskDb_impl();
                                    bool res = await taskdb.deleteTask(task);
                                    Navigator.pop(context);
                                    if (res != true) {
                                      showDialog(
                                          context: context,
                                          builder: (context) => const Dialog(
                                                child: SizedBox(
                                                  height: 100,
                                                  child: Center(
                                                    child: Text(
                                                        "error deleting task"),
                                                  ),
                                                ),
                                              ));
                                    }
                                  },
                                  child: const Text("yes")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel"))
                            ],
                          ));
                },
                onTap: () {
                  print('this is edited task id ${task.id}');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SafeArea(
                                child: Scaffold(
                                  appBar: AppBar(),
                                  body: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Center(
                                      child: Addtask(
                                        isEditing: true,
                                        task: task,
                                      ),
                                    ),
                                  ),
                                ),
                              )));
                },
                onHorizontalDragEnd: (details) async {
                  if (_dragExtent > 20) {
                    setState(() {
                      _dragExtent = 0.0;
                    });
                    if (task.duration != null &&
                        task.duration != Duration.zero) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text("timer check"),
                                content: const Text(
                                    "would you like to start the timer ? "),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        Taskdb taskdb = TaskDb_impl();
                                        task.isDone = !task.isDone;
                                        await taskdb.editTask(task);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("NO")),
                                  TextButton(
                                      onPressed: () async {
                                        if (task.coTask != null) {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(task.coTask)
                                              .update({
                                            'coTask_inv': [task.id, false]
                                          });
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              child: StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('users')
                                                    .doc(task.coTask)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData &&
                                                      snapshot.data != null) {
                                                    var doc =
                                                        snapshot.data!.data();

                                                    if (doc?['coTask_inv'] !=
                                                        null) {
                                                      if ((doc!['coTask_inv']
                                                                  as List<
                                                                      dynamic>)[
                                                              1] ==
                                                          false) {
                                                        return const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  25),
                                                          child: Text(
                                                              "Waiting for the coTask to accept"),
                                                        );
                                                      } else {
                                                        // Schedule the navigation for the next frame
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                                (_) {
                                                          navigateToTimerScreen(
                                                              context, task);
                                                        });
                                                        // Return an empty container while waiting for navigation
                                                        return Container();
                                                      }
                                                    }
                                                  }
                                                  if (snapshot.hasError) {
                                                    return const Text("Error");
                                                  }
                                                  return const CircularProgressIndicator();
                                                },
                                              ),
                                            ),
                                          );
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TimerScreen(
                                                        task: task,
                                                      )));
                                        }
                                      },
                                      child: const Text("Yes"))
                                ],
                              ));
                    } else {
                      Taskdb taskdb = TaskDb_impl();
                      task.isDone = !task.isDone;
                      await taskdb.editTask(task);
                    }
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
    );
  }
}
