import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/simulation_provider.dart';

class SimulationControlBar extends StatelessWidget {
  const SimulationControlBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SimulationProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.glassForestCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          // Top Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: provider.isPaused ? AppColors.warning : AppColors.onlineGreen,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (provider.isPaused ? AppColors.warning : AppColors.onlineGreen).withValues(alpha: 0.6),
                          blurRadius: 6,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    provider.isPaused ? 'SIMULATION PAUSED' : 'AI + IoT LIVE SIMULATION',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: provider.isPaused ? AppColors.warning : AppColors.onlineGreen,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),

              // Record Indicator Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.4)),
                ),
                child: Text(
                  'Record #${provider.currentIndex + 1} / ${provider.totalRecords}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Action Buttons: Play/Pause, Next Record, Demo 1, Demo 2, Demo 3
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Play / Pause Button
                InkWell(
                  onTap: () => provider.toggleSimulationState(),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: provider.isPaused ? AppColors.onlineGreen : Colors.orangeAccent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: provider.isPaused ? AppColors.onlineGreen : Colors.orangeAccent),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          provider.isPaused ? Icons.play_arrow : Icons.pause,
                          size: 14,
                          color: provider.isPaused ? AppColors.primaryDark : Colors.orangeAccent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          provider.isPaused ? 'RESUME STREAM' : 'PAUSE STREAM',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: provider.isPaused ? AppColors.primaryDark : Colors.orangeAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Next Record Button
                InkWell(
                  onTap: () => provider.nextRecord(),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.skip_next, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'NEXT RECORD',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // DEMO 1 Button (Normal)
                _buildDemoButton(
                  context,
                  label: 'DEMO 1: Normal',
                  color: AppColors.onlineGreen,
                  onTap: () => provider.triggerDemoNormal(),
                ),
                const SizedBox(width: 6),

                // DEMO 2 Button (Moderate Blockage)
                _buildDemoButton(
                  context,
                  label: 'DEMO 2: Moderate Risk',
                  color: Colors.orangeAccent,
                  onTap: () => provider.triggerDemoModerateBlockage(),
                ),
                const SizedBox(width: 6),

                // DEMO 3 Button (Severe Blockage)
                _buildDemoButton(
                  context,
                  label: 'DEMO 3: Severe Risk',
                  color: Colors.redAccent,
                  onTap: () => provider.triggerDemoSevereBlockage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoButton(BuildContext context, {required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1.2),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
