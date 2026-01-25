import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mozhi_frontend/constants/app_constants.dart';
import 'package:mozhi_frontend/screens/splash_screen.dart';
import 'package:mozhi_frontend/screens/home_screen.dart';
import 'package:mozhi_frontend/services/auth_service.dart';
import 'package:mozhi_frontend/services/language_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services before app starts
  await AuthService().init();
  await LanguageService().init();

  // Set system UI style (status bar)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

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
      home: const AppInitializer(),
    );
  }
}

/// AppInitializer - Decides which screen to show first
///
/// - Shows SplashScreen if user hasn't seen it before
/// - Shows HomeScreen if user has already seen splash
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  /// Check if user has seen splash screen before
  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenSplash = prefs.getBool('hasSeenSplash') ?? false;

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              hasSeenSplash ? const HomeScreen() : const SplashScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while checking
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
