import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskmates/core/notification/notification.dart';
import 'package:taskmates/features/tasks/data/task.dart';
import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';

class TimerScreen extends StatefulWidget {
  final Task task;
  const TimerScreen({super.key, required this.task});

  @override
  State<TimerScreen> createState() => _TimerState();
}

class _TimerState extends State<TimerScreen> with WidgetsBindingObserver {
  final CountDownController countDownController = CountDownController();
  bool isRunning = true; // State to track whether the countdown is running
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize the local notifications plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void handleTimeout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Time Done"),
              content: const Text("You done the task?"),
              actions: [
                TextButton(onPressed: () {}, child: const Text("Yes")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      countDownController.restart(
                          initialPosition: 0); // Restart the timer
                      setState(() {
                        isRunning = true;
                      });
                    },
                    child: const Text("No, Repeat"))
              ],
            ));
  }

  void togglePauseResume() {
    if (isRunning) {
      countDownController.pause();
    } else {
      countDownController.resume();
    }
    setState(() {
      isRunning = !isRunning;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // The app is going into the background
      countDownController.pause();
      setState(() {
        isRunning = false;
      });
      await NotificationService.showInstanceNotification(
          "timer alert", "timer is paused");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
                child: Text(
              widget.task.title,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 200,
              width: 200,
              child: CountDownProgressIndicator(
                controller: countDownController,
                timeFormatter: (seconds) {
                  return Duration(seconds: seconds * 60)
                      .toString()
                      .split('.')[0]
                      .padLeft(8, '0');
                },
                duration: widget.task.duration!.inSeconds,
                backgroundColor: Colors.white,
                valueColor: Colors.black,
                onComplete: handleTimeout,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: togglePauseResume,
                  child: Text(isRunning ? "Pause" : "Resume"),
                ),
                ElevatedButton(
                  onPressed: () {
                    countDownController.restart(
                        initialPosition: 0); // Restart the timer
                    setState(() {
                      isRunning = true;
                    });
                  },
                  child: const Text("Restart"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle the done action
                  },
                  child: const Text("Done"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
