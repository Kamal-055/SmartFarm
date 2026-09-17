import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class PrototypeDiagramWidget extends StatelessWidget {
  const PrototypeDiagramWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.glassForestCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        children: [
          // Diagram Header
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.developer_board, color: AppColors.primaryAccent, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Hardware Prototype System Overview',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Chip(
                backgroundColor: AppColors.primaryDark,
                side: BorderSide(color: AppColors.primaryAccent),
                padding: EdgeInsets.zero,
                label: Text(
                  'ESP32 IoT',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryAccent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Central ESP32 Microcontroller Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryDark,
                  AppColors.primary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryAccent, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryAccent.withValues(alpha: 0.3),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.memory, color: AppColors.primaryAccent, size: 28),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ESP32 Microcontroller Core',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'FreeRTOS Telemetry Streamer & Servo Controller',
                      style: TextStyle(fontSize: 11, color: AppColors.primaryAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Hardware Flow Diagram Steps
          _buildDiagramNode('1. GRAVITY HOPPER', 'Ultrasonic HC-SR04 measures level', Icons.inventory_2_outlined, Colors.amberAccent),
          _buildArrowDown(),
          _buildDiagramNode('2. SLIDING DISPENSE GATE', 'Servo Motor (MG996R) controls opening %', Icons.door_sliding_outlined, Colors.cyanAccent),
          _buildArrowDown(),
          _buildDiagramNode('3. HAY FLOW CHANNEL', 'IR Break Beam Sensor detects flow & blockage', Icons.sensors, Colors.orangeAccent),
          _buildArrowDown(),
          _buildDiagramNode('4. CATTLE TROUGH', 'Load Cell + HX711 24-bit ADC measures weight', Icons.scale_outlined, Colors.lightGreenAccent),
          _buildArrowDown(),
          _buildDiagramNode('5. AI ENGINE & APP', 'Adaptive Quantity Regressor & Risk Classifier', Icons.psychology, Colors.purpleAccent),
        ],
      ),
    );
  }

  Widget _buildDiagramNode(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowDown() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Icon(Icons.arrow_downward_rounded, color: AppColors.primaryAccent, size: 18),
    );
  }
}
