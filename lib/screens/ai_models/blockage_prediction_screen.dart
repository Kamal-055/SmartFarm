import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/simulation_provider.dart';
import '../../widgets/blockage_risk_card.dart';

class BlockagePredictionScreen extends StatelessWidget {
  const BlockagePredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final simProvider = Provider.of<SimulationProvider>(context);
    final blockagePred = simProvider.currentBlockagePrediction;
    final blockageRecord = simProvider.currentBlockageRecord;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Feed Flow & Safety'),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.glassForestCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.shield_outlined, color: AppColors.primaryAccent, size: 22),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'AUTOMATIC FLOW MONITORING',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryAccent,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Monitors hay flow continuously and activates automatic flow assistance if hay movement slows.',
                          style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3-State Risk Card
                  BlockageRiskCard(
                    blockagePrediction: blockagePred,
                    blockageRecord: blockageRecord,
                  ),
                  const SizedBox(height: 18),

                  // Scenario Selector
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.glassForestCard,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.glassForestBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SIMULATION FLOW SCENARIO TEST',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryAccent,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.onlineGreen.withValues(alpha: 0.2),
                                  foregroundColor: AppColors.onlineGreen,
                                  side: const BorderSide(color: AppColors.onlineGreen),
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  simProvider.triggerDemoNormal();
                                },
                                child: const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text('SMOOTH FLOW', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),

                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent.withValues(alpha: 0.2),
                                  foregroundColor: Colors.orangeAccent,
                                  side: const BorderSide(color: Colors.orangeAccent),
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  simProvider.triggerDemoModerateBlockage();
                                },
                                child: const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text('SLIGHT DELAY', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),

                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent.withValues(alpha: 0.2),
                                  foregroundColor: Colors.redAccent,
                                  side: const BorderSide(color: Colors.redAccent),
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  simProvider.triggerDemoSevereBlockage();
                                },
                                child: const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text('CLOG ALERT', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
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
