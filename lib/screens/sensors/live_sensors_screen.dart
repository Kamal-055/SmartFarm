import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/fodder_inventory_provider.dart';
import '../../providers/simulation_provider.dart';
import '../../widgets/sensor_card.dart';

class LiveSensorsScreen extends StatelessWidget {
  const LiveSensorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<FodderInventoryProvider>(context);
    final simProvider = Provider.of<SimulationProvider>(context);

    final fodderKg = inventoryProvider.availableFodderKg;
    final troughWeightKg = simProvider.currentTroughWeightKg;
    final isFeeding = simProvider.isFeedingActive;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Equipment & Sensors',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.sensors_rounded, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Feeder Hardware Monitors',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Real-time readings from fodder silo, feed gate & trough scale',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  SensorCard(
                    title: 'Fodder Storage Bin',
                    value: fodderKg.toStringAsFixed(1),
                    unit: 'kg',
                    icon: Icons.inventory_2_rounded,
                    accentColor: AppColors.secondary,
                    subtitle: 'Fodder Silo Quantity',
                  ),
                  SensorCard(
                    title: 'Trough Scale',
                    value: troughWeightKg.toStringAsFixed(1),
                    unit: 'kg',
                    icon: Icons.scale_rounded,
                    accentColor: AppColors.primary,
                    subtitle: 'Cattle Trough Weight',
                  ),
                  SensorCard(
                    title: 'Feed-Flow Sensor',
                    value: isFeeding ? 'SMOOTH' : 'CLEAR',
                    unit: '',
                    icon: Icons.sensors_rounded,
                    accentColor: AppColors.secondary,
                    subtitle: 'Fodder Flow Movement',
                  ),
                  SensorCard(
                    title: 'Dispenser Gate',
                    value: isFeeding ? 'OPEN' : 'CLOSED',
                    unit: '',
                    icon: Icons.door_sliding_rounded,
                    accentColor: isFeeding ? AppColors.secondary : AppColors.textSecondary,
                    subtitle: 'Motorized Feed Door',
                  ),
                  SensorCard(
                    title: 'Gate Opening',
                    value: isFeeding ? '75' : '0',
                    unit: '%',
                    icon: Icons.tune_rounded,
                    accentColor: AppColors.primary,
                    subtitle: 'Fodder Dispense Aperture',
                  ),
                  SensorCard(
                    title: 'Flow Assister',
                    value: isFeeding ? 'ACTIVE' : 'READY',
                    unit: '',
                    icon: Icons.vibration_rounded,
                    accentColor: isFeeding ? AppColors.secondary : AppColors.secondary,
                    subtitle: 'Anti-Clogging Assist',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
