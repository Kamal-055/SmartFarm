import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final bool isOnline;
  final String? customText;
  final VoidCallback? onTap;

  const StatusBadge({
    super.key,
    required this.isOnline,
    this.customText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isOnline ? AppColors.successBackground : AppColors.errorBackground;
    final dotColor = isOnline ? AppColors.onlineGreen : AppColors.offlineRed;
    final textColor = isOnline ? AppColors.success : AppColors.error;
    final label = customText ?? (isOnline ? "Online" : "Offline");

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: textColor.withValues(alpha: 0.3), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: dotColor.withValues(alpha: 0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  )
                ],
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
