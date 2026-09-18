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
      appBar: AppBar(
        title: const Text(
          'Feeding History Log',
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
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const EntryReveal(
                duration: Duration(milliseconds: 350),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Audit & Feeding Logs',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Audit log of automated scheduled and manual fodder feedings',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

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
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
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
                                duration: Duration(milliseconds: 300 + (index * 40)),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
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
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                    leading: Container(
                                      padding: const EdgeInsets.all(10),
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
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                                    ),
                                    subtitle: Text(
                                      '$timeStr\nDispensed: ${rec.actualQuantityKg.toStringAsFixed(1)} kg',
                                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: rec.status == 'Completed'
                                            ? AppColors.secondaryLight
                                            : AppColors.errorBackground,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        rec.status,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: rec.status == 'Completed'
                                              ? AppColors.secondary
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
      backgroundColor: AppColors.surface,
      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
    );
  }
}
