import 'package:flutter/material.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  List<bool> _days = List.generate(21, (index) => false);

  // Example predefined challenges
  final List<String> _challenges = [
    "Day 1: Drink 8 glasses of water 💧",
    "Day 2: Meditate for 10 minutes 🧘",
    "Day 3: Walk 5,000 steps 🚶",
    "Day 4: Read 15 pages 📖",
    "Day 5: Write 3 things you’re grateful for ✍️",
    "Day 6: No junk food 🍎",
    "Day 7: 20 push-ups 💪",
    "Day 8: Sleep before 11pm 🛌",
    "Day 9: Limit social media to 30 mins 📱",
    "Day 10: Journal for 10 minutes 📓",
    "Day 11: Compliment someone 😊",
    "Day 12: Learn 5 new words 📚",
    "Day 13: Cook a healthy meal 🥗",
    "Day 14: Go for a 20-min walk 🌳",
    "Day 15: Try deep breathing for 5 mins 🌬️",
    "Day 16: Drink green tea 🍵",
    "Day 17: Do 30 squats 🏋️",
    "Day 18: Avoid sugar today 🚫🍭",
    "Day 19: Plan tomorrow’s schedule 🗓️",
    "Day 20: Write a positive affirmation 🌟",
    "Day 21: Reflect on your journey 🙌",
  ];

  void _showChallenge(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          "Challenge for Day ${index + 1}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          _challenges[index],
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _days[index] = !_days[index];
              });
              Navigator.pop(context);
            },
            child: Text(
              _days[index] ? "Unmark" : "Mark as Done",
              style: const TextStyle(color: Colors.lightBlue),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text("21-Day Challenge"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 21,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showChallenge(index),
            child: Container(
              decoration: BoxDecoration(
                color: _days[index] ? Colors.lightBlue : Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _days[index] ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
