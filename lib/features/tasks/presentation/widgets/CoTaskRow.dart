import 'package:flutter/material.dart';

class CoTaskRow extends StatelessWidget {
  const CoTaskRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Co-Task'),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA6FF94),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {},
          child: const Text(
            "Change",
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
