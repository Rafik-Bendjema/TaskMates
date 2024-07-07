import 'package:flutter/material.dart';
import 'package:taskmates/features/tasks/data/task.dart';
import 'package:taskmates/features/tasks/domain/taskDb.dart';
import '../../../home/presentation/widgets/TaskTile.dart';

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
              onHorizontalDragEnd: (details) async {
                if (_dragExtent > 20) {
                  print('Delete ${task.title}');
                  Taskdb taskdb = TaskDb_impl();
                  task.isDone = !task.isDone;
                  await taskdb.editTask(task);
                }
                // Reset drag extent
                /*  setState(() {
                  _dragExtent = 0.0;
                });*/
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
