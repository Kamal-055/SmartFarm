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
    IconData riskIcon;
    String statusTitle;

    switch (blockagePrediction.riskLevel) {
      case BlockageRiskLevel.normal:
        riskColor = AppColors.success;
        riskIcon = Icons.check_circle_outline;
        statusTitle = "NORMAL FLOW";
        break;
      case BlockageRiskLevel.moderate:
        riskColor = AppColors.warning;
        riskIcon = Icons.warning_amber;
        statusTitle = "MODERATE BLOCKAGE RISK";
        break;
      case BlockageRiskLevel.severe:
        riskColor = AppColors.error;
        riskIcon = Icons.report_problem;
        statusTitle = "SEVERE BLOCKAGE RISK";
        break;
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.glassForestCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: riskColor.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: riskColor.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 3-State Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: riskColor.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: riskColor.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Icon(riskIcon, color: riskColor, size: 24),
                const SizedBox(width: 10),
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
                      Text(
                        blockagePrediction.recommendedAction,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'FEED FLOW MONITORING',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryAccent,
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
              const SizedBox(width: 8),
              Expanded(
                child: _buildCheckItem(
                  'Hall Position',
                  blockageRecord.hallSensorGateOpen ? 'Gate Open' : 'Gate Closed',
                  blockageRecord.hallSensorGateOpen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildCheckItem(
                  'Vibration Motor',
                  blockagePrediction.vibratorActivated ? 'ACTIVE' : 'OFF',
                  !blockagePrediction.vibratorActivated,
                  accentColor: blockagePrediction.vibratorActivated ? Colors.orangeAccent : Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
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
    final statusColor = accentColor ?? (isPositive ? AppColors.onlineGreen : AppColors.error);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
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
                  style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.6)),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
