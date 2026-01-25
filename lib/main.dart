import 'package:flutter/material.dart';
import 'package:mozhi_frontend/constants/app_constants.dart';

void main() {
  runApp(const MozhiiApp());
}

class MozhiiApp extends StatelessWidget {
  const MozhiiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mozhii',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppConstants.primaryDarkBlue,
        scaffoldBackgroundColor: AppConstants.primaryDarkBlue,
      ),
      home: const HomeScreen(),
    );
  }
}

// TODO: This is a temporary home screen placeholder
// Replace with actual HomeScreen once implemented
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryDarkBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppConstants.logoGradient.createShader(bounds),
              child: const Text(
                'M',
                style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Mozhii',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 36,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your AI Language Companion',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
