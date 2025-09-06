import 'package:flutter/material.dart';
import 'package:pulse_app/screens/motivation_page.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/personal_dashboard_screen.dart';

// ✅ Import new feature screens
import 'screens/calendar_screen.dart';
import 'screens/todo_list_screen.dart';
import 'screens/habit_tracker_screen.dart';
import 'screens/pomodoro_screen.dart';
import 'screens/challenges_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pulse App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),

      // Start with splash screen
      initialRoute: '/splash',

      routes: {
        '/splash': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/planner': (context) => const PersonalDashboardScreen(),
        '/tools': (context) => const PersonalDashboardScreen(),
        '/motivation': (context) => const MotivationScreen(),

        // ✅ New routes
        '/calendar': (context) => const CalendarScreen(),
        '/todo': (context) => const TodoListScreen(),
        '/habits': (context) => const HabitTrackerScreen(),
        '/pomodoro': (context) => const PomodoroScreen(),
        '/challenges': (context) => const ChallengesScreen(),
      },
    );
  }
}
