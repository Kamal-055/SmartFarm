import '../models/simulation_record.dart';

class SimulationDataService {
  static final List<FeedQuantityRecord> feedQuantityDataset = [
    FeedQuantityRecord(
      timestamp: DateTime.parse("2026-08-01 08:00:00"),
      hopperLevelCm: 10.5,
      troughWeightBeforeKg: 0.25,
      previousDispensedKg: 1.30,
      previousLeftoverKg: 0.10,
      gateOpeningPercent: 60.0,
      targetHayQuantityKg: 1.20,
    ),
    FeedQuantityRecord(
      timestamp: DateTime.parse("2026-08-01 12:30:00"),
      hopperLevelCm: 12.8,
      troughWeightBeforeKg: 0.70,
      previousDispensedKg: 1.00,
      previousLeftoverKg: 0.25,
      gateOpeningPercent: 50.0,
      targetHayQuantityKg: 0.80,
    ),
    FeedQuantityRecord(
      timestamp: DateTime.parse("2026-08-01 17:45:00"),
      hopperLevelCm: 14.5,
      troughWeightBeforeKg: 0.20,
      previousDispensedKg: 1.20,
      previousLeftoverKg: 0.05,
      gateOpeningPercent: 70.0,
      targetHayQuantityKg: 1.40,
    ),
    FeedQuantityRecord(
      timestamp: DateTime.parse("2026-08-02 08:15:00"),
      hopperLevelCm: 16.0,
      troughWeightBeforeKg: 0.95,
      previousDispensedKg: 0.80,
      previousLeftoverKg: 0.35,
      gateOpeningPercent: 40.0,
      targetHayQuantityKg: 0.50,
    ),
    FeedQuantityRecord(
      timestamp: DateTime.parse("2026-08-02 13:00:00"),
      hopperLevelCm: 18.5,
      troughWeightBeforeKg: 0.30,
      previousDispensedKg: 1.50,
      previousLeftoverKg: 0.15,
      gateOpeningPercent: 65.0,
      targetHayQuantityKg: 1.30,
    ),
    FeedQuantityRecord(
      timestamp: DateTime.parse("2026-08-02 18:10:00"),
      hopperLevelCm: 20.0,
      troughWeightBeforeKg: 0.15,
      previousDispensedKg: 1.40,
      previousLeftoverKg: 0.08,
      gateOpeningPercent: 75.0,
      targetHayQuantityKg: 1.60,
    ),
  ];

  static final List<BlockageRecord> blockageDataset = [
    BlockageRecord(
      timestamp: DateTime.parse("2026-08-01 08:00:00"),
      hopperLevelCm: 10.5,
      troughWeightKg: 0.25,
      gateOpeningPercent: 60.0,
      gateTimeSeconds: 3.8,
      irFlowDetected: true,
      hallSensorGateOpen: true,
      previousBlockageCount: 0,
      vibratorActive: false,
      blockageStatus: 0,
    ),
    BlockageRecord(
      timestamp: DateTime.parse("2026-08-01 12:30:00"),
      hopperLevelCm: 18.2,
      troughWeightKg: 0.40,
      gateOpeningPercent: 50.0,
      gateTimeSeconds: 3.2,
      irFlowDetected: false,
      hallSensorGateOpen: true,
      previousBlockageCount: 1,
      vibratorActive: false,
      blockageStatus: 1,
    ),
    BlockageRecord(
      timestamp: DateTime.parse("2026-08-01 17:45:00"),
      hopperLevelCm: 22.0,
      troughWeightKg: 0.20,
      gateOpeningPercent: 45.0,
      gateTimeSeconds: 2.5,
      irFlowDetected: false,
      hallSensorGateOpen: true,
      previousBlockageCount: 2,
      vibratorActive: true,
      blockageStatus: 2,
    ),
    BlockageRecord(
      timestamp: DateTime.parse("2026-08-02 08:15:00"),
      hopperLevelCm: 12.5,
      troughWeightKg: 0.60,
      gateOpeningPercent: 65.0,
      gateTimeSeconds: 4.0,
      irFlowDetected: true,
      hallSensorGateOpen: true,
      previousBlockageCount: 0,
      vibratorActive: false,
      blockageStatus: 0,
    ),
    BlockageRecord(
      timestamp: DateTime.parse("2026-08-02 13:00:00"),
      hopperLevelCm: 20.5,
      troughWeightKg: 0.30,
      gateOpeningPercent: 50.0,
      gateTimeSeconds: 3.0,
      irFlowDetected: false,
      hallSensorGateOpen: true,
      previousBlockageCount: 1,
      vibratorActive: true,
      blockageStatus: 1,
    ),
    BlockageRecord(
      timestamp: DateTime.parse("2026-08-02 18:10:00"),
      hopperLevelCm: 24.0,
      troughWeightKg: 0.15,
      gateOpeningPercent: 40.0,
      gateTimeSeconds: 2.2,
      irFlowDetected: false,
      hallSensorGateOpen: true,
      previousBlockageCount: 3,
      vibratorActive: true,
      blockageStatus: 2,
    ),
  ];

  static List<CombinedSimulationPair> get pairedDataset {
    List<CombinedSimulationPair> pairs = [];
    for (int i = 0; i < feedQuantityDataset.length; i++) {
      pairs.add(CombinedSimulationPair(
        feedRecord: feedQuantityDataset[i],
        blockageRecord: blockageDataset[i],
      ));
    }
    return pairs;
  }
}
