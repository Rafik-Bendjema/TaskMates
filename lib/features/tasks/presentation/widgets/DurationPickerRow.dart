import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';

class DurationPickerRow extends StatelessWidget {
  final Duration? duration;
  final ValueChanged<Duration> onDurationPicked;

  const DurationPickerRow({
    super.key,
    required this.duration,
    required this.onDurationPicked,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            var temp = await showDurationPicker(
              context: context,
              initialTime: duration ?? const Duration(seconds: 20),
            );
            if (temp != null) {
              onDurationPicked(temp);
            }
          },
          child: const Text(
            "Change",
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
