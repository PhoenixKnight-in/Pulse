import 'package:flutter/material.dart';

class MotivationScreen extends StatefulWidget {
  const MotivationScreen({super.key});

  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  final List<String> _quotes = [
    "Push yourself, because no one else is going to do it for you.",
    "Success doesn’t just find you. You have to go out and get it.",
    "Great things never come from comfort zones.",
    "Dream it. Wish it. Do it.",
    "Stay focused, stay positive, stay strong.",
    "Don’t stop until you’re proud.",
    "Small progress is still progress.",
    "Doubt kills more dreams than failure ever will.",
    "Discipline is the bridge between goals and accomplishment.",
  ];

  int _index = 0;

  void _nextQuote() {
    setState(() {
      _index = (_index + 1) % _quotes.length;
    });
  }

  void _prevQuote() {
    setState(() {
      _index = (_index - 1 + _quotes.length) % _quotes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text("Motivation"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.format_quote, size: 80, color: Colors.white70),
              const SizedBox(height: 20),
              Text(
                _quotes[_index],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
                    onPressed: _prevQuote,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 32),
                    onPressed: _nextQuote,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
