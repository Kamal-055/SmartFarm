import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/alert_provider.dart';
import '../../providers/fodder_inventory_provider.dart';
import '../../providers/history_provider.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/simulation_provider.dart';
import '../../widgets/feeding_progress_card.dart';

class FeedingScreen extends StatefulWidget {
  const FeedingScreen({super.key});

  @override
  State<FeedingScreen> createState() => _FeedingScreenState();
}

class _FeedingScreenState extends State<FeedingScreen> {
  bool _isManualMode = false;
  double _manualTargetKg = 1.20;

  @override
  Widget build(BuildContext context) {
    final simProvider = Provider.of<SimulationProvider>(context);
    final inventoryProvider = Provider.of<FodderInventoryProvider>(context);
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);
    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);

    final feedPred = simProvider.currentFeedPrediction;
    final blockagePred = simProvider.currentBlockagePrediction;
    final targetQty = _isManualMode ? _manualTargetKg : feedPred.predictedQuantityKg;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Feed Your Cattle'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            child: Chip(
              backgroundColor: AppColors.primaryDark,
              side: const BorderSide(color: AppColors.primaryAccent),
              label: Text(
                _isManualMode ? 'CUSTOM' : 'SMART RECOMMEND',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryAccent),
              ),
            ),
          ),
        ],
      ),
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
              padding: const EdgeInsets.only(left: 14, right: 14, top: 12, bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mode Selection Toggle (Smart Recommended vs Custom Quantity)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.glassForestCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.glassForestBorder),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isManualMode = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                              decoration: BoxDecoration(
                                color: !_isManualMode ? AppColors.primaryAccent : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '🌱 SMART RECOMMENDATION',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: !_isManualMode ? AppColors.primaryDark : Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isManualMode = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                              decoration: BoxDecoration(
                                color: _isManualMode ? AppColors.primaryAccent : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '🖐️ CUSTOM QUANTITY',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: _isManualMode ? AppColors.primaryDark : Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quantity Stepper & Slider
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.glassForestCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _isManualMode ? 'Custom Target Quantity' : 'Recommended Hay Quantity',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            Text(
                              '${targetQty.toStringAsFixed(2)} kg',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primaryAccent),
                            ),
                          ],
                        ),
                        if (_isManualMode) ...[
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: AppColors.primaryAccent, size: 28),
                                onPressed: () {
                                  setState(() {
                                    if (_manualTargetKg > 0.3) _manualTargetKg -= 0.1;
                                  });
                                },
                              ),
                              Expanded(
                                child: Slider(
                                  value: _manualTargetKg.clamp(0.2, 2.5),
                                  min: 0.2,
                                  max: 2.5,
                                  divisions: 23,
                                  activeColor: AppColors.primaryAccent,
                                  inactiveColor: Colors.black45,
                                  label: '${_manualTargetKg.toStringAsFixed(2)} kg',
                                  onChanged: (val) {
                                    setState(() => _manualTargetKg = val);
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryAccent, size: 28),
                                onPressed: () {
                                  setState(() {
                                    if (_manualTargetKg < 2.5) _manualTargetKg += 0.1;
                                  });
                                },
                              ),
                            ],
                          ),
                        ] else ...[
                          const SizedBox(height: 6),
                          const Text(
                            'Optimized automatically based on current hopper and trough conditions.',
                            style: TextStyle(fontSize: 11, color: Colors.white70),
                          ),
                        ]
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Live Dispenser Controls Card
                  FeedingProgressCard(
                    targetQuantityKg: targetQty,
                    currentDispensedKg: simProvider.currentDispensedKg,
                    progressRatio: simProvider.dispenseProgress,
                    gateOpeningPercent: blockagePred.adjustedGateOpeningPercent,
                    gateTimeSeconds: feedPred.estimatedGateTimeSeconds,
                    isFeedingActive: simProvider.isFeedingActive,
                    onStart: () {
                      final success = simProvider.executeFeedingCycle(
                        inventoryProvider: inventoryProvider,
                        historyProvider: historyProvider,
                        alertProvider: alertProvider,
                        manualTargetKg: _isManualMode ? _manualTargetKg : null,
                      );

                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Not enough fodder available in hopper. Please refill!'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    onStop: () {
                      simProvider.stopFeedingCycle();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Automatic Feeding Schedule Config (Dynamic from ScheduleProvider)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.glassForestCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.glassForestBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'AUTOMATIC DAILY SCHEDULE',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryAccent,
                                letterSpacing: 0.8,
                              ),
                            ),
                            Text('AUTOMATION ACTIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onlineGreen)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: scheduleProvider.schedules.length,
                          separatorBuilder: (_, __) => const Divider(color: Colors.white12, height: 16),
                          itemBuilder: (context, index) {
                            final sch = scheduleProvider.schedules[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.access_time_rounded, color: AppColors.primaryAccent, size: 18),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sch.name,
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                        Text(
                                          '${sch.time} — ${sch.targetQtyKg.toStringAsFixed(2)} kg',
                                          style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: sch.enabled,
                                  activeThumbColor: AppColors.primaryAccent,
                                  onChanged: (val) {
                                    scheduleProvider.toggleSchedule(sch);
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Real-Time Feed Status Box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.glassForestCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.glassForestBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DISPENSER SYSTEM STATUS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryAccent,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Feed Gate Position:',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12, color: Colors.white70),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${blockagePred.adjustedGateOpeningPercent.toStringAsFixed(0)}% Open',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Flow Assist:',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12, color: Colors.white70),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  blockagePred.vibratorActivated ? 'ACTIVE (Assisting Flow)' : 'READY',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: blockagePred.vibratorActivated ? Colors.orangeAccent : AppColors.onlineGreen,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
