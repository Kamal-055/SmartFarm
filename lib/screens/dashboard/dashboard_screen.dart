import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/farm_provider.dart';
import '../../providers/simulation_provider.dart';
import '../../widgets/activity_timeline.dart';
import '../../widgets/ai_insight_card.dart';
import '../../widgets/sensor_card.dart';
import '../../widgets/simulation_control_bar.dart';
import '../ai_models/ai_feed_prediction_screen.dart';
import '../ai_models/blockage_prediction_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final farmProvider = Provider.of<FarmProvider>(context);
    final simProvider = Provider.of<SimulationProvider>(context);

    final farmerName = authProvider.user?.name ?? 'Green Valley Farmer';
    final farmName = farmProvider.farm.name;

    final feedRecord = simProvider.currentFeedRecord;
    final blockageRecord = simProvider.currentBlockageRecord;
    final feedPred = simProvider.currentFeedPrediction;
    final blockagePred = simProvider.currentBlockagePrediction;

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
              padding: const EdgeInsets.only(left: 14, right: 14, top: 12, bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Top Header: Welcome Greeting & Honest Connection Status Badge
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
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
                          blurRadius: 16,
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
                            Expanded(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.primaryAccent.withValues(alpha: 0.2),
                                    child: const Icon(Icons.person, color: AppColors.primaryAccent, size: 22),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Good Morning, $farmerName',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.white.withValues(alpha: 0.75),
                                          ),
                                        ),
                                        const Text(
                                          'Smart Livestock AI System',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Honest Connection Badge (Simulation Online)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.onlineGreen.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.onlineGreen.withValues(alpha: 0.5)),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.sensors, color: AppColors.onlineGreen, size: 12),
                                      SizedBox(width: 4),
                                      Text(
                                        '● Simulation Online',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.onlineGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Simulated IoT Data',
                                    style: TextStyle(fontSize: 9, color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Farm Name & Weather Bar
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: AppColors.primaryAccent, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              farmName,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const Spacer(),
                            const Icon(Icons.wb_sunny, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '28°C | Sunny / Clear',
                              style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.8)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2. Real-Time IoT Simulation Stream Control Bar
                  const SimulationControlBar(),
                  const SizedBox(height: 16),

                  // Section Title
                  const Text(
                    'LIVE SENSOR TELEMETRY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryAccent,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 3. Live Sensor Telemetry 2x3 Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.45,
                    children: [
                      SensorCard(
                        title: 'Hopper Level',
                        value: feedRecord.hopperLevelCm.toStringAsFixed(1),
                        unit: 'cm',
                        icon: Icons.inventory_2_outlined,
                        accentColor: Colors.amberAccent,
                        subtitle: 'Ultrasonic Sensor',
                      ),
                      SensorCard(
                        title: 'Trough Weight',
                        value: feedRecord.troughWeightBeforeKg.toStringAsFixed(2),
                        unit: 'kg',
                        icon: Icons.scale_outlined,
                        accentColor: Colors.cyanAccent,
                        subtitle: 'Load Cell + HX711',
                      ),
                      SensorCard(
                        title: 'Gate Position',
                        value: feedRecord.gateOpeningPercent.toStringAsFixed(0),
                        unit: '%',
                        icon: Icons.door_sliding_outlined,
                        accentColor: AppColors.primaryAccent,
                        subtitle: 'Servo Motor',
                      ),
                      SensorCard(
                        title: 'Hay Flow',
                        value: blockageRecord.irFlowDetected ? 'DETECTED' : 'IDLE',
                        unit: '',
                        icon: Icons.sensors,
                        accentColor: blockageRecord.irFlowDetected ? AppColors.onlineGreen : Colors.orangeAccent,
                        subtitle: 'IR Break Beam',
                      ),
                      SensorCard(
                        title: 'Vibration Motor',
                        value: blockagePred.vibratorActivated ? 'ACTIVE' : 'OFF',
                        unit: '',
                        icon: Icons.vibration,
                        accentColor: blockagePred.vibratorActivated ? Colors.orangeAccent : Colors.grey,
                        subtitle: 'Blockage Mitigation',
                      ),
                      SensorCard(
                        title: 'System State',
                        value: 'READY',
                        unit: '',
                        icon: Icons.check_circle_outline,
                        accentColor: AppColors.onlineGreen,
                        subtitle: 'ESP32 Controller',
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Section Title
                  const Text(
                    'DUAL AI MODULE PREDICTIONS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryAccent,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 4. Two Major AI Status Cards
                  Row(
                    children: [
                      // Module 1: Adaptive Feed AI
                      Expanded(
                        child: AIInsightCard(
                          moduleTitle: 'Adaptive Feed AI',
                          primaryValue: '${feedPred.predictedQuantityKg.toStringAsFixed(2)} kg',
                          primaryLabel: 'Predicted Hay Quantity',
                          statusText: 'Gate Time: ${feedPred.estimatedGateTimeSeconds}s',
                          confidencePercentage: feedPred.confidencePercentage,
                          icon: Icons.psychology,
                          accentColor: AppColors.primaryAccent,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const AIFeedPredictionScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Module 2: Blockage AI
                      Expanded(
                        child: AIInsightCard(
                          moduleTitle: 'Blockage AI',
                          primaryValue: blockagePred.riskTitle,
                          primaryLabel: 'Classifier Output',
                          statusText: blockagePred.vibratorActivated ? 'Vibration ON' : 'Normal Flow',
                          confidencePercentage: blockagePred.confidencePercentage,
                          icon: Icons.security,
                          accentColor: blockagePred.riskCode == 0
                              ? AppColors.onlineGreen
                              : (blockagePred.riskCode == 1 ? Colors.orangeAccent : Colors.redAccent),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const BlockagePredictionScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // 5. System Activity Timeline
                  ActivityTimelineWidget(activityLog: simProvider.activityLog),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
