import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/alert_provider.dart';
import '../providers/device_provider.dart';
import '../providers/fodder_inventory_provider.dart';
import '../providers/history_provider.dart';
import '../providers/schedule_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/simulation_provider.dart';
import 'alerts/alerts_screen.dart';
import 'analytics/analytics_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'feeding/feeding_screen.dart';
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
    final sch = Provider.of<ScheduleProvider>(context, listen: false);
    final hist = Provider.of<HistoryProvider>(context, listen: false);
    final alert = Provider.of<AlertProvider>(context, listen: false);
    final inv = Provider.of<FodderInventoryProvider>(context, listen: false);
    final sim = Provider.of<SimulationProvider>(context, listen: false);

    sch.initSchedules(deviceId, isMock);
    hist.initHistory(deviceId, isMock);
    alert.initAlerts(deviceId, isMock);

    // Start central background scheduler tick
    sim.startBackgroundScheduler(
      scheduleProvider: sch,
      inventoryProvider: inv,
      historyProvider: hist,
      alertProvider: alert,
    );
  }

  final List<Widget> _pages = const [
    DashboardScreen(),
    FeedingScreen(),
    AnalyticsScreen(),
    AlertsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final alertProvider = Provider.of<AlertProvider>(context);
    final toastAlert = alertProvider.latestToastAlert;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),

          // Floating WhatsApp-style In-App Notification Toast Banner
          if (toastAlert != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 14,
              right: 14,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccent.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications_active, color: AppColors.primaryAccent, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              toastAlert.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            Text(
                              toastAlert.message,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white54, size: 18),
                        onPressed: () => alertProvider.clearToastAlert(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),

      // Master 5-Tab Clean White Floating Navigation Bar
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 64,
          margin: const EdgeInsets.only(left: 14, right: 14, bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: AppColors.border,
              width: 1.0,
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Home')),
              Expanded(child: _buildNavItem(1, Icons.grass_rounded, Icons.grass_outlined, 'Feeding')),
              Expanded(child: _buildNavItem(2, Icons.insights_rounded, Icons.insights_outlined, 'Insights')),
              Expanded(child: _buildNavItem(3, Icons.notifications_rounded, Icons.notifications_outlined, 'Alerts')),
              Expanded(child: _buildNavItem(4, Icons.person_rounded, Icons.person_outlined, 'Profile')),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              size: 22,
              color: isSelected ? AppColors.primaryMedium : AppColors.textMuted,
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.primaryMedium : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
