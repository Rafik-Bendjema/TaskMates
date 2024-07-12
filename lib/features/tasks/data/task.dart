import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String? id;
  final String title;
  final DateTime date;
  late DateTime creationDate;
  final Duration? duration;
  bool isDone;
  final int color;
  String? coTask;
  String? coTask_id;

  final String notes;

  Task(
      {required this.title,
      required this.date,
      this.coTask,
      this.coTask_id,
      this.duration,
      required this.isDone,
      this.color = 4294198070,
      required this.creationDate,
      required this.notes,
      this.id}) {
    if (id == null) {
      Uuid uuid = const Uuid();
      id = uuid.v1();
    }
  }

  factory Task.fromMap(Map<String, dynamic> data) {
    return Task(
        title: data['title'] ?? '',
        date: (data['date'] as Timestamp).toDate(),
        duration: Duration(minutes: data['duration'] ?? 0),
        coTask: data['Co-task'],
        coTask_id: data['co-task-id'],
        isDone: data['done'],
        notes: data['notes'] ?? "",
        color: data['color'],
        creationDate: (data['creationDate'] as Timestamp).toDate())
      ..id = data['id'] ?? "null";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'creationDate': creationDate,
      'duration': duration?.inMinutes,
      'Co-task': coTask,
      'done': isDone,
      'color': color,
      'notes': notes,
      'co-task-id': coTask_id
    };
  }
}
