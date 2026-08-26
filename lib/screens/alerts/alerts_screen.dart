import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/alert_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/alert_card.dart';
import '../../widgets/entry_reveal.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alertProvider = Provider.of<AlertProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final alerts = alertProvider.alerts;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('System Alerts & Notifications'),
        actions: [
          if (alerts.isNotEmpty)
            TextButton(
              onPressed: () {
                alertProvider.clearAll(
                  settingsProvider.activeDeviceId,
                  settingsProvider.isMockMode,
                );
              },
              child: const Text('CLEAR ALL', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
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
              color: AppColors.background.withValues(alpha: 0.92),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: alerts.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_off_outlined, size: 64, color: AppColors.textMuted),
                          SizedBox(height: 12),
                          Text(
                            'No Active System Alerts',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Your fodder dispenser is operating smoothly.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: alerts.length,
                      itemBuilder: (context, index) {
                        final item = alerts[index];
                        return EntryReveal(
                          duration: Duration(milliseconds: 350 + (index * 60)),
                          child: AlertCard(
                            alert: item,
                            onTap: () {
                              alertProvider.markAsRead(
                                settingsProvider.activeDeviceId,
                                item.id,
                                settingsProvider.isMockMode,
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
