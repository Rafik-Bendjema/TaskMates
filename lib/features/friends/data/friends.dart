import 'package:taskmates/features/tasks/data/task.dart';

class Friend {
  final String friendId;
  final String docId;
  final List<Task> tasks;

  Friend({required this.friendId, required this.docId, required this.tasks});

  factory Friend.fromSnapshot(
      String docId, Map<String, dynamic> data, List<Task> tasks) {
    return Friend(
      friendId: data['id'] ?? '',
      docId: docId,
      tasks: tasks,
    );
  }
}
