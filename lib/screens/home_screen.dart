import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/api_service.dart';
import 'notification_screen.dart';
import 'motivation_page.dart';
import 'habit_tracker_screen.dart';
import 'pomodoro_screen.dart';
import 'challenges_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _user;
  bool _isLoading = true;
  
  // Calendar and task management variables
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<String>> _tasksByDate = {};
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final result = await ApiService.getCurrentUser();
    if (result['success']) {
      setState(() {
        _user = result['data'];
        _isLoading = false;
      });
    } else {
      // Token might be expired, redirect to login
      await ApiService.logout();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ApiService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  /// Helper to normalize DateTime (strip hours/mins/seconds)
  DateTime _getDateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// Current selected day's tasks
  List<String> get _currentTasks =>
      _tasksByDate[_getDateOnly(_selectedDay ?? DateTime.now())] ?? [];

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // ✅ Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_focusedDay.day}-${_focusedDay.month}-${_focusedDay.year}",
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),
                        Text(
                          TimeOfDay.now().format(context),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications,
                          color: Colors.blue, size: 28),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NotificationsPage()),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout, color: Colors.blue, size: 28),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Welcome message for authenticated user
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Welcome, ${_user?['username'] ?? 'User'}!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_user?['email'] != null)
                    Text(
                      _user!['email'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Dashboard + Motivation Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCard(
                  title: "My Dashboard",
                  icon: Icons.dashboard,
                  onTap: () {
                    Navigator.pushNamed(context, '/planner');
                  },
                ),
                _buildInfoCard(
                  title: "Motivation",
                  icon: Icons.format_quote_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MotivationScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ✅ New Row: Habit Tracker + Pomodoro
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCard(
                  title: "Habits",
                  icon: Icons.track_changes,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HabitTrackerScreen()),
                    );
                  },
                ),
                _buildInfoCard(
                  title: "Pomodoro",
                  icon: Icons.timer,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PomodoroScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ✅ Challenges Card (full width)
            _buildInfoCard(
              title: "Challenges",
              icon: Icons.emoji_events,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChallengesScreen()),
                );
              },
              fullWidth: true,
            ),
            const SizedBox(height: 20),

            // ✅ Calendar Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) =>
                    isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                eventLoader: (day) =>
                _tasksByDate[_getDateOnly(day)] ?? [],
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                      color: Colors.blue, shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(
                      color: Colors.blueAccent, shape: BoxShape.circle),
                ),
                headerStyle: const HeaderStyle(
                    formatButtonVisible: false, titleCentered: true),
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Task List Section (per day)
            Column(
              children: _currentTasks.map((task) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(task,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      IconButton(
                        icon: const Icon(Icons.check_circle, color: Colors.blue),
                        onPressed: () {
                          setState(() {
                            _tasksByDate[_getDateOnly(
                                _selectedDay ?? DateTime.now())]!
                                .remove(task);
                          });
                        },
                      )
                    ],
                  ),
                );
              }).toList(),
            ),

            // ✅ Add Task Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: "Add new task",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (_taskController.text.isNotEmpty) {
                      final key = _getDateOnly(_selectedDay ?? DateTime.now());
                      setState(() {
                        _tasksByDate[key] = (_tasksByDate[key] ?? [])
                          ..add(_taskController.text);
                        _taskController.clear();
                      });
                    }
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 80,
        width: fullWidth ? double.infinity : 150,
        margin: fullWidth ? const EdgeInsets.only(bottom: 10) : null,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.blueAccent),
            const SizedBox(height: 8),
            Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}