import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/history_provider.dart';
import '../../widgets/entry_reveal.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final records = historyProvider.records;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Farm Image Background with soft translucent overlay
          Positioned.fill(
            child: Image.asset(
              'assets/images/farm_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: AppColors.primaryDark.withValues(alpha: 0.88),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const EntryReveal(
                    duration: Duration(milliseconds: 350),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Feeding History',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Audit log of automated and manual fodder feedings',
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filter Segmented Chips
                  EntryReveal(
                    duration: const Duration(milliseconds: 400),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(context, 'Today', HistoryFilter.today, historyProvider),
                          const SizedBox(width: 8),
                          _buildFilterChip(context, 'This Week', HistoryFilter.thisWeek, historyProvider),
                          const SizedBox(width: 8),
                          _buildFilterChip(context, 'This Month', HistoryFilter.thisMonth, historyProvider),
                          const SizedBox(width: 8),
                          _buildFilterChip(context, 'All Time', HistoryFilter.all, historyProvider),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // History Record List
                  Expanded(
                    child: historyProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : (records.isEmpty
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.history_toggle_off, size: 64, color: AppColors.textMuted),
                                    SizedBox(height: 12),
                                    Text(
                                      'No Feeding Records Found',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: records.length,
                                itemBuilder: (context, index) {
                                  final rec = records[index];
                                  final timeStr = DateFormat('MMM d, yyyy • hh:mm a').format(rec.timestamp);

                                  return EntryReveal(
                                    duration: Duration(milliseconds: 400 + (index * 60)),
                                    child: Card(
                                      elevation: 2,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: const BorderSide(color: AppColors.border),
                                      ),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                        leading: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: rec.status == 'Completed'
                                                ? AppColors.primaryLight
                                                : AppColors.errorBackground,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            rec.type == 'Scheduled' ? Icons.alarm_on : Icons.touch_app,
                                            color: rec.status == 'Completed'
                                                ? AppColors.primary
                                                : AppColors.error,
                                            size: 22,
                                          ),
                                        ),
                                        title: Text(
                                          rec.title,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                        subtitle: Text(
                                          '$timeStr\nDuration: ${rec.durationSeconds} seconds',
                                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                        ),
                                        trailing: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: rec.status == 'Completed'
                                                ? AppColors.successBackground
                                                : AppColors.errorBackground,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            rec.status,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: rec.status == 'Completed'
                                                  ? AppColors.success
                                                  : AppColors.error,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    HistoryFilter filter,
    HistoryProvider provider,
  ) {
    final isSelected = provider.currentFilter == filter;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => provider.setFilter(filter),
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surfaceWarm,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
    );
  }
}
