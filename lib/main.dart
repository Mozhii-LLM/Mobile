import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mozhi_frontend/constants/app_constants.dart';
import 'package:mozhi_frontend/screens/splash_screen.dart';
import 'package:mozhi_frontend/services/auth_service.dart';
import 'package:mozhi_frontend/services/language_service.dart';

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
      // Always start with SplashScreen
      home: const SplashScreen(),
    );
  }
}
