import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../providers/alert_provider.dart';
import '../providers/device_provider.dart';
import '../providers/history_provider.dart';
import '../providers/schedule_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/custom_dialogs.dart';
import 'alerts/alerts_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'history/history_screen.dart';
import 'schedule/schedule_screen.dart';
import 'settings/settings_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initDataStreams();
    });
  }

  void _initDataStreams() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final deviceId = settings.activeDeviceId;
    final isMock = settings.isMockMode;

    Provider.of<DeviceProvider>(context, listen: false).initDevice(deviceId, isMock);
    Provider.of<ScheduleProvider>(context, listen: false).initSchedules(deviceId, isMock);
    Provider.of<HistoryProvider>(context, listen: false).initHistory(deviceId, isMock);
    Provider.of<AlertProvider>(context, listen: false).initAlerts(deviceId, isMock);
  }

  final List<Widget> _pages = const [
    DashboardScreen(),
    ScheduleScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final alertProvider = Provider.of<AlertProvider>(context);

    return Scaffold(
      extendBody: true, // Allows floating navbar to sit over background seamlessly
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryAccent.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              AppConstants.appName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.textPrimary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, size: 28, color: AppColors.textPrimary),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AlertsScreen()),
                  );
                },
              ),
              if (alertProvider.unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '${alertProvider.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      // Ultra-Modern Floating Glass Pill Navigation Bar (Matching Reference Image)
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 68,
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.glassForestCard,
            borderRadius: BorderRadius.circular(36),
            border: Border.all(
              color: AppColors.glassForestBorder,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Home'),
              _buildNavItem(1, Icons.schedule_rounded, Icons.schedule_outlined, 'Schedule'),
              
              // Central Quick Action Button (+) matching reference UI
              GestureDetector(
                onTap: () async {
                  final scheduleProvider = Provider.of<ScheduleProvider>(context, listen: false);
                  final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
                  final result = await CustomDialogs.showAddScheduleDialog(context);
                  if (result != null) {
                    scheduleProvider.addSchedule(
                      deviceId: settingsProvider.activeDeviceId,
                      name: result['name'],
                      timeOfDay: result['timeOfDay'],
                      durationSeconds: result['durationSeconds'],
                      isMockMode: settingsProvider.isMockMode,
                    );
                  }
                },
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryAccent.withValues(alpha: 0.5),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: AppColors.primaryDark,
                    size: 28,
                  ),
                ),
              ),

              _buildNavItem(2, Icons.history_rounded, Icons.history_outlined, 'History'),
              _buildNavItem(3, Icons.settings_rounded, Icons.settings_outlined, 'Settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Icon(
          isSelected ? activeIcon : inactiveIcon,
          size: 26,
          color: isSelected ? AppColors.primaryAccent : Colors.white.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
