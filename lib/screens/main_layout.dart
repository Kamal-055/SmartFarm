import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../providers/alert_provider.dart';
import '../providers/device_provider.dart';
import '../providers/history_provider.dart';
import '../providers/schedule_provider.dart';
import '../providers/settings_provider.dart';
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
    Provider.of<ScheduleProvider>(context, listen: false).initSchedules(deviceId, isMock);
    Provider.of<HistoryProvider>(context, listen: false).initHistory(deviceId, isMock);
    Provider.of<AlertProvider>(context, listen: false).initAlerts(deviceId, isMock);
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
    return Scaffold(
      extendBody: true,
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
                  width: 34,
                  height: 34,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              AppConstants.appName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.textPrimary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined, size: 24, color: AppColors.textPrimary),
            onPressed: () => setState(() => _currentIndex = 2),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, size: 24, color: AppColors.textPrimary),
            onPressed: () => setState(() => _currentIndex = 3),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      // Master 5-Tab Floating Glass Navigation Bar (Dashboard, Feeding, Analytics, Alerts, Profile)
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 68,
          margin: const EdgeInsets.only(left: 14, right: 14, bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.glassForestCard,
            borderRadius: BorderRadius.circular(36),
            border: Border.all(
              color: AppColors.glassForestBorder,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.grid_view_rounded, Icons.grid_view_outlined, 'Dashboard'),
              _buildNavItem(1, Icons.precision_manufacturing_rounded, Icons.precision_manufacturing_outlined, 'Feeding'),
              _buildNavItem(2, Icons.analytics_rounded, Icons.analytics_outlined, 'Analytics'),
              _buildNavItem(3, Icons.notifications_rounded, Icons.notifications_outlined, 'Alerts'),
              _buildNavItem(4, Icons.person_rounded, Icons.person_outlined, 'Profile'),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              size: 22,
              color: isSelected ? AppColors.primaryAccent : Colors.white.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primaryAccent : Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
