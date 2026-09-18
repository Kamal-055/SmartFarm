import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../providers/history_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.horizontalPadding(context);
    final gridRatio = Responsive.sensorGridRatio(context);
    final historyProvider = Provider.of<HistoryProvider>(context);

    final todayFeedKg = historyProvider.todayDispensedKgSum;
    final cyclesCount = historyProvider.todayCompletedCount;
    final flowAssistedCount = historyProvider.todayFlowAssistedCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Farm Insights'),
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
              color: AppColors.primaryDark.withValues(alpha: 0.88),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: padding, right: padding, top: 12, bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Calculated Farm Performance Metric Summary Cards (Responsive)
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: gridRatio,
                    children: [
                      _buildMetricCard("Today's Feed", '${todayFeedKg.toStringAsFixed(2)} kg', 'Total Dispensed', Icons.grass, AppColors.onlineGreen),
                      _buildMetricCard('Feeding Cycles', '$cyclesCount', 'Completed Today', Icons.loop, AppColors.primaryAccent),
                      _buildMetricCard('Feed Flow Check', '$flowAssistedCount', 'Flow Assisted', Icons.shield, Colors.orangeAccent),
                      _buildMetricCard('Successful Feedings', '$cyclesCount', '100% Success', Icons.check_circle, Colors.cyanAccent),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // 2. Feed Dispense Quantity History Chart
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
                          'Daily Feed Usage (Target vs Actual)',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          height: 180,
                          child: LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: true, drawVerticalLine: false),
                              titlesData: FlTitlesData(
                                show: true,
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (val, meta) {
                                      return Text('C${val.toInt() + 1}', style: const TextStyle(color: Colors.white60, fontSize: 10));
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: const [
                                    FlSpot(0, 1.2),
                                    FlSpot(1, 0.8),
                                    FlSpot(2, 1.4),
                                    FlSpot(3, 0.5),
                                    FlSpot(4, 1.3),
                                    FlSpot(5, 1.6),
                                  ],
                                  isCurved: true,
                                  color: AppColors.primaryAccent,
                                  barWidth: 3,
                                  dotData: const FlDotData(show: true),
                                ),
                                LineChartBarData(
                                  spots: const [
                                    FlSpot(0, 1.18),
                                    FlSpot(1, 0.78),
                                    FlSpot(2, 1.37),
                                    FlSpot(3, 0.49),
                                    FlSpot(4, 1.28),
                                    FlSpot(5, 1.58),
                                  ],
                                  isCurved: true,
                                  color: AppColors.onlineGreen,
                                  barWidth: 3,
                                  dotData: const FlDotData(show: true),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Storage Bin Level History Chart
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
                          'Fodder Storage Bin Level History',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 14),

                        SizedBox(
                          height: 160,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 30,
                              barTouchData: BarTouchData(enabled: false),
                              borderData: FlBorderData(show: false),
                              barGroups: [
                                BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 10.5, color: Colors.amberAccent, width: 14)]),
                                BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 12.8, color: Colors.amberAccent, width: 14)]),
                                BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 14.5, color: Colors.amberAccent, width: 14)]),
                                BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 16.0, color: Colors.amberAccent, width: 14)]),
                                BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 18.5, color: Colors.amberAccent, width: 14)]),
                                BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 20.0, color: Colors.amberAccent, width: 14)]),
                              ],
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
    );
  }

  Widget _buildMetricCard(String title, String val, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.glassForestCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Text(subtitle, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.5))),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.8))),
            ],
          ),
        ],
      ),
    );
  }
}
