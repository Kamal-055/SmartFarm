import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/fodder_inventory_provider.dart';
import '../../providers/simulation_provider.dart';
import '../../widgets/prototype_diagram_widget.dart';

class SystemOverviewScreen extends StatelessWidget {
  const SystemOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<FodderInventoryProvider>(context);
    final simProvider = Provider.of<SimulationProvider>(context);

    final currentFodderKg = inventoryProvider.availableFodderKg;
    final maxFodderKg = inventoryProvider.totalCapacityKg;
    final fodderPercent = inventoryProvider.availablePercentage;
    final troughWeightKg = simProvider.currentTroughWeightKg;
    final isFeeding = simProvider.isFeedingActive;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'System Status & Architecture',
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
              // System Health Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.secondaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'All Systems Operational',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Smart Cattle Feeder connected & online',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'ONLINE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: 14),

                    // Component Checklist
                    _buildCheckItem(
                      label: 'Fodder Silo Bin Level',
                      value: '${(fodderPercent * 100).toStringAsFixed(0)}% (${currentFodderKg.toStringAsFixed(1)} kg of ${maxFodderKg.toStringAsFixed(0)} kg)',
                      status: 'OK',
                      isGood: true,
                    ),
                    const SizedBox(height: 10),
                    _buildCheckItem(
                      label: 'Motorized Feed Gate',
                      value: isFeeding ? 'Dispensing Port Open' : 'Securely Closed',
                      status: 'OK',
                      isGood: true,
                    ),
                    const SizedBox(height: 10),
                    _buildCheckItem(
                      label: 'Hay Feed-Flow Sensor',
                      value: isFeeding ? 'Dispensing Fodder' : 'Clear & Idle',
                      status: 'OK',
                      isGood: true,
                    ),
                    const SizedBox(height: 10),
                    _buildCheckItem(
                      label: 'Trough Scale Sensor',
                      value: '${troughWeightKg.toStringAsFixed(1)} kg in Trough',
                      status: 'OK',
                      isGood: true,
                    ),
                    const SizedBox(height: 10),
                    _buildCheckItem(
                      label: 'Smart Portion Engine',
                      value: 'Optimal Portion Active',
                      status: 'OK',
                      isGood: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Prototype / How It Works Diagram Widget
              const PrototypeDiagramWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckItem({
    required String label,
    required String value,
    required String status,
    required bool isGood,
  }) {
    return Row(
      children: [
        Icon(
          isGood ? Icons.check_circle_outline_rounded : Icons.warning_amber_rounded,
          color: isGood ? AppColors.secondary : AppColors.warning,
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: isGood ? AppColors.secondaryLight : AppColors.warningBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isGood ? AppColors.secondary : AppColors.warning,
            ),
          ),
        ),
      ],
    );
  }
}
