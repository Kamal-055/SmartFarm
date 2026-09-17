import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/farm_provider.dart';
import '../../providers/settings_provider.dart';
import '../ai_models/ai_feed_prediction_screen.dart';
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
        title: const Text('Farm Profile & Preferences'),
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
                          child: const Icon(Icons.agriculture_rounded, color: AppColors.primaryAccent, size: 32),
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
                              const SizedBox(height: 6),
                              Row(
                                children: [
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
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.onlineGreen.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      '25 CATTLE',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onlineGreen),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // System Status Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.glassForestCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.onlineGreen.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.verified, color: AppColors.onlineGreen, size: 24),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AUTOMATIC FEEDING SYSTEM ACTIVE',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onlineGreen),
                              ),
                              Text(
                                'Connected & operating under automatic smart feeding mode.',
                                style: TextStyle(fontSize: 11, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: settingsProvider.isMockMode,
                          activeThumbColor: AppColors.onlineGreen,
                          onChanged: (val) {
                            settingsProvider.setMockMode(val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Farmer Shortcuts & Info List
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.glassForestCard,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.glassForestBorder),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.schema_outlined, color: AppColors.primaryAccent),
                          title: const Text('How Smart Feeding Works', style: TextStyle(color: Colors.white, fontSize: 14)),
                          subtitle: const Text('View simple visual system flow & automatic operation', style: TextStyle(color: Colors.white60, fontSize: 11)),
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
                          title: const Text('Equipment & Component Status', style: TextStyle(color: Colors.white, fontSize: 14)),
                          subtitle: const Text('Check storage bin, trough scale & gate status', style: TextStyle(color: Colors.white60, fontSize: 11)),
                          trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const LiveSensorsScreen()),
                            );
                          },
                        ),
                        const Divider(color: Colors.white12, height: 1),
                        ListTile(
                          leading: const Icon(Icons.auto_awesome, color: AppColors.primaryAccent),
                          title: const Text('Smart Recommendation Details', style: TextStyle(color: Colors.white, fontSize: 14)),
                          subtitle: const Text('View daily feed targets tailored for your cattle', style: TextStyle(color: Colors.white60, fontSize: 11)),
                          trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const AIFeedPredictionScreen()),
                            );
                          },
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
                      label: const Text('LOG OUT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
