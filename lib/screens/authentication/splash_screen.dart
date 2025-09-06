import 'package:flutter/material.dart';
import 'package:pulse_app/services/api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Add a small delay for splash effect
    await Future.delayed(const Duration(seconds: 2));

    try {
      final isLoggedIn = await ApiService.isLoggedIn();
      if (isLoggedIn) {
        // Verify token is still valid
        final result = await ApiService.getCurrentUser();
        if (result['success']) {
          // User is authenticated, go to home
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Token is invalid, go to login
          await ApiService.logout();
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        // User is not logged in, check if welcome screen should be shown
        // You can add additional logic here to determine first-time users
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    } catch (e) {
      // Error occurred, go to welcome/login screen
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your app logo
            Image(
              image: AssetImage('assets/logo.png'), // Add logo to assets
              width: 300,
            ),
            SizedBox(height: 30),
            // Optional loading indicator
            CircularProgressIndicator(
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}