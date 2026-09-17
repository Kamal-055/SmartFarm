import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/farm_provider.dart';
import '../../providers/settings_provider.dart';
import '../auth/login_screen.dart';
import '../sensors/live_sensors_screen.dart';
import 'system_overview_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final farmProvider = Provider.of<FarmProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    final farmerName = authProvider.user?.name ?? 'Green Valley Farmer';
    final farmerEmail = authProvider.user?.email ?? 'farmer@smartfodder.com';
    final farmName = farmProvider.farm.name;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('System Profile & Settings'),
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
                  // User Profile Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.glassForestCard,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.glassForestBorder),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primaryAccent.withValues(alpha: 0.2),
                          child: const Icon(Icons.person, color: AppColors.primaryAccent, size: 32),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                farmerName,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              Text(
                                farmerEmail,
                                style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7)),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryAccent.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'FARM: $farmName',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryAccent),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Simulation Mode Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.glassForestCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.science, color: AppColors.warning, size: 24),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SIMULATION MODE ACTIVE',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.warning),
                              ),
                              Text(
                                'Data streamed from sample dataset records for project demonstration.',
                                style: TextStyle(fontSize: 11, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: settingsProvider.isMockMode,
                          activeColor: AppColors.warning,
                          onChanged: (val) {
                            settingsProvider.setMockMode(val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // System Shortcuts & Info List
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.glassForestCard,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.glassForestBorder),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.developer_board, color: AppColors.primaryAccent),
                          title: const Text('IoT Hardware Architecture Diagram', style: TextStyle(color: Colors.white, fontSize: 14)),
                          subtitle: const Text('View ESP32, Servo, Load Cell & Sensor Flow', style: TextStyle(color: Colors.white60, fontSize: 11)),
                          trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const SystemOverviewScreen()),
                            );
                          },
                        ),
                        const Divider(color: Colors.white12, height: 1),
                        ListTile(
                          leading: const Icon(Icons.sensors, color: AppColors.primaryAccent),
                          title: const Text('Live Sensors Telemetry Cluster', style: TextStyle(color: Colors.white, fontSize: 14)),
                          subtitle: const Text('Inspect Ultrasonic, Load Cell, IR & Hall telemetry', style: TextStyle(color: Colors.white60, fontSize: 11)),
                          trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const LiveSensorsScreen()),
                            );
                          },
                        ),
                        const Divider(color: Colors.white12, height: 1),
                        ListTile(
                          leading: const Icon(Icons.psychology, color: AppColors.primaryAccent),
                          title: const Text('AI/ML Engine Information', style: TextStyle(color: Colors.white, fontSize: 14)),
                          subtitle: const Text('Random Forest Regressor & Classifier models', style: TextStyle(color: Colors.white60, fontSize: 11)),
                          trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorBackground,
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () async {
                        await authProvider.logout();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        }
                      },
                      icon: const Icon(Icons.logout, size: 20),
                      label: const Text('LOGOUT SYSTEM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
}
