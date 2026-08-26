import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/entry_reveal.dart';
import '../main_layout.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          // Full-bleed Aerial Farm Field Image Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/aerial_farm_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // Gradient Overlay (Dark Forest Green gradient matching reference image)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryDark.withValues(alpha: 0.35),
                    AppColors.primaryDark.withValues(alpha: 0.85),
                    AppColors.primaryDark.withValues(alpha: 0.98),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),

          // Onboarding Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),

                  // Bold Headline Matching Reference UI
                  const EntryReveal(
                    duration: Duration(milliseconds: 500),
                    child: Text(
                      'YOUR FARM,\nSMARTER.',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.05,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Subtitle Description
                  EntryReveal(
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      'Automate cattle feeding, monitor hopper levels, and optimize farm productivity with real-time IoT insights.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withValues(alpha: 0.88),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Get Started Pill Action Button Matching Reference UI
                  EntryReveal(
                    duration: const Duration(milliseconds: 700),
                    child: GestureDetector(
                      onTap: () async {
                        await settingsProvider.setOnboardingCompleted(true);
                        if (context.mounted) {
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const MainLayout(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                              transitionDuration: const Duration(milliseconds: 400),
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccent,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryAccent.withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Arrow Icon Circle
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryDark,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                color: AppColors.primaryAccent,
                                size: 24,
                              ),
                            ),

                            // Button Text
                            const Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                                letterSpacing: 0.5,
                              ),
                            ),

                            // Right Subtle Arrow Indicator
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Text(
                                '>>>',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark.withValues(alpha: 0.5),
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
