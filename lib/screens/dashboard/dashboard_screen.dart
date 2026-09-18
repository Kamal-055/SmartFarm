import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../providers/alert_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/farm_provider.dart';
import '../../providers/fodder_inventory_provider.dart';
import '../../providers/history_provider.dart';
import '../../providers/simulation_provider.dart';
import '../../widgets/feeder_machine_widget.dart';
import '../feeding/refill_fodder_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.horizontalPadding(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final farmProvider = Provider.of<FarmProvider>(context);
    final simProvider = Provider.of<SimulationProvider>(context);
    final inventoryProvider = Provider.of<FodderInventoryProvider>(context);
    final alertProvider = Provider.of<AlertProvider>(context);

    final farmerName = authProvider.user?.name ?? 'Ramesh!';
    final farmName = farmProvider.farm.name;
    final recommendedQty = simProvider.currentFeedPrediction.predictedQuantityKg;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: padding, right: padding, top: 16, bottom: 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Greeting Header matching Reference UI
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning $farmerName',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: AppColors.primaryMedium, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            farmName,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Farmer Profile Avatar
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryMedium, width: 1.5),
                    ),
                    child: const ClipOval(
                      child: Icon(Icons.person_rounded, color: AppColors.primaryMedium, size: 28),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // System Online Status Pill Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.onlineGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'System Online',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            Text(
                              'All systems working perfectly',
                              style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Icon(Icons.notifications_none_rounded, color: AppColors.textSecondary, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Main Digital Silo Visual Machine Card
              FeederMachineWidget(
                simProvider: simProvider,
                inventoryProvider: inventoryProvider,
                onRefillRequested: () => _openRefillScreen(context),
              ),
              const SizedBox(height: 16),

              // 3. Quick Status Cards Grid (Trough, Feed Flow, Gate)
              Row(
                children: [
                  Expanded(
                    child: _buildQuickTile(
                      label: 'Trough',
                      val: '${simProvider.currentTroughWeightKg.toStringAsFixed(2)} kg',
                      icon: Icons.hourglass_top_rounded,
                      color: AppColors.primaryMedium,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildQuickTile(
                      label: 'Feed Flow',
                      val: 'Good',
                      icon: Icons.sensors_rounded,
                      color: AppColors.onlineGreen,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildQuickTile(
                      label: 'Gate',
                      val: simProvider.isFeedingActive ? 'Open' : 'Closed',
                      icon: Icons.sensor_door_outlined,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 4. Prominent [ Start Feeding ] Primary Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: simProvider.isFeedingActive ? Colors.redAccent.shade700 : AppColors.primaryMedium,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  onPressed: () {
                    if (simProvider.isFeedingActive) {
                      simProvider.stopFeedingCycle();
                    } else {
                      final success = simProvider.executeFeedingCycle(
                        inventoryProvider: inventoryProvider,
                        historyProvider: Provider.of<HistoryProvider>(context, listen: false),
                        alertProvider: alertProvider,
                        manualTargetKg: recommendedQty,
                      );

                      if (!success) {
                        _openRefillScreen(context);
                      }
                    }
                  },
                  icon: Icon(
                    simProvider.isFeedingActive ? Icons.stop_circle_rounded : Icons.play_arrow_rounded,
                    size: 24,
                  ),
                  label: Text(
                    simProvider.isFeedingActive ? 'STOP FEEDING' : 'START FEEDING',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickTile({
    required String label,
    required String val,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted),
          ),
          const SizedBox(height: 2),
          Text(
            val,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  void _openRefillScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RefillFodderScreen()),
    );
  }
}

