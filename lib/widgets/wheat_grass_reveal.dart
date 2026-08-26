import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class WheatGrassReveal extends StatefulWidget {
  final Widget logoWidget;
  final String title;
  final String subtitle;
  final VoidCallback? onComplete;

  const WheatGrassReveal({
    super.key,
    required this.logoWidget,
    required this.title,
    required this.subtitle,
    this.onComplete,
  });

  @override
  State<WheatGrassReveal> createState() => _WheatGrassRevealState();
}

class _WheatGrassRevealState extends State<WheatGrassReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _grassGrowth;
  late Animation<double> _logoScale;
  late Animation<double> _textFade;
  late Animation<double> _wheatRotate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // 0.0 - 0.6: Grass & Wheat Grow upwards
    _grassGrowth = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
    );

    // 0.2 - 0.7: Wheat Stalk Wiggle/Rotate
    _wheatRotate = Tween<double>(begin: -0.15, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.75, curve: Curves.easeOutBack),
      ),
    );

    // 0.4 - 0.85: Logo pops in with scale & bounce
    _logoScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.85, curve: Curves.elasticOut),
    );

    // 0.6 - 1.0: Text Fades & Slides up
    _textFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
    );

    _controller.forward().then((_) {
      if (widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Custom Painted Animated Grass Blades at bottom
        AnimatedBuilder(
          animation: _grassGrowth,
          builder: (context, child) {
            return CustomPaint(
              size: Size.infinite,
              painter: GrassPainter(growthProgress: _grassGrowth.value),
            );
          },
        ),

        // Left Golden Wheat Ear
        Positioned(
          left: 16,
          bottom: 40,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, (1 - _grassGrowth.value) * 120),
                child: Transform.rotate(
                  angle: _wheatRotate.value,
                  child: Opacity(
                    opacity: _grassGrowth.value.clamp(0.0, 1.0),
                    child: const Icon(
                      Icons.grass,
                      size: 90,
                      color: Color(0xFFF59E0B), // Golden Amber Wheat
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Right Golden Wheat Ear
        Positioned(
          right: 16,
          bottom: 40,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, (1 - _grassGrowth.value) * 120),
                child: Transform.rotate(
                  angle: -_wheatRotate.value,
                  child: Opacity(
                    opacity: _grassGrowth.value.clamp(0.0, 1.0),
                    child: const Icon(
                      Icons.eco,
                      size: 85,
                      color: Color(0xFF22C55E), // Lush Green Leaf
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Center Content: Logo Pop & Title
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Scale Animation
              ScaleTransition(
                scale: _logoScale,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: widget.logoWidget,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title & Subtitle Reveal Animation
              AnimatedBuilder(
                animation: _textFade,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textFade.value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - _textFade.value) * 20),
                      child: Column(
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textLight,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.subtitle,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textLight.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom Painter for animated grass blades at the bottom
class GrassPainter extends CustomPainter {
  final double growthProgress;

  GrassPainter({required this.growthProgress});

  @override
  void paint(Canvas canvas, Size size) {
    if (growthProgress <= 0) return;

    final paintGreen = Paint()
      ..color = const Color(0xFF0F7B42).withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    final paintGolden = Paint()
      ..color = const Color(0xFFD97706).withValues(alpha: 0.75)
      ..style = PaintingStyle.fill;

    final paintLightGreen = Paint()
      ..color = const Color(0xFF22C55E).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final baseHeight = size.height;
    final maxBladeHeight = 90.0 * growthProgress;

    // Draw multiple stylized grass blades along the bottom width
    for (int i = 0; i < 15; i++) {
      final x = (size.width / 14) * i;
      final bladeHeight = maxBladeHeight * (0.6 + 0.4 * math.sin(i * 1.5));
      final curveOffset = (i % 2 == 0 ? 15.0 : -15.0) * growthProgress;

      final path = Path()
        ..moveTo(x - 8, baseHeight)
        ..quadraticBezierTo(
          x,
          baseHeight - bladeHeight * 0.5,
          x + curveOffset,
          baseHeight - bladeHeight,
        )
        ..quadraticBezierTo(
          x + 4,
          baseHeight - bladeHeight * 0.5,
          x + 8,
          baseHeight,
        )
        ..close();

      Paint activePaint = paintGreen;
      if (i % 3 == 0) activePaint = paintGolden;
      if (i % 4 == 0) activePaint = paintLightGreen;

      canvas.drawPath(path, activePaint);
    }
  }

  @override
  bool shouldRepaint(covariant GrassPainter oldDelegate) {
    return oldDelegate.growthProgress != growthProgress;
  }
}
