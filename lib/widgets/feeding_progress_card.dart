import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class FeedingProgressCard extends StatelessWidget {
  final double targetQuantityKg;
  final double currentDispensedKg;
  final double progressRatio;
  final double gateOpeningPercent;
  final double gateTimeSeconds;
  final bool isFeedingActive;
  final VoidCallback? onStart;
  final VoidCallback? onStop;

  const FeedingProgressCard({
    super.key,
    required this.targetQuantityKg,
    required this.currentDispensedKg,
    required this.progressRatio,
    required this.gateOpeningPercent,
    required this.gateTimeSeconds,
    required this.isFeedingActive,
    this.onStart,
    this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final percentText = (progressRatio * 100).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.glassForestCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 18,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.precision_manufacturing, color: AppColors.primaryAccent, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Live Hay Dispenser Controls',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isFeedingActive
                      ? AppColors.onlineGreen.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isFeedingActive ? AppColors.onlineGreen : Colors.white30,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isFeedingActive ? AppColors.onlineGreen : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isFeedingActive ? 'DISPENSING ACTIVE' : 'IDLE / READY',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isFeedingActive ? AppColors.onlineGreen : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Visual Dispenser Chamber Graphic (Hopper -> Gate -> Hay Flow -> Trough)
          Container(
            height: 140,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                // Top: Hopper Bin
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.inventory_2, color: Colors.amber, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'GRAVITY HOPPER (HAY DISPENSER)',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Middle: Sliding Gate Gap Indicator
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.primaryAccent, thickness: 2)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'GATE OPENING: ${gateOpeningPercent.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryAccent,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: AppColors.primaryAccent, thickness: 2)),
                    ],
                  ),
                ),

                // Bottom: Trough Container
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.5)),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isFeedingActive ? Icons.grass : Icons.table_restaurant,
                            color: isFeedingActive ? AppColors.onlineGreen : Colors.white60,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isFeedingActive ? 'HAY FLOWING INTO TROUGH...' : 'FEED TROUGH (LOAD CELL)',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isFeedingActive ? AppColors.onlineGreen : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Progress Bar & Percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Dispensed: ${currentDispensedKg.toStringAsFixed(2)} kg',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                '$percentText%',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryAccent),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressRatio,
              minHeight: 12,
              backgroundColor: Colors.black.withValues(alpha: 0.4),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
            ),
          ),
          const SizedBox(height: 14),

          // Metrics Summary Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricTile('Target Qty', '${targetQuantityKg.toStringAsFixed(2)} kg'),
              _buildMetricTile('Gate Time', '${gateTimeSeconds.toStringAsFixed(1)} s'),
              _buildMetricTile('Gate Pos', '${gateOpeningPercent.toStringAsFixed(0)}%'),
            ],
          ),
          const SizedBox(height: 18),

          // Action Buttons: START FEEDING / PAUSE / STOP
          Row(
            children: [
              Expanded(
                child: ElevatedButton.styleFrom(
                  backgroundColor: isFeedingActive ? Colors.orangeAccent : AppColors.primaryAccent,
                  foregroundColor: AppColors.primaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ).build(
                  context,
                ) is Widget
                    ? SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFeedingActive ? Colors.orangeAccent : AppColors.primaryAccent,
                            foregroundColor: AppColors.primaryDark,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: isFeedingActive ? onStop : onStart,
                          icon: Icon(isFeedingActive ? Icons.pause_circle_outline : Icons.play_circle_outline, size: 22),
                          label: Text(
                            isFeedingActive ? 'PAUSE / STOP' : 'START FEEDING',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String label, String val) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.6))),
          const SizedBox(height: 2),
          Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}
