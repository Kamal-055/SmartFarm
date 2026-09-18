import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/alert_provider.dart';
import '../../providers/fodder_inventory_provider.dart';

class RefillFodderScreen extends StatefulWidget {
  const RefillFodderScreen({super.key});

  @override
  State<RefillFodderScreen> createState() => _RefillFodderScreenState();
}

class _RefillFodderScreenState extends State<RefillFodderScreen> {
  double _addAmountKg = 5.0;

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<FodderInventoryProvider>(context);
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);

    final currentKg = inventoryProvider.availableFodderKg;
    final capacityKg = inventoryProvider.totalCapacityKg;
    final maxAddKg = (capacityKg - currentKg).clamp(0.0, capacityKg);
    final newLevelKg = (currentKg + _addAmountKg).clamp(0.0, capacityKg);
    final isLow = inventoryProvider.isLow || inventoryProvider.isCritical;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Refill Fodder'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hopper Silo Graphic showing Current Fodder Level
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
                  children: [
                    const Icon(Icons.museum_outlined, size: 72, color: AppColors.primaryMedium),
                    const SizedBox(height: 10),
                    const Text('Current Fodder', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          currentKg.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                        ),
                        const SizedBox(width: 4),
                        const Text('kg', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isLow ? Colors.amber.shade100 : AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isLow ? Colors.amber.shade600 : AppColors.primaryAccent),
                      ),
                      child: Text(
                        isLow ? '⚠️ Low Fodder Supply' : '● Normal Supply',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isLow ? Colors.amber.shade900 : AppColors.primaryMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Stepper Card: Add Fodder [ - ] 5.0 kg [ + ]
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
                    const Text(
                      'Add Fodder',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Minus Button
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (_addAmountKg > 1.0) _addAmountKg -= 0.5;
                            });
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAEFEA),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(Icons.remove_rounded, color: AppColors.textPrimary, size: 28),
                          ),
                        ),

                        // Amount Text Display
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              _addAmountKg.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                            ),
                            const SizedBox(width: 6),
                            const Text('kg', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                          ],
                        ),

                        // Plus Button
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (_addAmountKg < maxAddKg) _addAmountKg += 0.5;
                            });
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryMedium,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // [ Update ] Primary Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryMedium,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 3,
                  ),
                  onPressed: () {
                    inventoryProvider.refillFodder(_addAmountKg, alertProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Succesfully added ${_addAmountKg.toStringAsFixed(1)} kg fodder!'),
                        backgroundColor: AppColors.primaryMedium,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Update', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),

              // Preview Card: New Fodder Level: 6.8 kg of 10 kg
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryMedium,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.grass_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'New Fodder Level',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryMedium),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${newLevelKg.toStringAsFixed(1)} kg of ${capacityKg.toInt()} kg',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
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
    );
  }
}
