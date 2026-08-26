import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/device_model.dart';
import 'primary_button.dart';

class GateControlCard extends StatelessWidget {
  final GateStatus gate;
  final bool isOnline;
  final VoidCallback? onOpenPressed;
  final VoidCallback? onClosePressed;

  const GateControlCard({
    super.key,
    required this.gate,
    required this.isOnline,
    this.onOpenPressed,
    this.onClosePressed,
  });

  @override
  Widget build(BuildContext context) {
    final isOperating = gate.isOperating;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.sensor_door, color: AppColors.primary, size: 24),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Fodder Gate',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusChip(),
              ],
            ),
            const SizedBox(height: 14),
            
            // Visual Gate Animation / State Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _getBorderColor(), width: 1.5),
              ),
              child: Column(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isOperating
                        ? const SizedBox(
                            height: 44,
                            width: 44,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.5,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          )
                        : Icon(
                            gate.isOpen ? Icons.door_sliding_outlined : Icons.door_front_door,
                            size: 48,
                            key: ValueKey(gate.state),
                            color: gate.isOpen ? AppColors.primary : AppColors.secondary,
                          ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    gate.displayStatus,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _getTextColor(),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    !isOnline
                        ? "Feeding system offline"
                        : (isOperating
                            ? "Please wait..."
                            : (gate.isOpen ? "Ready to close" : "Ready to open")),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Controls
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: 'OPEN GATE',
                    icon: Icons.lock_open,
                    backgroundColor: AppColors.primary,
                    onPressed: (isOnline && !isOperating && gate.isClosed) ? onOpenPressed : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryButton(
                    text: 'CLOSE GATE',
                    icon: Icons.lock,
                    backgroundColor: AppColors.secondary,
                    onPressed: (isOnline && !isOperating && gate.isOpen) ? onClosePressed : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color bg;
    Color text;
    String label;

    switch (gate.state) {
      case GateState.open:
        bg = AppColors.successBackground;
        text = AppColors.success;
        label = "OPEN";
        break;
      case GateState.opening:
        bg = AppColors.warningBackground;
        text = AppColors.warning;
        label = "OPENING";
        break;
      case GateState.closing:
        bg = AppColors.warningBackground;
        text = AppColors.warning;
        label = "CLOSING";
        break;
      case GateState.error:
        bg = AppColors.errorBackground;
        text = AppColors.error;
        label = "ERROR";
        break;
      case GateState.closed:
        bg = AppColors.surfaceWarm;
        text = AppColors.textSecondary;
        label = "CLOSED";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: text),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (gate.state) {
      case GateState.open:
        return AppColors.primaryLight;
      case GateState.opening:
      case GateState.closing:
        return AppColors.warningBackground;
      case GateState.error:
        return AppColors.errorBackground;
      case GateState.closed:
        return AppColors.surfaceWarm;
    }
  }

  Color _getBorderColor() {
    switch (gate.state) {
      case GateState.open:
        return AppColors.primary;
      case GateState.opening:
      case GateState.closing:
        return AppColors.warning;
      case GateState.error:
        return AppColors.error;
      case GateState.closed:
        return AppColors.border;
    }
  }

  Color _getTextColor() {
    switch (gate.state) {
      case GateState.open:
        return AppColors.primaryDark;
      case GateState.opening:
      case GateState.closing:
        return AppColors.warning;
      case GateState.error:
        return AppColors.error;
      case GateState.closed:
        return AppColors.textPrimary;
    }
  }
}
