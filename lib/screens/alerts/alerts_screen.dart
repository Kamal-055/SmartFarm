import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/alert_model.dart';
import '../../providers/alert_provider.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final alertProvider = Provider.of<AlertProvider>(context);
    final alerts = alertProvider.alerts;

    final filteredAlerts = _selectedCategory == 'All'
        ? alerts
        : alerts.where((a) {
            if (_selectedCategory == 'Feeding') return a.title.contains('Feed') || a.title.contains('Dispense');
            if (_selectedCategory == 'Fodder') return a.title.contains('Fodder') || a.title.contains('Storage') || a.title.contains('Refill');
            if (_selectedCategory == 'Alerts') return a.type == AlertType.critical || a.type == AlertType.warning;
            return true;
          }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (alertProvider.unreadCount > 0)
            TextButton(
              onPressed: () => alertProvider.markAllAsRead(),
              child: const Text('Mark Read', style: TextStyle(color: AppColors.primaryMedium, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 18, right: 18, top: 12, bottom: 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Chips (All, Feeding, Fodder, Alerts)
              Row(
                children: ['All', 'Feeding', 'Fodder', 'Alerts'].map((cat) {
                  final isSel = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
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
                        if (val) setState(() => _selectedCategory = cat);
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              if (filteredAlerts.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.notifications_off_outlined, color: AppColors.textMuted, size: 48),
                      SizedBox(height: 12),
                      Text('No Notifications', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('All systems are operating normally.', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredAlerts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = filteredAlerts[index];
                    Color iconBg;
                    Color iconColor;
                    IconData icon;

                    switch (item.type) {
                      case AlertType.critical:
                        iconBg = Colors.red.shade100;
                        iconColor = Colors.red.shade700;
                        icon = Icons.warning_amber_rounded;
                        break;
                      case AlertType.warning:
                        iconBg = Colors.amber.shade100;
                        iconColor = Colors.amber.shade800;
                        icon = Icons.sensors_rounded;
                        break;
                      case AlertType.info:
                        iconBg = AppColors.primaryLight;
                        iconColor = AppColors.primaryMedium;
                        icon = Icons.check_circle_rounded;
                        break;
                    }

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: item.read ? AppColors.border : AppColors.primaryAccent),
                        boxShadow: const [
                          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 3)),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: iconBg,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, color: iconColor, size: 20),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    if (!item.read)
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: AppColors.onlineGreen,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.message,
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _formatTime(item.timestamp),
                                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

