import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerWidget extends StatelessWidget {
  final Color color;
  final Function(Color) onColorChanged;

  const ColorPickerWidget({
    required this.color,
    required this.onColorChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
                borderRadius: BorderRadius.circular(10),
              )),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text("Pick a color"),
                      content: SingleChildScrollView(
                        child: BlockPicker(
                          pickerColor: color,
                          onColorChanged: onColorChanged,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Done'),
                        )
                      ],
                    ));
          },
          child: const Text(
            "change",
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
