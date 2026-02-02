import 'package:flutter/material.dart';
import 'package:mozhi_frontend/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SplashScreen - The first screen users see when launching the app
///
/// Features:
/// - Radial gradient background (centered, dark blue theme)
/// - Logo (logo.png) and Text (text.png)
/// - Animated entrance
/// - "Get Started" button to proceed
/// - Remembers if user has seen splash (skips next time)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller for fade effects
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Fade in animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    // Scale animation for logo
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Navigate to home screen and remember user has seen splash
  void _navigateToHome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenSplash', true);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          // Radial gradient - centered at top-left, smooth fade from black to dark blue
          gradient: RadialGradient(
            center: Alignment(-0.9, -0.9), // Top-left corner
            radius: 2.0,
            colors: [
              Color.fromARGB(255, 0, 4, 8), // Pure black at top-left
              Color.fromARGB(255, 1, 8, 18),
              Color.fromARGB(255, 2, 12, 28),
              Color.fromARGB(255, 3, 18, 40), // Very dark blue-black
              Color.fromARGB(255, 5, 24, 55),
              Color.fromARGB(255, 8, 31, 73), // Dark blue
              Color.fromARGB(255, 11, 35, 85),
              Color.fromARGB(255, 14, 39, 98), // Medium dark blue
              Color.fromARGB(255, 13, 45, 118),
              Color.fromARGB(
                255,
                13,
                51,
                139,
              ), // Slightly lighter blue at edges
            ],
            stops: [0.0, 0.08, 0.15, 0.25, 0.35, 0.5, 0.65, 0.8, 0.9, 1.0],
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Section - centered
                  Expanded(
                    child: Center(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // M Logo PNG
                              Transform.translate(
                                offset: const Offset(0, 99),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  width: 230,
                                  height: 230,
                                  fit: BoxFit.contain,
                                ),
                              ),

                              // Text Logo PNG (Mozhii text) - moved closer to M logo
                              Transform.translate(
                                offset: const Offset(0, -60),
                                child: Image.asset(
                                  'assets/images/text.png',
                                  width: screenWidth * 0.9,
                                  height: 240,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Get Started Button
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      margin: const EdgeInsets.only(bottom: 48),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 1.5,
                        ),
                        // Subtle background glow
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.05),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _navigateToHome,
                          borderRadius: BorderRadius.circular(28),
                          splashColor: Colors.white.withOpacity(0.1),
                          highlightColor: Colors.white.withOpacity(0.05),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Get Started',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.95),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white.withOpacity(0.95),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
