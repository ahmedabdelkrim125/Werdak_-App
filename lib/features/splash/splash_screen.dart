// lib/features/splash/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ===== Logo / Splash Image =====
            // ضع صورة الـ splash في:
            //   assets/images/werdak_logo.png
            // ثم استبدل الـ Container بالكود ده:
            // Image.asset('assets/images/werdak_logo.png', width: 200, height: 200)
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryLight.withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                size: 72,
                color: Colors.white,
              ),
            ).animate().fadeIn(duration: 600.ms, curve: Curves.easeOut).scale(
                  begin: const Offset(0.6, 0.6),
                  end: const Offset(1.0, 1.0),
                  duration: 700.ms,
                  curve: Curves.elasticOut,
                ),

            const SizedBox(height: 32),

            // App Name
            const Text(
              'وردك',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 2,
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .slideY(begin: 0.3, end: 0, delay: 400.ms, duration: 600.ms),

            const SizedBox(height: 12),

            // Subtitle
            Text(
              'راجع القرآن يوماً بيوم',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.7),
              ),
            ).animate().fadeIn(delay: 700.ms, duration: 600.ms),

            const SizedBox(height: 60),

            // Loading indicator
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white.withOpacity(0.5),
              ),
            ).animate().fadeIn(delay: 1200.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
