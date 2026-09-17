import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class AIInsightCard extends StatelessWidget {
  final String moduleTitle;
  final String primaryValue;
  final String primaryLabel;
  final String statusText;
  final double confidencePercentage;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onTap;

  const AIInsightCard({
    super.key,
    required this.moduleTitle,
    required this.primaryValue,
    required this.primaryLabel,
    required this.statusText,
    required this.confidencePercentage,
    required this.icon,
    this.accentColor = AppColors.primaryAccent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.glassForestCard,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.4),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 14,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Badge Header (Overflow-proof)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(icon, color: accentColor, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          moduleTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: accentColor.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    '${confidencePercentage.toStringAsFixed(1)}% Conf.',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Main Value & Label
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                primaryValue,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              primaryLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 12),

            // Status Indicator Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.bolt, color: accentColor, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      statusText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
