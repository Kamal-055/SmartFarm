import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../providers/simulation_provider.dart';

class ActivityTimelineWidget extends StatelessWidget {
  final List<SystemActivityItem> activityLog;

  const ActivityTimelineWidget({
    super.key,
    required this.activityLog,
  });

  @override
  Widget build(BuildContext context) {
    if (activityLog.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.glassForestCard,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'Waiting for system events...',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.glassForestCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.glassForestBorder,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.timeline, color: AppColors.primaryAccent, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Real-Time Activity Timeline',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                '${activityLog.length} Events',
                style: const TextStyle(fontSize: 11, color: AppColors.primaryAccent),
              ),
            ],
          ),
          const SizedBox(height: 14),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activityLog.length > 8 ? 8 : activityLog.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = activityLog[index];
              final timeStr = DateFormat('HH:mm:ss').format(item.timestamp);

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time Column
                  SizedBox(
                    width: 60,
                    child: Text(
                      timeStr,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),

                  // Node Icon Dot
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: item.color, width: 1.2),
                    ),
                    child: Icon(item.icon, color: item.color, size: 12),
                  ),
                  const SizedBox(width: 10),

                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: item.color,
                          ),
                        ),
                        Text(
                          item.description,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
