import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  const BottomNavigationWidget({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            style: ButtonStyle(
              backgroundColor: currentIndex == 0
                  ? const WidgetStatePropertyAll(
                      Color.fromARGB(255, 185, 255, 188))
                  : null,
            ),
            onPressed: () => onIndexChanged(0),
            icon: const Icon(Icons.home, color: Colors.white),
          ),
          IconButton(
            style: ButtonStyle(
              backgroundColor: currentIndex == 1
                  ? const WidgetStatePropertyAll(
                      Color.fromARGB(255, 185, 255, 188))
                  : null,
            ),
            onPressed: () => onIndexChanged(1),
            icon: const Icon(Icons.people, color: Colors.white),
          ),
          IconButton(
            style: ButtonStyle(
              backgroundColor: currentIndex == 2
                  ? const WidgetStatePropertyAll(
                      Color.fromARGB(255, 185, 255, 188))
                  : null,
            ),
            onPressed: () => onIndexChanged(2),
            icon: const Icon(CupertinoIcons.calendar, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
