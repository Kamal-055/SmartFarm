import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/simulation_provider.dart';

class AIFeedPredictionScreen extends StatelessWidget {
  const AIFeedPredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final simProvider = Provider.of<SimulationProvider>(context);
    final feedRecord = simProvider.currentFeedRecord;
    final feedPred = simProvider.currentFeedPrediction;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Adaptive Feed Intelligence'),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.glassForestCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.psychology, color: AppColors.primaryAccent, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'MODULE 1 — ADAPTIVE FEED REGRESSOR',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryAccent,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'AI estimates the required hay quantity using current hopper and trough conditions.',
                          style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Large Prediction Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryDark,
                          AppColors.glassForestCard,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.primaryAccent, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryAccent.withValues(alpha: 0.25),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'PREDICTED HAY QUANTITY',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryAccent,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          '${feedPred.predictedQuantityKg.toStringAsFixed(2)} kg',
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Calibration Parameters Output (F = aT + b)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Text('Recommended Gate', style: TextStyle(fontSize: 10, color: Colors.white60)),
                                  const SizedBox(height: 2),
                                  Text('${feedPred.recommendedGateOpeningPercent.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryAccent)),
                                ],
                              ),
                              Container(height: 24, width: 1, color: Colors.white24),
                              Column(
                                children: [
                                  const Text('Est. Gate Time (T)', style: TextStyle(fontSize: 10, color: Colors.white60)),
                                  const SizedBox(height: 2),
                                  Text('${feedPred.estimatedGateTimeSeconds} s', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
                                ],
                              ),
                              Container(height: 24, width: 1, color: Colors.white24),
                              Column(
                                children: [
                                  const Text('Model Confidence', style: TextStyle(fontSize: 10, color: Colors.white60)),
                                  const SizedBox(height: 2),
                                  Text('${feedPred.confidencePercentage}%', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onlineGreen)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        Text(
                          'Calibration Formula: F = aT + b (a = 0.30 kg/s, b = 0.05)',
                          style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.5), fontFamily: 'monospace'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Input Feature Cards Grid
                  const Text(
                    'INPUT FEATURE VALUES (REGRESSOR)',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryAccent, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 10),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.7,
                    children: [
                      _buildFeatureTile('Hopper Level', '${feedRecord.hopperLevelCm} cm', Icons.inventory_2_outlined),
                      _buildFeatureTile('Trough Wt Before', '${feedRecord.troughWeightBeforeKg} kg', Icons.scale_outlined),
                      _buildFeatureTile('Prev Dispensed', '${feedRecord.previousDispensedKg} kg', Icons.history),
                      _buildFeatureTile('Prev Leftover', '${feedRecord.previousLeftoverKg} kg', Icons.restaurant),
                      _buildFeatureTile('Gate Opening', '${feedRecord.gateOpeningPercent}%', Icons.door_sliding),
                      _buildFeatureTile('Timestamp', '08:00 AM', Icons.schedule),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Target vs Actual Chart Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.glassForestCard,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.glassForestBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Target vs Actual Dispensed Quantity Comparison',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 14),

                        SizedBox(
                          height: 180,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 2.0,
                              barTouchData: BarTouchDataEnabled(false),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (val, meta) {
                                      switch (val.toInt()) {
                                        case 0:
                                          return const Text('Rec 1', style: TextStyle(color: Colors.white70, fontSize: 10));
                                        case 1:
                                          return const Text('Rec 2', style: TextStyle(color: Colors.white70, fontSize: 10));
                                        case 2:
                                          return const Text('Rec 3', style: TextStyle(color: Colors.white70, fontSize: 10));
                                        case 3:
                                          return const Text('Rec 4', style: TextStyle(color: Colors.white70, fontSize: 10));
                                        case 4:
                                          return const Text('Rec 5', style: TextStyle(color: Colors.white70, fontSize: 10));
                                        default:
                                          return const Text('');
                                      }
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: const FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                              barGroups: [
                                BarChartGroupData(x: 0, barRods: [
                                  BarChartRodData(toY: 1.20, color: AppColors.primaryAccent, width: 12),
                                  BarChartRodData(toY: 1.18, color: AppColors.onlineGreen, width: 12),
                                ]),
                                BarChartGroupData(x: 1, barRods: [
                                  BarChartRodData(toY: 0.80, color: AppColors.primaryAccent, width: 12),
                                  BarChartRodData(toY: 0.78, color: AppColors.onlineGreen, width: 12),
                                ]),
                                BarChartGroupData(x: 2, barRods: [
                                  BarChartRodData(toY: 1.40, color: AppColors.primaryAccent, width: 12),
                                  BarChartRodData(toY: 1.37, color: AppColors.onlineGreen, width: 12),
                                ]),
                                BarChartGroupData(x: 3, barRods: [
                                  BarChartRodData(toY: 0.50, color: AppColors.primaryAccent, width: 12),
                                  BarChartRodData(toY: 0.49, color: AppColors.onlineGreen, width: 12),
                                ]),
                                BarChartGroupData(x: 4, barRods: [
                                  BarChartRodData(toY: 1.30, color: AppColors.primaryAccent, width: 12),
                                  BarChartRodData(toY: 1.28, color: AppColors.onlineGreen, width: 12),
                                ]),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.circle, color: AppColors.primaryAccent, size: 10),
                            SizedBox(width: 4),
                            Text('Predicted Target', style: TextStyle(fontSize: 11, color: Colors.white70)),
                            SizedBox(width: 16),
                            Icon(Icons.circle, color: AppColors.onlineGreen, size: 10),
                            SizedBox(width: 4),
                            Text('Actual Dispensed', style: TextStyle(fontSize: 11, color: Colors.white70)),
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

  Widget _buildFeatureTile(String label, String val, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryAccent, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.6))),
                Text(val, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
