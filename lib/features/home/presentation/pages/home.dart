import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmates/core/widgets/background.dart';
import 'package:taskmates/features/auth/data/user.dart';
import 'package:taskmates/features/auth/presentation/provider/userProvider.dart';
import 'package:taskmates/features/home/presentation/widgets/TaskDone.dart';
import 'package:taskmates/features/tasks/data/presentation/widgets/taskView.dart';
import 'package:taskmates/features/tasks/data/task.dart';
import 'package:taskmates/features/tasks/domain/taskDb.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    UserModel? user = ref.watch(userIdProvider);
    print("reloaded iwht the uid ${user?.id}");

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
                                Text(user?.id ?? '...'),
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
                        child: tasks.when(
                      data: (data) {
                        print("here is data ${data.length}");
                        List<Task> doneTasks = [];
                        List<Task> waitingTasks = [];
                        for (Task task in data) {
                          if (task.isDone) {
                            doneTasks.add(task);
                          } else {
                            waitingTasks.add(task);
                          }
                        }
                        return Stack(
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
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Today"),
                                      Text("${doneTasks.length}/${data.length}")
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Stack(
                                    children: [
                                      const Divider(
                                        thickness: 3,
                                      ),
                                      Divider(
                                        color: Colors.green,
                                        endIndent:
                                            (MediaQuery.of(context).size.width -
                                                    50 * doneTasks.length) /
                                                data.length,
                                        thickness: 3,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: ListView(
                                      scrollDirection: Axis.vertical,
                                      children: [
                                        TaskDone(
                                          tasks: doneTasks,
                                        ),
                                        Taskview(tasks: waitingTasks)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 50,
                              right: 20,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 151, 194, 152),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                width: 50,
                                height: 50,
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.add)),
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) =>
                          Center(child: Text('Error: $error')),
                    )),
                    Container(
                      height: 50,
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
