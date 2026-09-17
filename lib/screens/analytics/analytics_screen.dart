import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Smart Livestock Analytics'),
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
                  // Academic Honesty Disclaimer Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warningBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.science, color: AppColors.warning, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Demonstration Dataset — Analytics generated from simulated IoT telemetry stream.',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 1. Performance Metric Summary Cards
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.6,
                    children: [
                      _buildMetricCard('Total Feeding Cycles', '48', 'Cycles Executed', Icons.loop, AppColors.primaryAccent),
                      _buildMetricCard('Average Feed Qty', '1.15 kg', 'Per Dispense', Icons.balance, Colors.cyanAccent),
                      _buildMetricCard('Total Hay Dispensed', '55.2 kg', 'This Month', Icons.grass, AppColors.onlineGreen),
                      _buildMetricCard('Blockage Events', '2 Risk Logged', 'Mitigated Automatically', Icons.shield, Colors.orangeAccent),
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
                          'Feed Dispense Quantity History (Target vs Actual)',
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

                  // 3. Hopper Level Drift Chart
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
                          'Hopper Hay Level Drift (Ultrasonic HC-SR04)',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 14),

                        SizedBox(
                          height: 160,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 30,
                              barTouchData: BarTouchDataEnabled(false),
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
