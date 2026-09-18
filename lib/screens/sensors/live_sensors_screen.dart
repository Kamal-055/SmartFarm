import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/simulation_provider.dart';
import '../../widgets/sensor_card.dart';

class LiveSensorsScreen extends StatelessWidget {
  const LiveSensorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final simProvider = Provider.of<SimulationProvider>(context);
    final feedRecord = simProvider.currentFeedRecord;
    final blockageRecord = simProvider.currentBlockageRecord;
    final blockagePred = simProvider.currentBlockagePrediction;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Equipment Status'),
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
              color: AppColors.primaryDark.withValues(alpha: 0.88),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 14, right: 14, top: 12, bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.glassForestCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.sensors, color: AppColors.primaryAccent, size: 22),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'FARM FEEDER COMPONENTS',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              Text(
                                'Continuous live monitoring of fodder storage, gate & trough scale',
                                style: TextStyle(fontSize: 11, color: AppColors.primaryAccent),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.35,
                    children: [
                      SensorCard(
                        title: 'Fodder Bin Level',
                        value: feedRecord.hopperLevelCm.toStringAsFixed(1),
                        unit: 'cm',
                        icon: Icons.inventory_2_outlined,
                        accentColor: Colors.amberAccent,
                        subtitle: 'Storage Capacity Depth',
                      ),
                      SensorCard(
                        title: 'Trough Feed Scale',
                        value: feedRecord.troughWeightBeforeKg.toStringAsFixed(2),
                        unit: 'kg',
                        icon: Icons.scale_outlined,
                        accentColor: Colors.cyanAccent,
                        subtitle: 'Current Trough Weight',
                      ),
                      SensorCard(
                        title: 'Feed Flow Sensor',
                        value: blockageRecord.irFlowDetected ? 'SMOOTH' : 'CHECKING',
                        unit: '',
                        icon: Icons.sensors,
                        accentColor: blockageRecord.irFlowDetected ? AppColors.onlineGreen : Colors.orangeAccent,
                        subtitle: 'Fodder Flow Movement',
                      ),
                      SensorCard(
                        title: 'Dispenser Gate',
                        value: blockageRecord.hallSensorGateOpen ? 'GATE OPEN' : 'CLOSED',
                        unit: '',
                        icon: Icons.pin_drop,
                        accentColor: blockageRecord.hallSensorGateOpen ? AppColors.onlineGreen : Colors.grey,
                        subtitle: 'Feed Release Door',
                      ),
                      SensorCard(
                        title: 'Gate Opening',
                        value: blockagePred.adjustedGateOpeningPercent.toStringAsFixed(0),
                        unit: '%',
                        icon: Icons.door_sliding_outlined,
                        accentColor: AppColors.primaryAccent,
                        subtitle: 'Fodder Release Opening',
                      ),
                      SensorCard(
                        title: 'Flow Assister',
                        value: blockagePred.vibratorActivated ? 'ACTIVE' : 'READY',
                        unit: '',
                        icon: Icons.vibration,
                        accentColor: blockagePred.vibratorActivated ? Colors.orangeAccent : AppColors.onlineGreen,
                        subtitle: 'Automatic Anti-Clog',
                      ),
                    ],
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
