import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class PrototypeDiagramWidget extends StatelessWidget {
  const PrototypeDiagramWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.schema_rounded, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smart Cattle Feeder',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'How Gravity Fodder Dispenser Works',
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
                  'AUTOMATIC',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Central Feeder Control Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Intelligent Control Unit',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Automated Fodder Portioning & Cattle Monitoring',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Flow Steps
          _buildDiagramNode(
            step: '1',
            title: 'Fodder Storage Bin',
            subtitle: 'Stores dry fodder & monitors level with sensors',
            icon: Icons.inventory_2_rounded,
            color: AppColors.secondary,
          ),
          _buildConnectorLine(),
          _buildDiagramNode(
            step: '2',
            title: 'Motorized Feed Gate',
            subtitle: 'Opens precisely to release prescribed portion',
            icon: Icons.door_sliding_rounded,
            color: AppColors.primary,
          ),
          _buildConnectorLine(),
          _buildDiagramNode(
            step: '3',
            title: 'Feed-Flow Sensor',
            subtitle: 'Detects hay blockage & triggers flow assistant',
            icon: Icons.sensors_rounded,
            color: const Color(0xFF0EA5E9),
          ),
          _buildConnectorLine(),
          _buildDiagramNode(
            step: '4',
            title: 'Cattle Trough Scale',
            subtitle: 'Measures exact dispensed weight in real-time',
            icon: Icons.scale_rounded,
            color: AppColors.secondary,
          ),
          _buildConnectorLine(),
          _buildDiagramNode(
            step: '5',
            title: 'FodderFlow Mobile App',
            subtitle: 'Calculates optimal portion & alerts farmer instantly',
            icon: Icons.mobile_friendly_rounded,
            color: const Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagramNode({
    required String step,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(icon, color: color, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'STEP $step: ',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: color,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectorLine() {
    return Container(
      margin: const EdgeInsets.only(left: 32),
      height: 16,
      child: Row(
        children: [
          Container(
            width: 2,
            height: 16,
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_downward_rounded, color: AppColors.primary, size: 14),
        ],
      ),
    );
  }
}
