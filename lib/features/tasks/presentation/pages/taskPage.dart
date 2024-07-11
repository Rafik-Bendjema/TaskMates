import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmates/features/tasks/presentation/pages/addtask.dart';

import '../../../auth/presentation/provider/userProvider.dart';
import '../widgets/TaskDone.dart';
import '../../data/task.dart';
import '../widgets/taskView.dart';

class TaskPage extends ConsumerStatefulWidget {
  const TaskPage({super.key});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> {
  bool addClicked = false;
  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider);
    return tasks.when(
      data: (data) {
        print("here is data ${data.length}");

        List<Task> doneTasks = [];
        List<Task> todaysTasks = [];

        List<Task> waitingTasks = [];
        for (Task task in data) {
          if (task.date.day == DateTime.now().day &&
              task.date.year == DateTime.now().year &&
              task.date.month == DateTime.now().month) {
            todaysTasks.add(task);
            if (task.isDone) {
              doneTasks.add(task);
            } else {
              waitingTasks.add(task);
            }
          }
        }
        if (addClicked) {
          return Addtask(
            isEditing: false,
          );
        }
        return Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Today"),
                    Text("${doneTasks.length}/${todaysTasks.length}")
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Stack(
                  children: [
                    Divider(
                      thickness: 3,
                    ),
                    Divider(
                      color: Colors.green,
                      endIndent: 0,
                      thickness: 3,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      TaskDone(
                        tasks: doneTasks,
                      ),
                      TaskView(tasks: waitingTasks)
                    ],
                  ),
                )
              ],
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
