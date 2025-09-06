import 'package:flutter/material.dart';

class HabitTrackerScreen extends StatefulWidget {
  const HabitTrackerScreen({super.key});

  @override
  State<HabitTrackerScreen> createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  final List<Map<String, dynamic>> _habits = [
    {"name": "Drink Water", "time": "08:00 AM", "done": false},
    {"name": "Read 20 mins", "time": "09:00 PM", "done": false},
  ];

  final TextEditingController _habitController = TextEditingController();
  TimeOfDay? _selectedTime;

  void _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period";
  }

  void _addHabit() {
    if (_habitController.text.isNotEmpty && _selectedTime != null) {
      setState(() {
        _habits.add({
          "name": _habitController.text,
          "time": _formatTime(_selectedTime!),
          "done": false
        });
        _habitController.clear();
        _selectedTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text("Habit Tracker"),
      ),
      body: Column(
        children: [
          // ✅ Habits List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _habits.length,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _habits[index]["name"],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _habits[index]["time"],
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Checkbox(
                      value: _habits[index]["done"],
                      activeColor: Colors.lightBlue,
                      onChanged: (val) {
                        setState(() {
                          _habits[index]["done"] = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ✅ Add Habit Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _habitController,
                  decoration: InputDecoration(
                    hintText: "New habit",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.lightBlue),
                        ),
                        onPressed: _pickTime,
                        icon: const Icon(Icons.access_time),
                        label: Text(
                          _selectedTime == null
                              ? "Pick Time"
                              : _formatTime(_selectedTime!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _addHabit,
                      child: const Text("Add", style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
