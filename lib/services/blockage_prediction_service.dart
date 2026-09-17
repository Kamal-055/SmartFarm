import '../models/ai_prediction_model.dart';
import '../models/simulation_record.dart';

class BlockagePredictionService {
  BlockagePrediction predictBlockage(BlockageRecord record) {
    int riskCode = record.blockageStatus;
    BlockageRiskLevel riskLevel;
    String action;
    bool vibrator;
    double adjustedGatePercent = record.gateOpeningPercent;
    int retries = 0;
    double confidence = 91.5;

    switch (riskCode) {
      case 0:
        riskLevel = BlockageRiskLevel.normal;
        action = "Normal flow detected. Executing standard feed schedule.";
        vibrator = false;
        confidence = 97.8;
        break;
      case 1:
        riskLevel = BlockageRiskLevel.moderate;
        action = "Preventive vibration activated for 1.5s prior to gate release.";
        vibrator = true;
        confidence = 92.4;
        break;
      case 2:
      default:
        riskLevel = BlockageRiskLevel.severe;
        action = "Corrective action initiated: Vibration ON & Gate increased by +10%.";
        vibrator = true;
        adjustedGatePercent = (record.gateOpeningPercent + 10.0).clamp(0.0, 100.0);
        retries = 1;
        confidence = 95.1;
        break;
    }

    return BlockagePrediction(
      riskLevel: riskLevel,
      riskCode: riskCode,
      confidencePercentage: confidence,
      recommendedAction: action,
      vibratorActivated: vibrator,
      adjustedGateOpeningPercent: adjustedGatePercent,
      retryCount: retries,
    );
  }
}
