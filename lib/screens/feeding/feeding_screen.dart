import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/alert_provider.dart';
import '../../providers/fodder_inventory_provider.dart';
import '../../providers/history_provider.dart';
import '../../providers/simulation_provider.dart';
import '../history/history_screen.dart';

class FeedingScreen extends StatefulWidget {
  const FeedingScreen({super.key});

  @override
  State<FeedingScreen> createState() => _FeedingScreenState();
}

class _FeedingScreenState extends State<FeedingScreen> {
  bool _isManualMode = false;
  double _manualTargetKg = 1.20;

  @override
  Widget build(BuildContext context) {
    final simProvider = Provider.of<SimulationProvider>(context);
    final inventoryProvider = Provider.of<FodderInventoryProvider>(context);
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);
    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);

    final isFeeding = simProvider.isFeedingActive;
    final isComplete = !isFeeding && simProvider.feedingStatusText == 'Complete ✓';
    final targetQty = _isManualMode ? _manualTargetKg : simProvider.currentFeedPrediction.predictedQuantityKg;
    final remainingKg = inventoryProvider.availableFodderKg;

    // 1. FEEDING COMPLETE STATE (4th Screen in Reference UI)
    if (isComplete) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Feeding Complete'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // Top Success Header Badge
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primaryAccent),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.check_circle_rounded, color: AppColors.onlineGreen, size: 52),
                      SizedBox(height: 10),
                      Text(
                        'Feeding Complete!',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Your cattle have been fed successfully',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Cattle Eating Graphic Container
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2EBE4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🐄 🌾 🐄', style: TextStyle(fontSize: 36)),
                        SizedBox(height: 6),
                        Text('Cattle Trough Feeding Area', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // 2x2 Metric Summary Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    _buildMetricCard('Target Quantity', '${targetQty.toStringAsFixed(2)} kg'),
                    _buildMetricCard('Dispensed Quantity', '${simProvider.currentDispensedKg.toStringAsFixed(2)} kg'),
                    _buildMetricCard('Time Taken', '3.8 seconds'),
                    _buildMetricCard('Fodder Remaining', '${remainingKg.toStringAsFixed(1)} kg'),
                  ],
                ),
                const SizedBox(height: 24),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryMedium,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const HistoryScreen()),
                      );
                    },
                    child: const Text('View Feeding History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryMedium,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.primaryMedium, width: 1.8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    onPressed: () => simProvider.stopFeedingCycle(),
                    child: const Text('Back to Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 2. FEEDING IN PROGRESS STATE (3rd Screen in Reference UI)
    if (isFeeding) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Feeding in Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Your cattle are being fed', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // Top Visual: Silo Dispensing Hay into Trough
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const [
                      BoxShadow(color: AppColors.cardShadow, blurRadius: 16, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Floating Fodder Remaining Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Fodder Remaining: ${remainingKg.toStringAsFixed(1)} kg of 10 kg',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryMedium),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text('🌾 🌾 🌾', style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 4),
                      const Text('🐄 Dispensing Fodder 🐄', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Dispensing Progress Card (0.84 / 1.20 kg - 70%)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const [
                      BoxShadow(color: AppColors.cardShadow, blurRadius: 16, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Dispensing Fodder...', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                              const SizedBox(height: 4),
                              Text(
                                '${simProvider.currentDispensedKg.toStringAsFixed(2)} / ${targetQty.toStringAsFixed(2)} kg',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          Text(
                            '${(simProvider.dispenseProgress * 100).toInt()}%',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primaryMedium),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: simProvider.dispenseProgress,
                          minHeight: 12,
                          backgroundColor: const Color(0xFFE5EFE7),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryMedium),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Step-by-Step Checklist
                      _buildCheckStep('Preparing feed...', simProvider.dispenseProgress >= 0.1),
                      _buildCheckStep('Opening gate...', simProvider.dispenseProgress >= 0.25),
                      _buildCheckStep('Dispensing fodder...', simProvider.dispenseProgress >= 0.4),
                      _buildCheckStep('Checking feed flow...', simProvider.dispenseProgress >= 0.75),
                      _buildCheckStep('Almost done...', simProvider.dispenseProgress >= 0.95),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Red [ Stop Feeding ] Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    onPressed: () => simProvider.stopFeedingCycle(),
                    child: const Text('Stop Feeding', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 3. IDLE FEED SELECTION STATE
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Feed Your Cattle'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 18, right: 18, top: 12, bottom: 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Smart Recommended vs Custom Quantity Toggle
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isManualMode = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !_isManualMode ? AppColors.primaryMedium : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'SMART RECOMMEND',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: !_isManualMode ? Colors.white : AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isManualMode = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _isManualMode ? AppColors.primaryMedium : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'CUSTOM QUANTITY',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: _isManualMode ? Colors.white : AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Target Stepper & Slider Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: Offset(0, 3)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _isManualMode ? 'Custom Target' : 'Recommended Target',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        Text(
                          '${targetQty.toStringAsFixed(2)} kg',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primaryMedium),
                        ),
                      ],
                    ),
                    if (_isManualMode) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: AppColors.primaryMedium, size: 28),
                            onPressed: () {
                              setState(() {
                                if (_manualTargetKg > 0.3) _manualTargetKg -= 0.1;
                              });
                            },
                          ),
                          Expanded(
                            child: Slider(
                              value: _manualTargetKg.clamp(0.2, 2.5),
                              min: 0.2,
                              max: 2.5,
                              divisions: 23,
                              activeColor: AppColors.primaryMedium,
                              inactiveColor: const Color(0xFFE5EFE7),
                              label: '${_manualTargetKg.toStringAsFixed(2)} kg',
                              onChanged: (val) {
                                setState(() => _manualTargetKg = val);
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryMedium, size: 28),
                            onPressed: () {
                              setState(() {
                                if (_manualTargetKg < 2.5) _manualTargetKg += 0.1;
                              });
                            },
                          ),
                        ],
                      ),
                    ]
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Start Feeding Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryMedium,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  onPressed: () {
                    final success = simProvider.executeFeedingCycle(
                      inventoryProvider: inventoryProvider,
                      historyProvider: historyProvider,
                      alertProvider: alertProvider,
                      manualTargetKg: _isManualMode ? _manualTargetKg : null,
                    );

                    if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Not enough fodder available in hopper! Please refill.'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.play_arrow_rounded, size: 22),
                  label: const Text('Start Feeding', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckStep(String text, bool isDone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: isDone ? AppColors.onlineGreen : AppColors.textMuted,
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
              color: isDone ? AppColors.textPrimary : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String val) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text(val, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

