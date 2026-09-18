import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../providers/fodder_inventory_provider.dart';
import '../providers/simulation_provider.dart';

class FeederMachineWidget extends StatelessWidget {
  final SimulationProvider simProvider;
  final FodderInventoryProvider inventoryProvider;
  final VoidCallback onRefillRequested;

  const FeederMachineWidget({
    super.key,
    required this.simProvider,
    required this.inventoryProvider,
    required this.onRefillRequested,
  });

  @override
  Widget build(BuildContext context) {
    final isFeeding = simProvider.isFeedingActive;
    final availableKg = inventoryProvider.availableFodderKg;
    final totalCapKg = inventoryProvider.totalCapacityKg;
    final fillRatio = (availableKg / totalCapKg).clamp(0.0, 1.0);
    final isLow = inventoryProvider.isLow || inventoryProvider.isCritical;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isFeeding
              ? AppColors.primaryMedium
              : (isLow ? Colors.amber.shade600 : AppColors.border),
          width: isFeeding ? 2.0 : 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 18,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background Pastoral Farm Aerial Landscape Graphics Overlay
            Positioned.fill(
              child: Opacity(
                opacity: 0.18,
                child: Image.asset(
                  'assets/images/farm_bg.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(color: const Color(0xFFE5EFE7)),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  // Top Row: Hopper Silo Graphic with Floating Supply Card & Gauge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left: Cattle Pasture Image Thumbnail & Hopper Silo Graphic
                      Container(
                        width: 110,
                        height: 140,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F5F1),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('🐄 🌾', style: TextStyle(fontSize: 26)),
                                SizedBox(height: 4),
                                Icon(Icons.museum_outlined, color: AppColors.primaryMedium, size: 44),
                                SizedBox(height: 2),
                                Text('SMART SILO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                              ],
                            ),
                            if (isFeeding)
                              Positioned(
                                bottom: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade700,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('DISPENSING', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Right: Floating Fodder Supply Badge & Vertical Gauge Bar
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.border),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0C000000),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: isLow ? Colors.amber.shade700 : AppColors.onlineGreen,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'Fodder Supply',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        availableKg.toStringAsFixed(1),
                                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'kg',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'of ${totalCapKg.toInt()} kg capacity',
                                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                  ),
                                  const SizedBox(height: 8),

                                  if (isLow)
                                    InkWell(
                                      onTap: onRefillRequested,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.shade100,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.amber.shade600),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.add_circle_outline, color: Colors.amber.shade900, size: 14),
                                            const SizedBox(width: 4),
                                            Text('REFILL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber.shade900)),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              // Vertical Golden Wheat Gauge Indicator
                              Container(
                                width: 14,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAEFEA),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    AnimatedFractionallySizedBox(
                                      duration: const Duration(milliseconds: 500),
                                      heightFactor: fillRatio,
                                      widthFactor: 1.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isLow ? Colors.amber.shade600 : AppColors.wheatGolden,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Bottom Banner: System Ready & Next Feeding Notice
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.glassForestCard,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFeeding ? Icons.sync_rounded : Icons.check_circle_rounded,
                            color: AppColors.primaryAccent,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isFeeding ? 'FEEDING IN PROGRESS' : 'System Ready',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              Text(
                                isFeeding ? simProvider.feedingStatusText : 'Next automatic feeding scheduled at 01:00 PM',
                                style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.8)),
                              ),
                            ],
                          ),
                        ),
                      ],
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

