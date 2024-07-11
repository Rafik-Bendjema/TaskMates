import 'package:flutter/material.dart';
import 'package:taskmates/core/widgets/background.dart';
import 'package:taskmates/features/friends/presentation/pages/friendsPage.dart';
import 'package:taskmates/features/home/presentation/widgets/bottomNav.dart';
import 'package:taskmates/features/home/presentation/widgets/headerWidget.dart';
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
    Addtask(
      isEditing: false,
    ),
  ];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    const HeaderWidget(),
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
                            child: pages[index],
                          ),
                          if (index == 0)
                            Positioned(
                              bottom: 20,
                              right: 20,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 151, 194, 152),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                width: 50,
                                height: 50,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      index = 3;
                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    BottomNavigationWidget(
                      currentIndex: index,
                      onIndexChanged: (newIndex) {
                        setState(() {
                          index = newIndex;
                        });
                      },
                    ),
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
