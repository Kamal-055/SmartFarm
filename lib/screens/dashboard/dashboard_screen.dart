import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../providers/auth_provider.dart';
import '../../providers/farm_provider.dart';
import '../../providers/simulation_provider.dart';
import '../../widgets/activity_timeline.dart';
import '../../widgets/ai_insight_card.dart';
import '../../widgets/sensor_card.dart';
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

    final padding = Responsive.horizontalPadding(context);
    final gridRatio = Responsive.sensorGridRatio(context);

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
                  // 1. Top Header: Welcome Greeting & System Status Badge
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
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
                                    radius: 18,
                                    backgroundColor: AppColors.primaryAccent.withValues(alpha: 0.2),
                                    child: const Icon(Icons.person, color: AppColors.primaryAccent, size: 20),
                                  ),
                                  const SizedBox(width: 8),
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
                                          'Smart Cattle Feeding',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 15,
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
                            const SizedBox(width: 6),

                            // Honest Connection Badge (System Online Tag)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.onlineGreen.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.onlineGreen.withValues(alpha: 0.5)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle_rounded, color: AppColors.onlineGreen, size: 12),
                                  SizedBox(width: 4),
                                  Text(
                                    '● System Online',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onlineGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Farm Name & Weather Bar
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: AppColors.primaryAccent, size: 14),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                farmName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            const Icon(Icons.wb_sunny, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '28°C | Sunny',
                              style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.8)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2. Agricultural Hero Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryDark,
                          AppColors.primaryMedium.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.4)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.pets, color: AppColors.primaryAccent, size: 28),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your cattle are taken care of.',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Automatic feeding system active & monitoring hay level.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section Title
                  const Text(
                    'LIVE FARM STATUS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryAccent,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 3. Live Farm Status 2x2 Grid (Farmer Friendly Cards)
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: gridRatio,
                    children: [
                      SensorCard(
                        title: '🌾 Fodder Bin',
                        value: feedRecord.hopperLevelCm.toStringAsFixed(1),
                        unit: 'cm',
                        icon: Icons.inventory_2_outlined,
                        accentColor: Colors.amberAccent,
                        subtitle: 'Fodder Level Good',
                      ),
                      SensorCard(
                        title: '⚖ Feed Trough',
                        value: feedRecord.troughWeightBeforeKg.toStringAsFixed(2),
                        unit: 'kg',
                        icon: Icons.scale_outlined,
                        accentColor: Colors.cyanAccent,
                        subtitle: 'Current Trough Weight',
                      ),
                      SensorCard(
                        title: '🌿 Feed Flow',
                        value: blockageRecord.irFlowDetected ? 'FLOWING' : 'READY',
                        unit: '',
                        icon: Icons.sensors,
                        accentColor: blockageRecord.irFlowDetected ? AppColors.onlineGreen : Colors.amber,
                        subtitle: 'Hay Movement Status',
                      ),
                      const SensorCard(
                        title: '✓ System Status',
                        value: 'READY',
                        unit: '',
                        icon: Icons.check_circle_outline,
                        accentColor: AppColors.onlineGreen,
                        subtitle: 'Dispenser Connected',
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Section Title
                  const Text(
                    'SMART FEED RECOMMENDATION',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryAccent,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 4. Two Major Smart Feeding Cards
                  Row(
                    children: [
                      // Smart Feed Recommendation Card
                      Expanded(
                        child: AIInsightCard(
                          moduleTitle: 'Smart Feed',
                          primaryValue: '${feedPred.predictedQuantityKg.toStringAsFixed(2)} kg',
                          primaryLabel: 'Recommended Feed',
                          statusText: 'Optimal Farm Quantity',
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

                      // Feed Flow Status Card
                      Expanded(
                        child: AIInsightCard(
                          moduleTitle: 'Feed Flow',
                          primaryValue: blockagePred.riskTitle,
                          primaryLabel: 'Flow Status',
                          statusText: blockagePred.vibratorActivated ? 'Vibration Active' : 'Normal Flow',
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

                  // 5. Recent Farm Activity Timeline
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
