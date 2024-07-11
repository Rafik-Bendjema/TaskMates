import 'package:flutter/material.dart';
import 'package:taskmates/features/home/presentation/pages/Timer.dart';
import 'package:taskmates/features/tasks/data/task.dart';
import 'package:taskmates/features/tasks/domain/taskDb.dart';
import 'package:taskmates/features/tasks/presentation/pages/addtask.dart';
import 'TaskTile.dart';

class TaskView extends StatefulWidget {
  final List<Task> tasks;
  const TaskView({super.key, required this.tasks});

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  double _dragExtent = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                          content:
                              const Text("you sure want to delete this task ?"),
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
                  bool timer = false;
                  setState(() {
                    _dragExtent = 0.0;
                  });
                  if (task.duration != null && task.duration != Duration.zero) {
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
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => TimerScreen(
                                                    task: task,
                                                  )));
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
                  task.coTask,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
