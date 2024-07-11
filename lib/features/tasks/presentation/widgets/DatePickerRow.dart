import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerRow extends StatelessWidget {
  final DateTime? date;
  final ValueChanged<DateTime> onDatePicked;

  const DatePickerRow({
    super.key,
    required this.date,
    required this.onDatePicked,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Date'),
        date == null
            ? const SizedBox()
            : Text(
                DateFormat('yyyy-MM-dd HH:mm').format(date!),
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
            DateTime? temp;
            temp = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (temp != null) {
              var time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) {
                onDatePicked(
                  temp.add(Duration(hours: time.hour, minutes: time.minute)),
                );
              }
            }
          },
          child: const Text(
            "Choose",
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
