import 'dart:async';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PersonalDashboardScreen extends StatefulWidget {
  const PersonalDashboardScreen({Key? key}) : super(key: key);

  @override
  _PersonalDashboardScreenState createState() =>
      _PersonalDashboardScreenState();
}

class _PersonalDashboardScreenState extends State<PersonalDashboardScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  /// ✅ Per-day Tasks & Notes
  final Map<DateTime, List<Map<String, dynamic>>> _tasksByDate = {};
  final Map<DateTime, List<String>> _notesByDate = {};

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  /// ✅ Pomodoro Timer
  static const int workMinutes = 25;
  int _seconds = workMinutes * 60;
  Timer? _timer;
  bool _running = false;

  void _startPausePomodoro() {
    if (_running) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_seconds > 0) {
          setState(() => _seconds--);
        } else {
          timer.cancel();
          setState(() => _running = false);
        }
      });
    }
    setState(() => _running = !_running);
  }

  void _resetPomodoro() {
    _timer?.cancel();
    setState(() {
      _seconds = workMinutes * 60;
      _running = false;
    });
  }

  String get _timeString {
    final m = (_seconds ~/ 60).toString().padLeft(2, "0");
    final s = (_seconds % 60).toString().padLeft(2, "0");
    return "$m:$s";
  }

  /// ✅ Helpers to get current date’s tasks/notes
  List<Map<String, dynamic>> get _currentTasks =>
      _tasksByDate[_selectedDay ?? DateTime.now()] ?? [];
  List<String> get _currentNotes =>
      _notesByDate[_selectedDay ?? DateTime.now()] ?? [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        title: const Text("My Dashboard",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 600;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildPlannerCard(),
                const SizedBox(height: 16),
                isSmallScreen
                    ? Column(
                  children: [
                    _buildTodoCard(),
                    const SizedBox(height: 16),
                    _buildNotesCard(),
                  ],
                )
                    : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildTodoCard()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildNotesCard()),
                  ],
                ),
                const SizedBox(height: 16),
                _buildPomodoroCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ✅ Planner Card
  Widget _buildPlannerCard() {
    return _buildCard(
      title: "Planner",
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        calendarStyle: const CalendarStyle(
          todayDecoration:
          BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
          selectedDecoration:
          BoxDecoration(color: Colors.lightBlue, shape: BoxShape.circle),
          defaultTextStyle: TextStyle(color: Colors.white),
          weekendTextStyle: TextStyle(color: Colors.white),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(color: Colors.white),
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.white70),
          weekendStyle: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  /// ✅ To-Do Card (per date)
  Widget _buildTodoCard() {
    return _buildCard(
      title: "To-Do",
      child: Column(
        children: [
          ..._currentTasks.map((t) => ListTile(
            dense: true,
            leading: Icon(
              t["done"] ? Icons.check_circle : Icons.circle_outlined,
              color: t["done"] ? Colors.green : Colors.blue,
            ),
            title: Text(
              t["task"],
              style: TextStyle(
                color: Colors.white,
                decoration:
                t["done"] ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  _tasksByDate[_selectedDay ?? DateTime.now()]!
                      .remove(t);
                });
              },
            ),
            onTap: () {
              setState(() {
                t["done"] = !t["done"];
              });
            },
          )),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _taskController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Add task",
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.blue),
                onPressed: () {
                  if (_taskController.text.isNotEmpty) {
                    final key = _selectedDay ?? DateTime.now();
                    setState(() {
                      _tasksByDate[key] = (_tasksByDate[key] ?? [])
                        ..add({"task": _taskController.text, "done": false});
                      _taskController.clear();
                    });
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }

  /// ✅ Notes Card (per date)
  Widget _buildNotesCard() {
    return _buildCard(
      title: "Notes",
      child: Column(
        children: [
          ..._currentNotes.map((note) => Card(
            color: Colors.blue.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(note,
                  style: const TextStyle(color: Colors.black, fontSize: 14)),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _notesByDate[_selectedDay ?? DateTime.now()]!
                        .remove(note);
                  });
                },
              ),
            ),
          )),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _noteController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Add note",
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.blue),
                onPressed: () {
                  if (_noteController.text.isNotEmpty) {
                    final key = _selectedDay ?? DateTime.now();
                    setState(() {
                      _notesByDate[key] = (_notesByDate[key] ?? [])
                        ..add(_noteController.text);
                      _noteController.clear();
                    });
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }

  /// ✅ Pomodoro Timer Card
  Widget _buildPomodoroCard() {
    return _buildCard(
      title: "Pomodoro",
      child: Column(
        children: [
          Text(_timeString,
              style: const TextStyle(color: Colors.white, fontSize: 36)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _startPausePomodoro,
                child: Text(_running ? "Pause" : "Start",
                    style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.lightBlue),
                ),
                onPressed: _resetPomodoro,
                child: const Text("Reset"),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// ✅ Reusable Card Widget
  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(2, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
