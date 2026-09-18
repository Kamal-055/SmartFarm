import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/custom_dialogs.dart';
import '../../widgets/entry_reveal.dart';
import '../../widgets/schedule_card.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    final deviceId = settingsProvider.activeDeviceId;
    final isMock = settingsProvider.isMockMode;

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EntryReveal(
                    duration: const Duration(milliseconds: 350),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Feeding Schedules',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Automatic gravity dispensing timers',
                                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result = await CustomDialogs.showAddScheduleDialog(context);
                            if (result != null) {
                              scheduleProvider.addSchedule(
                                deviceId: deviceId,
                                name: result['name'],
                                timeOfDay: result['timeOfDay'],
                                durationSeconds: result['durationSeconds'],
                                isMockMode: isMock,
                              );
                            }
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textLight,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            minimumSize: const Size(76, 40),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: scheduleProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : (scheduleProvider.schedules.isEmpty
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.alarm_off, size: 64, color: AppColors.textMuted),
                                    SizedBox(height: 12),
                                    Text(
                                      'No Feeding Schedules Created',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Tap "+ Add" to create an automated timer.',
                                      style: TextStyle(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: scheduleProvider.schedules.length,
                                itemBuilder: (context, index) {
                                  final sch = scheduleProvider.schedules[index];
                                  return EntryReveal(
                                    duration: Duration(milliseconds: 400 + (index * 80)),
                                    child: ScheduleCard(
                                      schedule: sch,
                                      onToggle: (val) {
                                        scheduleProvider.toggleSchedule(sch);
                                      },
                                      onDelete: () {
                                        scheduleProvider.deleteSchedule(sch.id);
                                      },
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
}
