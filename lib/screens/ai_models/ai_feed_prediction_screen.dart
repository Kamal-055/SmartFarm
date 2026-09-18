import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/fodder_inventory_provider.dart';
import '../../providers/simulation_provider.dart';

class AIFeedPredictionScreen extends StatelessWidget {
  const AIFeedPredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<FodderInventoryProvider>(context);
    final simProvider = Provider.of<SimulationProvider>(context);

    final currentFodderKg = inventoryProvider.availableFodderKg;
    final troughWeightKg = simProvider.currentTroughWeightKg;
    final isFeeding = simProvider.isFeedingActive;
    final targetKg = simProvider.currentFeedPrediction.predictedQuantityKg;
    final gateOpening = isFeeding ? 75 : 50;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Smart Recommendations',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Optimal Feed Calculation',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Tailored for 25 Holstein cattle based on target yield',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Hero Recommendation Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'RECOMMENDED FEED PORTION',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),

                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${targetKg.toStringAsFixed(1)} kg',
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Gate Opening', style: TextStyle(fontSize: 10, color: Colors.white70)),
                                const SizedBox(height: 2),
                                Text('$gateOpening%', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            ),
                          ),
                          Container(height: 24, width: 1, color: Colors.white24),
                          const Expanded(
                            child: Column(
                              children: [
                                Text('Dispense Time', style: TextStyle(fontSize: 10, color: Colors.white70)),
                                SizedBox(height: 2),
                                Text('24 sec', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            ),
                          ),
                          Container(height: 24, width: 1, color: Colors.white24),
                          const Expanded(
                            child: Column(
                              children: [
                                Text('Confidence', style: TextStyle(fontSize: 10, color: Colors.white70)),
                                SizedBox(height: 2),
                                Text('98.4%', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Factors Grid
              const Text(
                'FARM PARAMETERS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8,
                ),
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
                  _buildFeatureTile('Cattle Count', '25 Heads', Icons.agriculture_rounded),
                  _buildFeatureTile('Fodder Level', '${currentFodderKg.toStringAsFixed(1)} kg', Icons.inventory_2_rounded),
                  _buildFeatureTile('Current Trough', '${troughWeightKg.toStringAsFixed(1)} kg', Icons.scale_rounded),
                  _buildFeatureTile('Target Meal', '${targetKg.toStringAsFixed(1)} kg', Icons.restaurant_rounded),
                  _buildFeatureTile('Gate Status', isFeeding ? 'Open (75%)' : 'Closed', Icons.door_sliding_rounded),
                  _buildFeatureTile('Next Meal', '12:30 PM', Icons.schedule_rounded),
                ],
              ),
              const SizedBox(height: 20),

              // Bar Chart
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Target vs Actual Portion Accuracy',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      height: 180,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 2.0,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (val, meta) {
                                  switch (val.toInt()) {
                                    case 0:
                                      return const Text('Feed 1', style: TextStyle(color: AppColors.textSecondary, fontSize: 10));
                                    case 1:
                                      return const Text('Feed 2', style: TextStyle(color: AppColors.textSecondary, fontSize: 10));
                                    case 2:
                                      return const Text('Feed 3', style: TextStyle(color: AppColors.textSecondary, fontSize: 10));
                                    case 3:
                                      return const Text('Feed 4', style: TextStyle(color: AppColors.textSecondary, fontSize: 10));
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
                              BarChartRodData(toY: 1.20, color: AppColors.primary, width: 12),
                              BarChartRodData(toY: 1.18, color: AppColors.secondary, width: 12),
                            ]),
                            BarChartGroupData(x: 1, barRods: [
                              BarChartRodData(toY: 0.80, color: AppColors.primary, width: 12),
                              BarChartRodData(toY: 0.78, color: AppColors.secondary, width: 12),
                            ]),
                            BarChartGroupData(x: 2, barRods: [
                              BarChartRodData(toY: 1.40, color: AppColors.primary, width: 12),
                              BarChartRodData(toY: 1.37, color: AppColors.secondary, width: 12),
                            ]),
                            BarChartGroupData(x: 3, barRods: [
                              BarChartRodData(toY: 1.30, color: AppColors.primary, width: 12),
                              BarChartRodData(toY: 1.28, color: AppColors.secondary, width: 12),
                            ]),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.circle, color: AppColors.primary, size: 10),
                        SizedBox(width: 4),
                        Text('Target Portion', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        SizedBox(width: 16),
                        Icon(Icons.circle, color: AppColors.secondary, size: 10),
                        SizedBox(width: 4),
                        Text('Actual Dispensed', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureTile(String label, String val, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
                Text(
                  val,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
