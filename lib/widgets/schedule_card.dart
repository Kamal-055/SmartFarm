import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/feeding_schedule.dart';

class ScheduleCard extends StatelessWidget {
  final FeedingSchedule schedule;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onDelete;

  const ScheduleCard({
    super.key,
    required this.schedule,
    this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: schedule.enabled ? AppColors.border : AppColors.divider,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: schedule.enabled ? AppColors.primaryLight : AppColors.surfaceWarm,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.access_time_filled,
                color: schedule.enabled ? AppColors.primary : AppColors.textMuted,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.time,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: schedule.enabled ? AppColors.textPrimary : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: schedule.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: schedule.enabled ? AppColors.textSecondary : AppColors.textMuted,
                          ),
                        ),
                        TextSpan(
                          text: ' (${schedule.durationSeconds}s open)',
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            if (onDelete != null)
              IconButton(
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
                icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                onPressed: onDelete,
              ),

            Transform.scale(
              scale: 0.85,
              child: Switch(
                value: schedule.enabled,
                onChanged: onToggle,
                activeThumbColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
