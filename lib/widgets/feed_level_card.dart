import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/device_model.dart';

class FeedLevelCard extends StatelessWidget {
  final FeedStatus feed;
  final VoidCallback? onTap;

  const FeedLevelCard({
    super.key,
    required this.feed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final level = feed.levelPercentage;
    final statusText = feed.displayText;
    final color = _getBarColor(feed.status);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.grass, color: AppColors.primary, size: 26),
                      SizedBox(width: 8),
                      Text(
                        'Feed Level',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$level%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'remaining in bin',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: level / 100.0,
                  minHeight: 12,
                  backgroundColor: AppColors.surfaceWarm,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBarColor(FeedLevelStatus status) {
    switch (status) {
      case FeedLevelStatus.high:
      case FeedLevelStatus.good:
        return AppColors.success;
      case FeedLevelStatus.low:
        return AppColors.warning;
      case FeedLevelStatus.empty:
        return AppColors.error;
    }
  }
}
