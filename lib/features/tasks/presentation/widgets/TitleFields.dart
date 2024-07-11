import 'package:flutter/material.dart';

class TitleField extends StatelessWidget {
  final TextEditingController controller;
  const TitleField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Title"),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
      ],
    );
  }
}
