import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/device_provider.dart';
import '../../providers/farm_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/custom_dialogs.dart';
import '../../widgets/entry_reveal.dart';
import '../../widgets/primary_button.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final farmProvider = Provider.of<FarmProvider>(context);
    final deviceProvider = Provider.of<DeviceProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    final farm = farmProvider.farm;
    final device = deviceProvider.device;
    final isOnline = deviceProvider.isDeviceOnline;

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
              color: AppColors.background.withValues(alpha: 0.92),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
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
                          'Farm & System Settings',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Manage hardware connection, farm details & language',
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Farm Profile Section
                  EntryReveal(
                    duration: const Duration(milliseconds: 400),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Row(
                                    children: [
                                      Icon(Icons.agriculture, color: AppColors.primary, size: 22),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Farm Details',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 22),
                                  onPressed: () async {
                                    final result = await CustomDialogs.showEditFarmDialog(
                                      context,
                                      currentName: farm.name,
                                      currentCattleCount: farm.cattleCount,
                                    );
                                    if (result != null) {
                                      farmProvider.updateFarmDetails(
                                        name: result['name'],
                                        cattleCount: result['cattleCount'],
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                            const Divider(height: 16),
                            _buildInfoRow('Farm Name', farm.name),
                            _buildInfoRow('Cattle Count', '${farm.cattleCount} cows'),
                            _buildInfoRow('Farmer Name', authProvider.user?.name ?? 'Farmer'),
                            _buildInfoRow('Farmer Email', authProvider.user?.email ?? 'farmer@smartfodder.com'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ESP8266 Device Status Section
                  EntryReveal(
                    duration: const Duration(milliseconds: 450),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Row(
                                    children: [
                                      Icon(Icons.developer_board, color: AppColors.secondary, size: 22),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'IoT Dispenser Hardware',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isOnline ? AppColors.successBackground : AppColors.errorBackground,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    isOnline ? 'ONLINE' : 'OFFLINE',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isOnline ? AppColors.success : AppColors.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 16),
                            _buildInfoRow('Device ID', settingsProvider.activeDeviceId),
                            _buildInfoRow('Hardware Module', 'ESP8266 NodeMCU'),
                            _buildInfoRow('Gate Actuator', 'Servo Motor (0°-90°)'),
                            _buildInfoRow('Firmware Version', device?.system.firmwareVersion ?? 'v1.0.4'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Development Mode & Language Controls
                  EntryReveal(
                    duration: const Duration(milliseconds: 500),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.tune, color: AppColors.primary, size: 22),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Preferences & Mode',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 16),

                            // Development Mode Switch
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Development / Mock Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              subtitle: const Text('Simulate hardware without ESP8266', style: TextStyle(fontSize: 12)),
                              value: settingsProvider.isMockMode,
                              activeThumbColor: AppColors.warning,
                              onChanged: (val) {
                                settingsProvider.setMockMode(val);
                                deviceProvider.initDevice(settingsProvider.activeDeviceId, val);
                              },
                            ),
                            const SizedBox(height: 6),

                            // Language Dropdown
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('App Language', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                      Text('Select farmer language', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                DropdownButton<String>(
                                  value: settingsProvider.locale.languageCode,
                                  items: const [
                                    DropdownMenuItem(value: 'en', child: Text('English', style: TextStyle(fontSize: 14))),
                                    DropdownMenuItem(value: 'ta', child: Text('தமிழ்', style: TextStyle(fontSize: 14))),
                                    DropdownMenuItem(value: 'kn', child: Text('ಕನ್ನಡ', style: TextStyle(fontSize: 14))),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) {
                                      settingsProvider.setLanguage(val);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Logout Button
                  EntryReveal(
                    duration: const Duration(milliseconds: 550),
                    child: PrimaryButton(
                      text: 'LOGOUT OF FARM ACCOUNT',
                      icon: Icons.logout,
                      isSecondary: true,
                      backgroundColor: AppColors.error,
                      textColor: AppColors.error,
                      onPressed: () async {
                        await authProvider.logout();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
