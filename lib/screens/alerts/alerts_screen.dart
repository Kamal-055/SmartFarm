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
            if (_selectedCategory == 'Flow') return a.title.contains('Flow') || a.title.contains('Blockage');
            if (_selectedCategory == 'Storage') return a.title.contains('Storage') || a.title.contains('Hopper');
            return true;
          }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Farm Notifications'),
        actions: [
          if (alertProvider.unreadCount > 0)
            TextButton.icon(
              onPressed: () => alertProvider.markAllAsRead(),
              icon: const Icon(Icons.done_all, color: AppColors.primaryAccent, size: 18),
              label: const Text('Mark Read', style: TextStyle(color: AppColors.primaryAccent, fontSize: 12)),
            ),
          IconButton(
            tooltip: 'Clear All',
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () {
              alertProvider.clearAll('DEV_DEVICE', true);
            },
          ),
        ],
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
              padding: const EdgeInsets.only(left: 14, right: 14, top: 12, bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['All', 'Feeding', 'Flow', 'Storage'].map((cat) {
                      final isSel = _selectedCategory == cat;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSel,
                        selectedColor: AppColors.primaryAccent,
                        backgroundColor: AppColors.glassForestCard,
                        labelStyle: TextStyle(
                          color: isSel ? AppColors.primaryDark : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedCategory = cat);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  if (filteredAlerts.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.glassForestCard,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.notifications_off_outlined, color: Colors.white54, size: 48),
                          SizedBox(height: 12),
                          Text('No Farm Notifications', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('All feeding systems are running smoothly.', style: TextStyle(color: Colors.white60, fontSize: 12)),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredAlerts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = filteredAlerts[index];
                        Color sevColor;
                        IconData icon;

                        switch (item.type) {
                          case AlertType.critical:
                            sevColor = AppColors.error;
                            icon = Icons.report_problem;
                            break;
                          case AlertType.warning:
                            sevColor = Colors.orangeAccent;
                            icon = Icons.warning_amber;
                            break;
                          case AlertType.info:
                            sevColor = AppColors.onlineGreen;
                            icon = Icons.check_circle_outline;
                            break;
                        }

                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: item.read ? AppColors.glassForestCard : AppColors.glassForestCard.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: item.read ? sevColor.withValues(alpha: 0.3) : sevColor,
                              width: item.read ? 1.0 : 1.5,
                            ),
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
                                        Icon(icon, color: sevColor, size: 18),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: sevColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatTime(item.timestamp),
                                    style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.6)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(item.message, style: const TextStyle(fontSize: 12, color: Colors.white)),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
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
