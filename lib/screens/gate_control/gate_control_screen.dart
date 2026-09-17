import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/device_model.dart';
import '../../providers/device_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/entry_reveal.dart';
import '../../widgets/primary_button.dart';

class GateControlScreen extends StatelessWidget {
  const GateControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    final device = deviceProvider.device;
    final isOnline = deviceProvider.isDeviceOnline;
    final gate = device?.gate;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manual Gate Control'),
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
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // Gate Status Visual Container
                  Expanded(
                    child: EntryReveal(
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.border, width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.cardShadow,
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Servo Gate Animation Graphic
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                color: _getBgColor(gate?.state),
                                shape: BoxShape.circle,
                                border: Border.all(color: _getBorderColor(gate?.state), width: 3),
                              ),
                              child: Center(
                                child: gate?.isOperating == true
                                    ? const SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 4,
                                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                        ),
                                      )
                                    : Icon(
                                        gate?.isOpen == true ? Icons.door_sliding_outlined : Icons.door_front_door,
                                        size: 72,
                                        color: gate?.isOpen == true ? AppColors.primary : AppColors.secondary,
                                      ),
                              ),
                            ),
                            const SizedBox(height: 28),

                            Text(
                              gate?.displayStatus ?? 'Gate Closed',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),

                            Text(
                              !isOnline
                                  ? 'System is offline. Hardware not responding.'
                                  : (gate?.isOperating == true
                                      ? 'Hardware servo moving slowly...'
                                      : (gate?.isOpen == true
                                          ? 'Fodder chute is fully open'
                                          : 'Fodder chute is closed')),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Control Buttons
                  EntryReveal(
                    duration: const Duration(milliseconds: 450),
                    child: Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            text: 'OPEN GATE',
                            icon: Icons.lock_open,
                            backgroundColor: AppColors.primary,
                            onPressed: (isOnline && gate != null && !gate.isOperating && gate.isClosed)
                                ? () {
                                    deviceProvider.openGate(isMockMode: settingsProvider.isMockMode);
                                  }
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(
                            text: 'CLOSE GATE',
                            icon: Icons.lock,
                            backgroundColor: AppColors.secondary,
                            onPressed: (isOnline && gate != null && !gate.isOperating && gate.isOpen)
                                ? () {
                                    deviceProvider.closeGate(isMockMode: settingsProvider.isMockMode);
                                  }
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBgColor(GateState? state) {
    if (state == GateState.open) return AppColors.primaryLight;
    if (state == GateState.opening || state == GateState.closing) return AppColors.warningBackground;
    return AppColors.surfaceWarm;
  }

  Color _getBorderColor(GateState? state) {
    if (state == GateState.open) return AppColors.primary;
    if (state == GateState.opening || state == GateState.closing) return AppColors.warning;
    return AppColors.border;
  }
}
