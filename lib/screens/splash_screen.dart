import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/wheat_grass_reveal.dart';
import 'main_layout.dart';
import 'onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Auto-login mock user if no active session yet
      if (!authProvider.isAuthenticated) {
        authProvider.loginMockUser(
          email: 'farmer@smartfodder.com',
          name: 'Green Valley Farmer',
        );
      }
    } catch (_) {}

    if (!mounted) return;

    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final targetWidget = settingsProvider.isOnboardingCompleted
        ? const MainLayout()
        : const OnboardingScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => targetWidget,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background AI Farm Image with dark gradient overlay
          Positioned.fill(
            child: Image.asset(
              'assets/images/farm_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryDark.withValues(alpha: 0.82),
                    AppColors.primaryDark.withValues(alpha: 0.94),
                  ],
                ),
              ),
            ),
          ),

          // Animated Wheat & Grass Reveal Widget with Logo Pop
          WheatGrassReveal(
            logoWidget: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
            ),
            title: AppConstants.appName,
            subtitle: AppConstants.appSubtitle,
            onComplete: () {
              _navigateToNext();
            },
          ),
        ],
      ),
    );
  }
}
