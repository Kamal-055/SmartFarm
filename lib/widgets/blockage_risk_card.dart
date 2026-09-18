import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/ai_prediction_model.dart';
import '../models/simulation_record.dart';

class BlockageRiskCard extends StatelessWidget {
  final BlockagePrediction blockagePrediction;
  final BlockageRecord blockageRecord;

  const BlockageRiskCard({
    super.key,
    required this.blockagePrediction,
    required this.blockageRecord,
  });

  @override
  Widget build(BuildContext context) {
    Color riskColor;
    Color bgLightColor;
    IconData riskIcon;
    String statusTitle;

    switch (blockagePrediction.riskLevel) {
      case BlockageRiskLevel.normal:
        riskColor = AppColors.secondary;
        bgLightColor = AppColors.secondaryLight;
        riskIcon = Icons.check_circle_outline_rounded;
        statusTitle = "NORMAL HAY FLOW";
        break;
      case BlockageRiskLevel.moderate:
        riskColor = AppColors.warning;
        bgLightColor = AppColors.warningBackground;
        riskIcon = Icons.warning_amber_rounded;
        statusTitle = "MODERATE FLOW DELAY";
        break;
      case BlockageRiskLevel.severe:
        riskColor = AppColors.error;
        bgLightColor = AppColors.errorBackground;
        riskIcon = Icons.report_problem_rounded;
        statusTitle = "CLOG DETECTED";
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: riskColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
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
          // 3-State Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: bgLightColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: riskColor.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Icon(riskIcon, color: riskColor, size: 26),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusTitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: riskColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        blockagePrediction.recommendedAction,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          const Text(
            'FEED FLOW SENSORS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),

          // Grid of Sensor Evidence Checklist
          Row(
            children: [
              Expanded(
                child: _buildCheckItem(
                  'IR Flow Sensor',
                  blockageRecord.irFlowDetected ? 'Detected' : 'Blocked / Idle',
                  blockageRecord.irFlowDetected,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildCheckItem(
                  'Hall Sensor',
                  blockageRecord.hallSensorGateOpen ? 'Gate Open' : 'Gate Closed',
                  blockageRecord.hallSensorGateOpen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildCheckItem(
                  'Vibration Motor',
                  blockagePrediction.vibratorActivated ? 'ACTIVE' : 'OFF',
                  !blockagePrediction.vibratorActivated,
                  accentColor: blockagePrediction.vibratorActivated ? AppColors.warning : AppColors.secondary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildCheckItem(
                  'Prev. Blockages',
                  '${blockageRecord.previousBlockageCount} Logged',
                  blockageRecord.previousBlockageCount == 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String title, String value, bool isPositive, {Color? accentColor}) {
    final statusColor = accentColor ?? (isPositive ? AppColors.secondary : AppColors.error);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
