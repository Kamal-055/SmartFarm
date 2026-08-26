import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class CustomDialogs {
  // Add Schedule Dialog using native TimePicker
  static Future<Map<String, dynamic>?> showAddScheduleDialog(BuildContext context) async {
    final nameController = TextEditingController(text: 'Custom Feeding');
    TimeOfDay selectedTime = const TimeOfDay(hour: 12, minute: 0);
    int selectedDuration = 15;

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              title: const Row(
                children: [
                  Icon(Icons.schedule, color: AppColors.primary, size: 22),
                  SizedBox(width: 8),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Add Feeding Schedule',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Schedule Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Noon Feeding',
                      ),
                    ),
                    const SizedBox(height: 14),

                    const Text('Feeding Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null) {
                          setState(() => selectedTime = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceWarm,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedTime.format(context),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                            const Icon(Icons.access_time, color: AppColors.primary, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    const Text('Gate Open Duration (Seconds)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<int>(
                      initialValue: selectedDuration,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 5, child: Text('5 seconds')),
                        DropdownMenuItem(value: 10, child: Text('10 seconds')),
                        DropdownMenuItem(value: 15, child: Text('15 seconds')),
                        DropdownMenuItem(value: 20, child: Text('20 seconds')),
                        DropdownMenuItem(value: 30, child: Text('30 seconds')),
                        DropdownMenuItem(value: 60, child: Text('60 seconds')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => selectedDuration = val);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    minimumSize: const Size(120, 44),
                  ),
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) return;
                    Navigator.pop(ctx, {
                      'name': nameController.text.trim(),
                      'timeOfDay': selectedTime,
                      'durationSeconds': selectedDuration,
                    });
                  },
                  child: const Text('SAVE SCHEDULE', style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Edit Farm Details Dialog
  static Future<Map<String, dynamic>?> showEditFarmDialog(
    BuildContext context, {
    required String currentName,
    required int currentCattleCount,
  }) async {
    final nameController = TextEditingController(text: currentName);
    final countController = TextEditingController(text: currentCattleCount.toString());

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Farm Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Farm Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: countController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Number of Cattle'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                final count = int.tryParse(countController.text.trim()) ?? currentCattleCount;
                Navigator.pop(ctx, {
                  'name': nameController.text.trim(),
                  'cattleCount': count,
                });
              },
              child: const Text('SAVE', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
