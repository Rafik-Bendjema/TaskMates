import 'package:flutter/material.dart';

class NoteInputField extends StatelessWidget {
  final TextEditingController controller;

  const NoteInputField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 4,
      minLines: 4,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }
}
