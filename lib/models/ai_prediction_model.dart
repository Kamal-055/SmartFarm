class FeedQuantityPrediction {
  final double predictedQuantityKg;
  final double recommendedGateOpeningPercent;
  final double estimatedGateTimeSeconds;
  final double actualDispensedKg;
  final double differenceKg;
  final double confidencePercentage;

  const FeedQuantityPrediction({
    required this.predictedQuantityKg,
    required this.recommendedGateOpeningPercent,
    required this.estimatedGateTimeSeconds,
    required this.actualDispensedKg,
    required this.differenceKg,
    this.confidencePercentage = 94.2,
  });
}

enum BlockageRiskLevel {
  normal,
  moderate,
  severe,
}

class BlockagePrediction {
  final BlockageRiskLevel riskLevel;
  final int riskCode; // 0, 1, 2
  final double confidencePercentage;
  final String recommendedAction;
  final bool vibratorActivated;
  final double adjustedGateOpeningPercent;
  final int retryCount;

  const BlockagePrediction({
    required this.riskLevel,
    required this.riskCode,
    required this.confidencePercentage,
    required this.recommendedAction,
    required this.vibratorActivated,
    required this.adjustedGateOpeningPercent,
    this.retryCount = 0,
  });

  String get riskTitle {
    switch (riskLevel) {
      case BlockageRiskLevel.normal:
        return 'NORMAL FLOW';
      case BlockageRiskLevel.moderate:
        return 'MODERATE BLOCKAGE RISK';
      case BlockageRiskLevel.severe:
        return 'SEVERE BLOCKAGE RISK';
    }
  }
}
