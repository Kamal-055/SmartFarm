import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../providers/alert_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/farm_provider.dart';
import '../../providers/fodder_inventory_provider.dart';
import '../../providers/history_provider.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/simulation_provider.dart';
import '../../widgets/feeder_machine_widget.dart';
import '../ai_models/ai_feed_prediction_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.horizontalPadding(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final farmProvider = Provider.of<FarmProvider>(context);
    final simProvider = Provider.of<SimulationProvider>(context);
    final inventoryProvider = Provider.of<FodderInventoryProvider>(context);
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final alertProvider = Provider.of<AlertProvider>(context);

    final farmerName = authProvider.user?.name ?? 'Farmer';
    final farmName = farmProvider.farm.name;
    final recommendedQty = simProvider.currentFeedPrediction.predictedQuantityKg;
    final nextSch = scheduleProvider.nextUpcomingSchedule;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background AI Aerial Farm Image with Dark Overlay
          Positioned.fill(
            child: Image.asset(
              'assets/images/aerial_farm_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: AppColors.background.withValues(alpha: 0.90),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: padding, right: padding, top: 12, bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Top Farmer Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning, $farmerName',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: AppColors.primaryAccent, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                farmName,
                                style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7)),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // System Online Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.onlineGreen.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.onlineGreen.withValues(alpha: 0.5)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.circle, color: AppColors.onlineGreen, size: 8),
                            SizedBox(width: 6),
                            Text('SYSTEM ONLINE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onlineGreen)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 2. Main Digital Feeder Machine Visual Container
                  FeederMachineWidget(
                    simProvider: simProvider,
                    inventoryProvider: inventoryProvider,
                    onRefillRequested: () => _showRefillDialog(context, inventoryProvider, alertProvider),
                  ),
                  const SizedBox(height: 16),

                  // 3. Compact Smart Feed Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.glassForestCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.glassForestBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const AIFeedPredictionScreen()),
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryAccent.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.auto_awesome, color: AppColors.primaryAccent, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('SMART RECOMMENDATION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryAccent)),
                                      const SizedBox(height: 2),
                                      Text('${recommendedQty.toStringAsFixed(2)} kg Recommended', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryAccent,
                            foregroundColor: AppColors.primaryDark,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: simProvider.isFeedingActive
                              ? null
                              : () {
                                  final success = simProvider.executeFeedingCycle(
                                    inventoryProvider: inventoryProvider,
                                    historyProvider: historyProvider(context),
                                    alertProvider: alertProvider,
                                    manualTargetKg: recommendedQty,
                                  );

                                  if (!success) {
                                    _showRefillDialog(context, inventoryProvider, alertProvider);
                                  }
                                },
                          icon: const Icon(Icons.play_arrow_rounded, size: 20),
                          label: Text(
                            simProvider.isFeedingActive ? 'FEEDING' : 'FEED NOW',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 4. Compact Next Scheduled Feed Container
                  if (nextSch != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.glassForestCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.glassForestBorder),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time_filled, color: AppColors.wheatGolden, size: 20),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'NEXT FEEDING — ${nextSch.name.toUpperCase()}',
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.wheatGolden),
                                  ),
                                  Text(
                                    '${nextSch.time} • ${nextSch.targetQtyKg.toStringAsFixed(2)} kg',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Switch(
                            value: nextSch.enabled,
                            activeThumbColor: AppColors.primaryAccent,
                            onChanged: (val) {
                              scheduleProvider.toggleSchedule(nextSch);
                            },
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 14),

                  // 5. Compact Farm Status Strip
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatusTile('Fodder Level', '${inventoryProvider.availableFodderKg.toStringAsFixed(1)} kg', inventoryProvider.statusColor, Icons.inventory_2_outlined),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatusTile('Feed Flow', 'SMOOTH', AppColors.onlineGreen, Icons.sensors),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatusTile('System', 'READY', AppColors.onlineGreen, Icons.check_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  HistoryProvider historyProvider(BuildContext context) {
    return Provider.of<HistoryProvider>(context, listen: false);
  }

  Widget _buildStatusTile(String title, String val, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.glassForestCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(val, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 9, color: Colors.white.withValues(alpha: 0.6))),
        ],
      ),
    );
  }

  void _showRefillDialog(BuildContext context, FodderInventoryProvider inventoryProvider, AlertProvider alertProvider) {
    final controller = TextEditingController(text: '5.0');
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.primaryDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.inventory_2, color: AppColors.primaryAccent),
              SizedBox(width: 10),
              Text('Refill Fodder Bin', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Available Fodder: ${inventoryProvider.availableFodderKg.toStringAsFixed(2)} kg',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: 'Fodder Amount Added (kg)',
                  labelStyle: const TextStyle(color: AppColors.primaryAccent),
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                foregroundColor: AppColors.primaryDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final amount = double.tryParse(controller.text) ?? 5.0;
                inventoryProvider.refillFodder(amount, alertProvider);
                Navigator.of(ctx).pop();
              },
              child: const Text('CONFIRM REFILL', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
