import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskmates/features/auth/presentation/provider/userProvider.dart';
import 'package:taskmates/features/tasks/data/task.dart';
import 'package:taskmates/features/tasks/presentation/pages/taskPage.dart';
import 'package:taskmates/features/tasks/presentation/widgets/TaskDone.dart';
import 'package:taskmates/features/tasks/presentation/widgets/taskView.dart';

class Taskstats extends ConsumerStatefulWidget {
  const Taskstats({super.key});

  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends ConsumerState<Taskstats> {
  late final ValueNotifier<List<Task>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
    _loadEventsForDay(_selectedDay!);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<void> _loadEventsForDay(DateTime day) async {
    final tasksAsync = ref.read(tasksProvider);
    tasksAsync.whenData((tasks) {
      final events = tasks.where((task) => isSameDay(task.date, day)).toList();
      _selectedEvents.value = events;
    });
  }

  Future<void> _loadEventsForRange(DateTime start, DateTime end) async {
    final tasksAsync = ref.read(tasksProvider);
    tasksAsync.whenData((tasks) {
      final days = daysInRange(start, end);
      final events = [
        for (final d in days) ...tasks.where((task) => isSameDay(task.date, d)),
      ];
      _selectedEvents.value = events;
    });
  }

  List<DateTime> daysInRange(DateTime start, DateTime end) {
    final days = <DateTime>[];
    for (int i = 0; i <= end.difference(start).inDays; i++) {
      days.add(DateTime(start.year, start.month, start.day + i));
    }
    return days;
  }

  List<Task> _getEventsForDay(DateTime day) {
    final tasksAsync = ref.read(tasksProvider);
    List<Task> events = [];
    tasksAsync.whenData((tasks) {
      events = tasks.where((task) => isSameDay(task.date, day)).toList();
    });
    return events;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _loadEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _loadEventsForRange(start, end);
    } else if (start != null) {
      _loadEventsForDay(start);
    } else if (end != null) {
      _loadEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TableCalendar<Task>(
            availableCalendarFormats: const {
              CalendarFormat.month: 'two weeks',
              CalendarFormat.week: 'month',
              CalendarFormat.twoWeeks: 'week',
            },
            firstDay: DateTime.utc(2015, 1, 1),
            lastDay: DateTime.utc(2030, 1, 1),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.zero, // No border radius
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.zero, // No border radius
              ),
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.zero, // No border radius
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.zero, // No border radius
              ),
              rangeStartDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.zero, // No border radius
              ),
              rangeEndDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.zero, // No border radius
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      color: Colors.green,
                      child: Text(
                        '${events.length}',
                        style: const TextStyle().copyWith(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          ValueListenableBuilder<List<Task>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              List<Task> taskdone =
                  value.where((element) => element.isDone == true).toList();
              List<Task> taskNotDone =
                  value.where((element) => element.isDone == false).toList();
              print(taskdone.length);
              return Consumer(builder: (context, ref, _) {
                final nah = ref.watch(tasksProvider);
                print(nah);
                return Column(
                  children: [
                    TaskDone(
                      tasks: taskdone,
                      ignore: true,
                    ),
                    TaskView(
                      tasks: taskNotDone,
                      ignore: true,
                    ),
                  ],
                );
              });
            },
          ),
          const SizedBox(height: 16.0), // Add spacing at the bottom
        ],
      ),
    );
  }
}
