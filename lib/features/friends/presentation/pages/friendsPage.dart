import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmates/features/auth/domain/firebase/userDb.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  String? res;
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Friends',
            style: TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 50,
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                    hintText: "search",
                    filled: true,
                    fillColor: Color.fromARGB(255, 235, 235, 235),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ),
            SizedBox(
              height: 50,
              child: Consumer(
                builder: (context, ref, _) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA6FF94),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Change this value to customize the shape
                      )),
                  onPressed: () async {
                    if (_controller.text.isNotEmpty) {
                      UserDb userDb = UserDbImpl();

                      res = await userDb.addFriend(_controller.text, ref);
                      if (res != null) {
                        setState(() {
                          res = res;
                        });
                      }
                    }
                  },
                  child: const Text("add"),
                ),
              ),
            ),

            //FriendsList()
          ],
        ),
        if (res != null)
          Text(
            res!,
            style: const TextStyle(color: Colors.red),
          )
      ],
    );
  }
}
