import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmates/core/widgets/background.dart';
import 'package:taskmates/features/auth/data/user.dart';
import 'package:taskmates/features/auth/presentation/provider/userProvider.dart';
import 'package:taskmates/features/friends/presentation/pages/friendsPage.dart';
import 'package:taskmates/features/tasks/presentation/pages/Taskstats.dart';
import 'package:taskmates/features/tasks/presentation/pages/addtask.dart';
import 'package:taskmates/features/tasks/presentation/pages/taskPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> pages = [
    const TaskPage(),
    const FriendsPage(),
    const Taskstats(),
    const Addtask()
  ];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Stack(
            children: [
              background(context),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 110,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: const Icon(Icons.person)),
                                Consumer(
                                  builder: (context, ref, w) {
                                    UserModel? user = ref.watch(userIdProvider);

                                    return Text(user?.id ?? '...');
                                  },
                                )
                              ],
                            ),
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Good Morning",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Stack(
                      children: [
                        Container(
                            clipBehavior: Clip.hardEdge,
                            padding: const EdgeInsets.all(25),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(50),
                                bottom: Radius.circular(20),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: pages[index]),
                        if (index == 0)
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 151, 194, 152),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              width: 50,
                              height: 50,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      index = 3;
                                    });
                                  },
                                  icon: const Icon(Icons.add)),
                            ),
                          ),
                      ],
                    )),
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              style: ButtonStyle(
                                  backgroundColor: index == 0
                                      ? const WidgetStatePropertyAll(
                                          Color.fromARGB(255, 185, 255, 188))
                                      : null),
                              onPressed: () {
                                setState(() {
                                  if (index != 0) {
                                    index = 0;
                                  }
                                });
                              },
                              icon: const Icon(
                                Icons.home,
                                color: Colors.white,
                              )),
                          IconButton(
                              style: ButtonStyle(
                                  backgroundColor: index == 1
                                      ? const WidgetStatePropertyAll(
                                          Color.fromARGB(255, 185, 255, 188))
                                      : null),
                              onPressed: () {
                                setState(() {
                                  if (index != 1) {
                                    index = 1;
                                  }
                                });
                              },
                              icon: const Icon(
                                Icons.people,
                                color: Colors.white,
                              )),
                          IconButton(
                              style: ButtonStyle(
                                  backgroundColor: index == 2
                                      ? const WidgetStatePropertyAll(
                                          Color.fromARGB(255, 185, 255, 188))
                                      : null),
                              onPressed: () {
                                setState(() {
                                  if (index != 2) {
                                    index = 2;
                                  }
                                });
                              },
                              icon: const Icon(
                                CupertinoIcons.calendar,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
