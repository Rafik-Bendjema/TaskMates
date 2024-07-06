import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  late String id;
  final String title;
  final DateTime date;
  final Duration duration;
  final bool isDone;
  final int color;
  String? coTask;

  Task(
      {required this.title,
      required this.date,
      this.coTask,
      required this.duration,
      required this.isDone,
      this.color = 4294198070}) {
    Uuid uuid = const Uuid();
    id = uuid.v1();
  }

  factory Task.fromMap(Map<String, dynamic> data) {
    return Task(
        title: data['title'] ?? '',
        date: (data['date'] as Timestamp).toDate(),
        duration: Duration(minutes: data['duration'] ?? 0),
        coTask: data['Co-task'],
        isDone: data['done'],
        color: data['color'])
      ..id = data['id'] ?? "null";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'duration': duration.inMinutes,
      'coTask': coTask,
      'done': isDone,
      'color': color
    };
  }
}
