import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:taskmates/features/home/presentation/pages/home.dart';
import 'package:taskmates/features/tasks/data/task.dart';
import 'package:taskmates/features/tasks/domain/taskDb.dart';

class Addtask extends StatefulWidget {
  const Addtask({super.key});

  @override
  State<Addtask> createState() => _AddtaskState();
}

class _AddtaskState extends State<Addtask> {
  bool dateError = false;
  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (date == null) {
        setState(() {
          dateError = true;
        });
      } else {
        Taskdb taskdb = TaskDb_impl();
        Task t = Task(
            title: _titleController.text,
            date: date!,
            duration: duration,
            isDone: false,
            color: color.value);
        Task? res = await taskdb.createTask(t);
        if (res != null) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Error adding a task"),
                    content:
                        const Text("error happen when trying to add a task "),
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

  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  String coTask = "";
  DateTime? date;
  Duration? duration;
  Color color = Colors.blue;
  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                )),
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Title"),
            ),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Co-Task'),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA6FF94),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Change this value to customize the shape
                        )),
                    onPressed: () {},
                    child: const Text(
                      "change",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Date'),
                date == null
                    ? const SizedBox()
                    : Builder(builder: (context) {
                        DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

                        // Format the DateTime
                        String formatted = formatter.format(date!);
                        return Text(
                          formatted.toString(),
                          style: const TextStyle(fontSize: 10),
                        );
                      }),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA6FF94),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Change this value to customize the shape
                        )),
                    onPressed: () async {
                      DateTime? temp;
                      temp = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)));
                      if (temp != null) {
                        var time = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        if (time != null) {
                          print("this is time $time");
                          setState(() {
                            date = temp!.add(Duration(
                                hours: time.hour, minutes: time.minute));
                          });
                        }
                      }

                      print("this is the date $date");
                    },
                    child: const Text(
                      "choose",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ))
              ],
            ),
            if (dateError)
              const Text(
                'you need to choose a date',
                style: TextStyle(color: Colors.red),
              ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Duration'),
                duration == null
                    ? const SizedBox()
                    : Text(
                        "${duration!.inMinutes} minutes",
                        style: const TextStyle(fontSize: 10),
                      ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA6FF94),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Change this value to customize the shape
                        )),
                    onPressed: () async {
                      var temp = await showDurationPicker(
                          context: context,
                          initialTime: duration ?? const Duration(seconds: 20));
                      if (temp != null) {
                        setState(() {
                          duration = temp;
                        });
                      }
                    },
                    child: const Text(
                      "change",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Color'),
                Icon(
                  Icons.square,
                  color: color,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA6FF94),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Change this value to customize the shape
                        )),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text("Pick a color"),
                                content: SingleChildScrollView(
                                  child: BlockPicker(
                                      pickerColor: color,
                                      onColorChanged: (v) {
                                        setState(() {
                                          color = v;
                                        });
                                      }),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Done'))
                                ],
                              ));
                    },
                    child: const Text(
                      "change",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text("Note"),
            ),
            TextFormField(
              controller: _noteController,
              maxLines: 4,
              minLines: 4,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
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
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                )),
          ],
        ),
      ),
    );
  }
}
