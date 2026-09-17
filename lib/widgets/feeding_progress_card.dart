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
              const Expanded(
                child: Row(
                  children: [
                    Icon(Icons.precision_manufacturing, color: AppColors.primaryAccent, size: 20),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Live Hay Dispenser Controls',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    const SizedBox(width: 4),
                    Text(
                      isFeedingActive ? 'DISPENSING ACTIVE' : 'IDLE / READY',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: isFeedingActive ? AppColors.onlineGreen : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Visual Dispenser Chamber Graphic (Hopper -> Gate -> Hay Flow -> Trough)
          Container(
            height: 140,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.inventory_2, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'GRAVITY HOPPER (HAY DISPENSER)',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber.withValues(alpha: 0.9),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          'GATE OPENING: ${gateOpeningPercent.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 10,
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
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.5)),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isFeedingActive ? Icons.grass : Icons.table_restaurant,
                              color: isFeedingActive ? AppColors.onlineGreen : Colors.white60,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                isFeedingActive ? 'HAY FLOWING INTO TROUGH...' : 'FEED TROUGH (LOAD CELL)',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isFeedingActive ? AppColors.onlineGreen : Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Progress Bar & Percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Current Dispensed: ${currentDispensedKg.toStringAsFixed(2)} kg',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$percentText%',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryAccent),
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
          const SizedBox(height: 12),

          // Metrics Summary Row
          Row(
            children: [
              Expanded(child: _buildMetricTile('Target Qty', '${targetQuantityKg.toStringAsFixed(2)} kg')),
              const SizedBox(width: 6),
              Expanded(child: _buildMetricTile('Gate Time', '${gateTimeSeconds.toStringAsFixed(1)} s')),
              const SizedBox(width: 6),
              Expanded(child: _buildMetricTile('Gate Pos', '${gateOpeningPercent.toStringAsFixed(0)}%')),
            ],
          ),
          const SizedBox(height: 16),

          // Action Buttons: START FEEDING / PAUSE / STOP
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFeedingActive ? Colors.orangeAccent : AppColors.primaryAccent,
                      foregroundColor: AppColors.primaryDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: isFeedingActive ? onStop : onStart,
                    icon: Icon(isFeedingActive ? Icons.pause_circle_outline : Icons.play_circle_outline, size: 20),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        isFeedingActive ? 'PAUSE / STOP' : 'START FEEDING',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String label, String val) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.6))),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
