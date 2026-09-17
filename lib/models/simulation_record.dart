class FeedQuantityRecord {
  final DateTime timestamp;
  final double hopperLevelCm;
  final double troughWeightBeforeKg;
  final double previousDispensedKg;
  final double previousLeftoverKg;
  final double gateOpeningPercent;
  final double targetHayQuantityKg;
  final double? ambientTemperature;
  final double? humidity;

  const FeedQuantityRecord({
    required this.timestamp,
    required this.hopperLevelCm,
    required this.troughWeightBeforeKg,
    required this.previousDispensedKg,
    required this.previousLeftoverKg,
    required this.gateOpeningPercent,
    required this.targetHayQuantityKg,
    this.ambientTemperature = 28.5,
    this.humidity = 62.0,
  });
}

class BlockageRecord {
  final DateTime timestamp;
  final double hopperLevelCm;
  final double troughWeightKg;
  final double gateOpeningPercent;
  final double gateTimeSeconds;
  final bool irFlowDetected;
  final bool hallSensorGateOpen;
  final int previousBlockageCount;
  final bool vibratorActive;
  /// 0 = Normal Flow, 1 = Moderate Blockage Risk, 2 = Severe Blockage Risk
  final int blockageStatus;

  const BlockageRecord({
    required this.timestamp,
    required this.hopperLevelCm,
    required this.troughWeightKg,
    required this.gateOpeningPercent,
    required this.gateTimeSeconds,
    required this.irFlowDetected,
    required this.hallSensorGateOpen,
    required this.previousBlockageCount,
    required this.vibratorActive,
    required this.blockageStatus,
  });

  String get blockageLabel {
    switch (blockageStatus) {
      case 0:
        return 'Normal Flow';
      case 1:
        return 'Moderate Blockage Risk';
      case 2:
        return 'Severe Blockage Risk';
      default:
        return 'Unknown';
    }
  }
}

class CombinedSimulationPair {
  final FeedQuantityRecord feedRecord;
  final BlockageRecord blockageRecord;

  const CombinedSimulationPair({
    required this.feedRecord,
    required this.blockageRecord,
  });
}
