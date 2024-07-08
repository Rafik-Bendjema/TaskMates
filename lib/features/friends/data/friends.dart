import '../../tasks/data/task.dart';

class Friends {
  String? firebaseId;
  final String id;
  final List<Task> todaysTasks;
  Friends({required this.id, required this.todaysTasks});
}
