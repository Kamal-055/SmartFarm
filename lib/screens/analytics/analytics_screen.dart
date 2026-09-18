import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../providers/history_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedTimeframe = 'Today';

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.horizontalPadding(context);
    final historyProvider = Provider.of<HistoryProvider>(context);

    final todayFeedKg = historyProvider.todayDispensedKgSum;
    final cyclesCount = historyProvider.todayCompletedCount;
    final flowAssistedCount = historyProvider.todayFlowAssistedCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Farm Insights'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: padding, right: padding, top: 12, bottom: 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Filter Chips: Today, This Week, This Month
              Row(
                children: ['Today', 'This Week', 'This Month'].map((tf) {
                  final isSel = _selectedTimeframe == tf;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(tf),
                      selected: isSel,
                      selectedColor: AppColors.primaryMedium,
                      backgroundColor: Colors.white,
                      side: BorderSide(color: isSel ? AppColors.primaryMedium : AppColors.border),
                      labelStyle: TextStyle(
                        color: isSel ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedTimeframe = tf);
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // 4 Summary Metric Cards (2x2 Grid)
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: [
                  _buildSummaryCard("Today's Feed", '${todayFeedKg.toStringAsFixed(1)} kg', Icons.grass_rounded, AppColors.primaryMedium),
                  _buildSummaryCard('Feeding Cycles', '$cyclesCount', Icons.loop_rounded, AppColors.primaryMedium),
                  _buildSummaryCard('Successful', '$cyclesCount', Icons.check_circle_rounded, AppColors.onlineGreen),
                  _buildSummaryCard('Feed Flow Issues', '$flowAssistedCount', Icons.warning_amber_rounded, Colors.orangeAccent.shade700),
                ],
              ),
              const SizedBox(height: 18),

              // 1. Feed Usage Bar Chart Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 3)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Feed Usage',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('1.4 kg peak', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryMedium)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      height: 160,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 3.0,
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            show: true,
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (val, meta) {
                                  switch (val.toInt()) {
                                    case 0:
                                      return const Text('6AM', style: TextStyle(fontSize: 10, color: AppColors.textMuted));
                                    case 1:
                                      return const Text('12PM', style: TextStyle(fontSize: 10, color: AppColors.textMuted));
                                    case 2:
                                      return const Text('6PM', style: TextStyle(fontSize: 10, color: AppColors.textMuted));
                                    default:
                                      return const Text('');
                                  }
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 1.2, color: AppColors.primaryMedium, width: 22, borderRadius: BorderRadius.circular(4))]),
                            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 0.8, color: AppColors.primaryMedium, width: 22, borderRadius: BorderRadius.circular(4))]),
                            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 1.4, color: AppColors.primaryMedium, width: 22, borderRadius: BorderRadius.circular(4))]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 2. Feed Flow Status Donut Pie Chart Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 3)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Feed Flow Status',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        SizedBox(
                          height: 120,
                          width: 120,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 32,
                              sections: [
                                PieChartSectionData(color: AppColors.onlineGreen, value: 85, radius: 18, showTitle: false),
                                PieChartSectionData(color: Colors.amber.shade700, value: 10, radius: 18, showTitle: false),
                                PieChartSectionData(color: Colors.red.shade600, value: 5, radius: 18, showTitle: false),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLegendItem('Normal', '85%', AppColors.onlineGreen),
                            const SizedBox(height: 8),
                            _buildLegendItem('Attention', '10%', Colors.amber.shade700),
                            const SizedBox(height: 8),
                            _buildLegendItem('Blocked', '5%', Colors.red.shade600),
                          ],
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
    );
  }

  Widget _buildSummaryCard(String title, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
          Text(val, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, String percent, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(width: 12),
        Text(percent, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }
}

