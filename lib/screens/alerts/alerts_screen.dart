import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SystemAlertItem {
  final String title;
  final String message;
  final String category; // Blockage, Feeding, System
  final String severity; // NORMAL, MODERATE, SEVERE
  final DateTime timestamp;
  final String recommendedAction;
  bool isRead;

  SystemAlertItem({
    required this.title,
    required this.message,
    required this.category,
    required this.severity,
    required this.timestamp,
    required this.recommendedAction,
    this.isRead = false,
  });
}

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _selectedCategory = 'All';

  final List<SystemAlertItem> _alerts = [
    SystemAlertItem(
      title: 'Severe Blockage Detected',
      message: 'IR flow broken and load-cell weight static during feed cycle #003.',
      category: 'Blockage',
      severity: 'SEVERE',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      recommendedAction: 'Corrective action initiated: Vibration ON & Gate increased to 55%.',
    ),
    SystemAlertItem(
      title: 'Moderate Blockage Warning',
      message: 'Hay flow delay detected during record #2 dispense.',
      category: 'Blockage',
      severity: 'MODERATE',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      recommendedAction: 'Preventive vibration motor pulse executed for 1.5s.',
    ),
    SystemAlertItem(
      title: 'Feeding Cycle Completed',
      message: 'Dispensed 1.20 kg successfully to Milking Herd trough.',
      category: 'Feeding',
      severity: 'NORMAL',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      recommendedAction: 'No action required.',
    ),
    SystemAlertItem(
      title: 'Hopper Low Level Warning',
      message: 'Ultrasonic sensor depth reading: 24.0 cm (Hopper < 25% capacity).',
      category: 'System',
      severity: 'MODERATE',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      recommendedAction: 'Refill gravity hopper with fresh fodder.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredAlerts = _selectedCategory == 'All'
        ? _alerts
        : _alerts.where((a) => a.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Smart Alert Center'),
        actions: [
          IconButton(
            tooltip: 'Clear All Alerts',
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () {
              setState(() => _alerts.clear());
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
              color: AppColors.background.withValues(alpha: 0.90),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 14, right: 14, top: 12, bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Blockage', 'Feeding', 'System'].map((cat) {
                        final isSel = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSel,
                            selectedColor: AppColors.primaryAccent,
                            backgroundColor: AppColors.glassForestCard,
                            labelStyle: TextStyle(
                              color: isSel ? AppColors.primaryDark : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            onSelected: (val) {
                              if (val) setState(() => _selectedCategory = cat);
                            },
                          ),
                        );
                      }).toList(),
                    ),
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
                          Text('No System Alerts', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('All hardware sensors and AI modules running normally.', style: TextStyle(color: Colors.white60, fontSize: 12)),
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

                        switch (item.severity) {
                          case 'SEVERE':
                            sevColor = AppColors.error;
                            icon = Icons.report_problem;
                            break;
                          case 'MODERATE':
                            sevColor = Colors.orangeAccent;
                            icon = Icons.warning_amber;
                            break;
                          case 'NORMAL':
                          default:
                            sevColor = AppColors.onlineGreen;
                            icon = Icons.check_circle_outline;
                            break;
                        }

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.glassForestCard,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: sevColor.withValues(alpha: 0.5), width: 1.2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(icon, color: sevColor, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        item.title,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: sevColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    item.severity,
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: sevColor),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(item.message, style: const TextStyle(fontSize: 12, color: Colors.white)),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Action: ${item.recommendedAction}',
                                  style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.8)),
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
        ],
      ),
    );
  }
}
