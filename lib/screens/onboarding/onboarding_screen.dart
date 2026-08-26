import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/entry_reveal.dart';
import '../main_layout.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
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

                  // Interactive Slide-to-Start Action Button
                  const EntryReveal(
                    duration: Duration(milliseconds: 700),
                    child: _SlideToStartButton(),
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

class _SlideToStartButton extends StatefulWidget {
  const _SlideToStartButton();

  @override
  State<_SlideToStartButton> createState() => _SlideToStartButtonState();
}

class _SlideToStartButtonState extends State<_SlideToStartButton> {
  double _dragPosition = 0.0;
  bool _isCompleted = false;

  void _triggerCompletion() async {
    if (_isCompleted) return;
    setState(() => _isCompleted = true);

    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    await settingsProvider.setOnboardingCompleted(true);

    if (mounted) {
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
  }

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 64.0;
    const double knobSize = 52.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxDrag = constraints.maxWidth - knobSize - 12.0;

        return GestureDetector(
          onTap: () {
            // Tap to complete
            setState(() => _dragPosition = maxDrag);
            _triggerCompletion();
          },
          onHorizontalDragUpdate: (details) {
            if (_isCompleted) return;
            setState(() {
              _dragPosition += details.delta.dx;
              if (_dragPosition < 0) _dragPosition = 0;
              if (_dragPosition > maxDrag) _dragPosition = maxDrag;
            });
          },
          onHorizontalDragEnd: (details) {
            if (_isCompleted) return;
            if (_dragPosition > maxDrag * 0.6) {
              setState(() => _dragPosition = maxDrag);
              _triggerCompletion();
            } else {
              // Reset drag knob to 0
              setState(() => _dragPosition = 0.0);
            }
          },
          child: Container(
            height: buttonHeight,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryAccent,
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryAccent.withValues(alpha: 0.4),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Center Label Text with Opacity Fade as Knob Approaches Right
                Opacity(
                  opacity: (1.0 - (_dragPosition / maxDrag)).clamp(0.0, 1.0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 40),
                      Text(
                        'Slide to Get Started',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        '>>>',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Draggable Arrow Circle Knob
                AnimatedPositioned(
                  duration: _dragPosition == 0.0 || _dragPosition == maxDrag
                      ? const Duration(milliseconds: 250)
                      : Duration.zero,
                  curve: Curves.easeOut,
                  left: 6 + _dragPosition,
                  child: Container(
                    width: knobSize,
                    height: knobSize,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryDark,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.primaryAccent,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
