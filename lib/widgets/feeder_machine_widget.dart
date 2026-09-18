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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassForestCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isFeeding
              ? AppColors.primaryAccent
              : (isLow ? Colors.amber : AppColors.glassForestBorder),
          width: isFeeding ? 1.8 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isFeeding ? AppColors.primaryAccent : Colors.black).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        children: [
          // Header status banner
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isFeeding ? Colors.orangeAccent : (isLow ? Colors.amber : AppColors.onlineGreen),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isFeeding ? 'FEEDING IN PROGRESS' : (isLow ? 'FODDER LOW' : 'SYSTEM READY'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: isFeeding ? Colors.orangeAccent : (isLow ? Colors.amber : AppColors.onlineGreen),
                    ),
                  ),
                ],
              ),
              if (isLow && !isFeeding)
                InkWell(
                  onTap: onRefillRequested,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_circle_outline, color: Colors.amber, size: 14),
                        SizedBox(width: 4),
                        Text('REFILL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // Digital Machine Layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Fodder Bin Visualizer (Hopper)
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    const Text('FODDER BIN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70)),
                    const SizedBox(height: 4),

                    // Hopper graphic container
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // Animated Hay Level Fill
                          AnimatedFractionallySizedBox(
                            duration: const Duration(milliseconds: 500),
                            heightFactor: fillRatio,
                            widthFactor: 1.0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.wheatGolden.withValues(alpha: 0.9),
                                    AppColors.wheatDark,
                                  ],
                                ),
                                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(13)),
                              ),
                            ),
                          ),

                          // Text label overlay inside bin
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.grass, color: Colors.white, size: 22),
                                Text(
                                  '${availableKg.toStringAsFixed(1)} kg',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                                ),
                                Text(
                                  '${(fillRatio * 100).toInt()}% Capacity',
                                  style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.8)),
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

              // Center: Feed Gate & Hay Flow Arrow Column
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Gate position indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isFeeding ? AppColors.primaryAccent.withValues(alpha: 0.2) : Colors.black26,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isFeeding ? AppColors.primaryAccent : Colors.white24),
                      ),
                      child: Text(
                        isFeeding ? 'GATE OPEN 60%' : 'GATE CLOSED',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: isFeeding ? AppColors.primaryAccent : Colors.white60,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Animated Hay Flow Particles
                    isFeeding
                        ? const Column(
                            children: [
                              Icon(Icons.arrow_downward, color: AppColors.primaryAccent, size: 18),
                              Text('🌾 🌾 🌾', style: TextStyle(fontSize: 12)),
                              Icon(Icons.arrow_downward, color: AppColors.primaryAccent, size: 18),
                            ],
                          )
                        : Icon(Icons.arrow_downward, color: Colors.white.withValues(alpha: 0.3), size: 24),
                    const SizedBox(height: 6),

                    Text(
                      isFeeding ? 'DISPENSING' : 'IDLE',
                      style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.7)),
                    ),
                  ],
                ),
              ),

              // Right: Cattle Trough Visualizer
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    const Text('CATTLE TROUGH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70)),
                    const SizedBox(height: 4),

                    // Trough graphic container
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // Trough weight fill indicator
                          AnimatedFractionallySizedBox(
                            duration: const Duration(milliseconds: 300),
                            heightFactor: (simProvider.currentTroughWeightKg / 3.0).clamp(0.15, 1.0),
                            widthFactor: 1.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.onlineGreen.withValues(alpha: 0.3),
                                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(13)),
                              ),
                            ),
                          ),

                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('🐄 🐄', style: TextStyle(fontSize: 18)),
                                const SizedBox(height: 2),
                                Text(
                                  '${simProvider.currentTroughWeightKg.toStringAsFixed(2)} kg',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                                ),
                                Text(
                                  isFeeding ? '+${simProvider.currentDispensedKg.toStringAsFixed(2)} kg' : 'Trough Scale',
                                  style: TextStyle(fontSize: 10, color: isFeeding ? AppColors.onlineGreen : Colors.white60),
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

          // Live Progress Bar when Feeding is Active
          if (isFeeding) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.4)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(simProvider.feedingStatusText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(
                        '${simProvider.currentDispensedKg.toStringAsFixed(2)} kg dispensed',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryAccent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: simProvider.dispenseProgress,
                      minHeight: 10,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
