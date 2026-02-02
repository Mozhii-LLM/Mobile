import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mozhi_frontend/constants/app_constants.dart';
import 'package:mozhi_frontend/screens/splash_screen.dart';
import 'package:mozhi_frontend/services/auth_service.dart';
import 'package:mozhi_frontend/services/language_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI style (status bar)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Start app immediately - don't wait for services
  runApp(const MozhiiApp());

  // Initialize services AFTER app starts (non-blocking)
  _initializeServices();
}

// Initialize services in background after app has started
Future<void> _initializeServices() async {
  try {
    print('Initializing AuthService in background...');
    await AuthService().init().timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        print('AuthService timeout');
      },
    );
    print('AuthService ready');
  } catch (e) {
    print('AuthService error: $e');
  }

  try {
    print('Initializing LanguageService in background...');
    await LanguageService().init().timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        print('LanguageService timeout');
      },
    );
    print('LanguageService ready');
  } catch (e) {
    print('LanguageService error: $e');
  }
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
      home: const SplashScreen(),
    );
  }
}