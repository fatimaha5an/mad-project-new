import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/presentation/pages/home/pages/home.dart';
import 'package:spotify/presentation/auth/pages/onboarding_page.dart';
import 'package:spotify/presentation/auth/pages/auth_page.dart';

// --- ALDRICH COLOR PALETTE ---
class _AldrichColors {
  static const voidBlack = Color(0xFF001219);
  static const midnightGreen = Color(0xFF005F73);
  static const champagnePink = Color(0xFFE9D8A6);
  static const gamboge = Color(0xFFEE9B00);
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation (1.0 -> 1.2 -> 1.0) over 2 seconds
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
    
    // Check auth status after animation
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    final user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      // User is logged in -> HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RootPage()),
      );
    } else {
      // Check if first time
      final prefs = await SharedPreferences.getInstance();
      final isFirstTime = prefs.getBool('isFirstTime') ?? true;
      
      if (isFirstTime) {
        // First time -> Onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingPage()),
        );
      } else {
        // Returning user -> Auth
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthPage()),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AldrichColors.voidBlack,
      body: Center(
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _AldrichColors.champagnePink, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: _AldrichColors.gamboge.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.music_note,
                      size: 60,
                      color: _AldrichColors.champagnePink,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // App Name
                  const Text(
                    "QUAVO",
                    style: TextStyle(
                      color: _AldrichColors.champagnePink,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
