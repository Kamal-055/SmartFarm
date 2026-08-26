import 'package:flutter/material.dart';
import '../models/farm_model.dart';
import '../services/rtdb_service.dart';

class FarmProvider with ChangeNotifier {
  final RealtimeDatabaseService _rtdbService = RealtimeDatabaseService();
  
  FarmModel _farm = FarmModel(
    id: 'FARM_GREEN_VALLEY',
    name: 'Green Valley Farm',
    ownerId: 'DEMO_FARMER_123',
    cattleCount: 18,
    location: 'Coimbatore, TN',
    createdAt: DateTime.now(),
  );

  FarmModel get farm => _farm;

  void updateFarmDetails({required String name, required int cattleCount, String location = ''}) {
    _farm = _farm.copyWith(
      name: name,
      cattleCount: cattleCount,
      location: location,
    );
    notifyListeners();
  }

  Future<void> saveFarmToFirebase(bool isMock) async {
    if (isMock) return;
    try {
      await _rtdbService.saveFarm(_farm);
    } catch (_) {}
  }
}
