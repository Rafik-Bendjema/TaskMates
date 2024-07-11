import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/provider/userProvider.dart';
import '../../../tasks/data/task.dart';
// Import your provider

class FriendsList extends ConsumerWidget {
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsyncValue = ref.watch(friendsProvider);

    return friendsAsyncValue.when(
      data: (friends) {
        if (friends.isEmpty) {
          return const Center(child: Text("You are pretty lonely"));
        }
        return SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];
              List<Task> tasks = friends[index].tasks;
              List<Task> doneTasks = [];
              List<Task> todaysTasks = [];

              List<Task> waitingTasks = [];
              for (Task task in tasks) {
                if (task.date.day == DateTime.now().day &&
                    task.date.year == DateTime.now().year &&
                    task.date.month == DateTime.now().month) {
                  todaysTasks.add(task);
                  if (task.isDone) {
                    doneTasks.add(task);
                  } else {
                    waitingTasks.add(task);
                  }
                }
              }
              return Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 227, 227, 227),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: const EdgeInsets.all(8),
                width: 100,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(friend.friendId),
                    Text("${doneTasks.length}/${todaysTasks.length}"),
                  ],
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          const Center(child: Text("Error while fetching friends")),
    );
  }
}
