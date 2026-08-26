import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/device_provider.dart';
import '../../providers/farm_provider.dart';
import '../../providers/history_provider.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/entry_reveal.dart';
import '../../widgets/feed_level_card.dart';
import '../../widgets/gate_control_card.dart';
import '../../widgets/status_badge.dart';
import '../gate_control/gate_control_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'All',
    'Main Hopper',
    'Milking Herd',
    'Calves Barn',
    'Timers',
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final farmProvider = Provider.of<FarmProvider>(context);
    final deviceProvider = Provider.of<DeviceProvider>(context);
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final historyProvider = Provider.of<HistoryProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    final farmerName = authProvider.user?.name ?? 'Green Valley Farmer';
    final farmName = farmProvider.farm.name;
    final device = deviceProvider.device;
    final isOnline = deviceProvider.isDeviceOnline;

    final nextSch = scheduleProvider.nextUpcomingSchedule;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background AI Aerial Farm Field Image with soft translucent overlay
          Positioned.fill(
            child: Image.asset(
              'assets/images/aerial_farm_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: AppColors.background.withValues(alpha: 0.88),
            ),
          ),

          // Main Dashboard Scroll Area
          RefreshIndicator(
            onRefresh: () async {
              deviceProvider.initDevice(settingsProvider.activeDeviceId, settingsProvider.isMockMode);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              // Increased bottom padding to 120px so content scrolls 100% clear of floating navbar
              padding: const EdgeInsets.only(left: 14, right: 14, top: 12, bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Weather & Farm Live Telemetry Glass Header Card (Overflow-proof)
                  EntryReveal(
                    duration: const Duration(milliseconds: 350),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.glassForestCard,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: AppColors.glassForestBorder,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Avatar & Greeting Header (Wrapped in Expanded)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: AppColors.primaryAccent.withValues(alpha: 0.2),
                                      child: const Icon(Icons.person, color: AppColors.primaryAccent, size: 22),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Hi, $farmerName',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white.withValues(alpha: 0.75),
                                            ),
                                          ),
                                          const Text(
                                            'Welcome back!',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              StatusBadge(
                                isOnline: isOnline,
                                onTap: settingsProvider.isMockMode
                                    ? () {
                                        deviceProvider.toggleMockHeartbeat(!isOnline);
                                      }
                                    : null,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Weather & Location Widget (Wrapped & Overflow-Proof)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined, color: AppColors.primaryAccent, size: 14),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            farmName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white.withValues(alpha: 0.9),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      '26°C',
                                      style: TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.wb_sunny_outlined, color: AppColors.primaryAccent, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        'Sunny / Clear',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Humidity: 76% | Wind: 11 km/h',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white.withValues(alpha: 0.75),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2. Horizontal Filter Categories Chips
                  EntryReveal(
                    duration: const Duration(milliseconds: 400),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_categories.length, (index) {
                          final isSelected = _selectedCategoryIndex == index;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedCategoryIndex = index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primaryAccent : Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isSelected ? AppColors.primaryAccent : AppColors.border,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primaryAccent.withValues(alpha: 0.4),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          )
                                        ]
                                      : [],
                                ),
                                child: Text(
                                  _categories[index],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Development Mode Banner
                  if (settingsProvider.isMockMode)
                    EntryReveal(
                      duration: const Duration(milliseconds: 420),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.warningBackground,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.science, color: AppColors.warning, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Development Mode: Simulating ESP8266 servo & feed sensor.',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.warning.withValues(alpha: 0.9),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // 3. Main Gate Control Card
                  EntryReveal(
                    duration: const Duration(milliseconds: 450),
                    child: device != null
                        ? GateControlCard(
                            gate: device.gate,
                            isOnline: isOnline,
                            onOpenPressed: () {
                              deviceProvider.openGate(isMockMode: settingsProvider.isMockMode);
                            },
                            onClosePressed: () {
                              deviceProvider.closeGate(isMockMode: settingsProvider.isMockMode);
                            },
                          )
                        : const Card(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                  ),
                  const SizedBox(height: 14),

                  // 4. Feed Hopper Level Card
                  EntryReveal(
                    duration: const Duration(milliseconds: 500),
                    child: device != null
                        ? FeedLevelCard(
                            feed: device.feed,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const GateControlScreen()),
                              );
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 14),

                  // 5. Summary Info Grid (Next Feeding & Today's Count)
                  EntryReveal(
                    duration: const Duration(milliseconds: 550),
                    child: Row(
                      children: [
                        // Next Feeding Card
                        Expanded(
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.alarm, color: AppColors.primary, size: 18),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          'Next Feeding',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    nextSch != null ? nextSch.time : 'No Schedule',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    nextSch != null ? nextSch.name : 'Tap schedule tab',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Today's Feedings Card
                        Expanded(
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.check_circle_outline, color: AppColors.success, size: 18),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          'Today\'s Feedings',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${historyProvider.todayCompletedCount} Done',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${farmProvider.farm.cattleCount} cattle fed',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
