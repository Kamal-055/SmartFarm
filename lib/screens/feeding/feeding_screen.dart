import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/simulation_provider.dart';
import '../../widgets/feeding_progress_card.dart';

class FeedingScreen extends StatefulWidget {
  const FeedingScreen({super.key});

  @override
  State<FeedingScreen> createState() => _FeedingScreenState();
}

class _FeedingScreenState extends State<FeedingScreen> {
  bool _isManualMode = false;
  double _manualTargetKg = 1.0;

  @override
  Widget build(BuildContext context) {
    final simProvider = Provider.of<SimulationProvider>(context);
    final feedPred = simProvider.currentFeedPrediction;
    final blockagePred = simProvider.currentBlockagePrediction;

    final targetQty = _isManualMode ? _manualTargetKg : feedPred.predictedQuantityKg;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Smart Hay Dispenser Control'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            child: Chip(
              backgroundColor: AppColors.primaryDark,
              side: const BorderSide(color: AppColors.primaryAccent),
              label: Text(
                _isManualMode ? 'MANUAL' : 'AI AUTO',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryAccent),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background AI Aerial Farm Image with Dark Overlay
          Positioned.fill(
            child: Image.asset(
              'assets/images/aerial_farm_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: AppColors.background.withValues(alpha: 0.90),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 14, right: 14, top: 12, bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mode Selection Toggle (Automatic vs Manual)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.glassForestCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.glassForestBorder),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isManualMode = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: !_isManualMode ? AppColors.primaryAccent : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  '🤖 AI AUTOMATIC DISPENSE',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: !_isManualMode ? AppColors.primaryDark : Colors.white70,
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
                                color: _isManualMode ? AppColors.primaryAccent : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  '🖐️ MANUAL TARGET SLIDER',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _isManualMode ? AppColors.primaryDark : Colors.white70,
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

                  // If Manual Mode: Slider from 0.2 kg to 2.0 kg
                  if (_isManualMode) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.glassForestCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Select Target Quantity',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              Text(
                                '${_manualTargetKg.toStringAsFixed(2)} kg',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primaryAccent),
                              ),
                            ],
                          ),
                          Slider(
                            value: _manualTargetKg,
                            min: 0.2,
                            max: 2.0,
                            divisions: 18,
                            activeColor: AppColors.primaryAccent,
                            inactiveColor: Colors.black45,
                            label: '${_manualTargetKg.toStringAsFixed(2)} kg',
                            onChanged: (val) {
                              setState(() => _manualTargetKg = val);
                            },
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('0.2 kg (Light)', style: TextStyle(fontSize: 10, color: Colors.white60)),
                              Text('2.0 kg (Heavy)', style: TextStyle(fontSize: 10, color: Colors.white60)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Live Dispenser Hardware Animation Card
                  FeedingProgressCard(
                    targetQuantityKg: targetQty,
                    currentDispensedKg: simProvider.currentDispensedKg,
                    progressRatio: simProvider.dispenseProgress,
                    gateOpeningPercent: blockagePred.adjustedGateOpeningPercent,
                    gateTimeSeconds: feedPred.estimatedGateTimeSeconds,
                    isFeedingActive: simProvider.isFeedingActive,
                    onStart: () {
                      simProvider.executeFeedingCycle(_isManualMode ? _manualTargetKg : null);
                    },
                    onStop: () {
                      simProvider.stopFeedingCycle();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Real-Time Diagnostic Feed Status Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.glassForestCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.glassForestBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ACTUATOR TELEMETRY STATUS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryAccent,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Servo Motor (Gate):', style: TextStyle(fontSize: 12, color: Colors.white70)),
                            Text('${blockagePred.adjustedGateOpeningPercent}% Open', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Vibration Motor Status:', style: TextStyle(fontSize: 12, color: Colors.white70)),
                            Text(blockagePred.vibratorActivated ? 'ACTIVE (Mitigating Blockage)' : 'OFF', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: blockagePred.vibratorActivated ? Colors.orangeAccent : AppColors.onlineGreen)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Load Cell Weight Rate:', style: TextStyle(fontSize: 12, color: Colors.white70)),
                            const Text('+0.30 kg/s', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryAccent)),
                          ],
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
