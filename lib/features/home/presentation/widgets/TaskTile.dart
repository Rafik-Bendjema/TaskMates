import 'package:flutter/material.dart';

Widget TaskTile(Color color, String title, String? coTask) {
  return Column(
    children: [
      SizedBox(
        height: 50,
        child: Row(
          children: [
            Container(
              width: 10,
              height: 50,
              color: color,
            ),
            Expanded(
                child: Container(
              height: 50,
              color: const Color.fromARGB(255, 235, 235, 235),
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(title),
                  ),
                  coTask == null
                      ? const SizedBox()
                      : Row(
                          children: [
                            const Icon(
                              Icons.people,
                              color: Colors.green,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              coTask,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        )
                ],
              ),
            )),
          ],
        ),
      ),
      const SizedBox(
        height: 5,
      )
    ],
  );
}
