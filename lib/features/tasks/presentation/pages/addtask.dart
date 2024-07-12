import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:taskmates/features/home/presentation/pages/home.dart';
import 'package:taskmates/features/tasks/data/task.dart';
import 'package:taskmates/features/tasks/domain/taskDb.dart';
import 'package:taskmates/features/tasks/presentation/widgets/CoTaskRow.dart';
import 'package:taskmates/features/tasks/presentation/widgets/DatePickerRow.dart';
import 'package:taskmates/features/tasks/presentation/widgets/DurationPickerRow.dart';
import 'package:taskmates/features/tasks/presentation/widgets/TitleFields.dart';

import '../widgets/NoteField.dart';
import '../widgets/colorPicker.dart';

class Addtask extends StatefulWidget {
  bool isEditing;
  Task? task;

  Addtask({super.key, required this.isEditing, this.task});

  @override
  State<Addtask> createState() => _AddtaskState();
}

class _AddtaskState extends State<Addtask> {
  bool dateError = false;
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  String? coTask;
  String? coTask_id;
  DateTime? date;
  Duration? duration;
  Color color = Colors.blue;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.task != null) {
      _titleController.text = widget.task!.title;
      _noteController.text = widget.task!.notes;
      date = widget.task!.date;
      duration = widget.task!.duration;
      color = Color(widget.task!.color);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (date == null) {
        setState(() {
          dateError = true;
        });
      } else {
        Taskdb taskdb = TaskDb_impl();
        Task t = Task(
            id: widget.task?.id,
            title: _titleController.text,
            date: date!,
            duration: duration,
            isDone: false,
            color: color.value,
            creationDate: DateTime.now(),
            notes: _noteController.text,
            coTask: coTask,
            coTask_id: coTask_id);

        Task? res;
        if (widget.isEditing && widget.task != null) {
          print('i will edit this id ${t.id}');
          res = await taskdb.editTask(t);
        } else {
          res = await taskdb.createTask(t);
        }

        if (res != null) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Error adding a task"),
                    content:
                        const Text("Error occurred while trying to add a task"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Back'))
                    ],
                  ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      scrollDirection: Axis.vertical,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Add a Task",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            TitleField(controller: _titleController),
            const SizedBox(height: 20),
            CoTaskRow(
              onChoosed: (uid, id) {
                setState(() {
                  coTask = uid;
                  coTask_id = id;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            DatePickerRow(
              date: date,
              onDatePicked: (selectedDate) =>
                  setState(() => date = selectedDate),
            ),
            const SizedBox(height: 10),
            DurationPickerRow(
              duration: duration,
              onDurationPicked: (selectedDuration) =>
                  setState(() => duration = selectedDuration),
            ),
            const SizedBox(height: 10),
            ColorPickerWidget(
              color: color,
              onColorChanged: (selectedColor) =>
                  setState(() => color = selectedColor),
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text("Note"),
            ),
            NoteInputField(controller: _noteController),
            const SizedBox(height: 10),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA6FF94),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // Change this value to customize the shape
                    )),
                onPressed: () {
                  _submit();
                },
                child: Text(
                  widget.isEditing ? "edit" : "Submit",
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                )),
          ],
        ),
      ),
    );
  }
}
