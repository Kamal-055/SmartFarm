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
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.schema_outlined, color: AppColors.primaryAccent, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Smart Cattle Feeder — How It Works',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6),
              Chip(
                backgroundColor: AppColors.primaryDark,
                side: BorderSide(color: AppColors.primaryAccent),
                padding: EdgeInsets.zero,
                label: Text(
                  'AUTOMATIC',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryAccent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Central Smart Feeder Hub Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                Icon(Icons.auto_awesome, color: AppColors.primaryAccent, size: 26),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Smart Cattle Feeder Controller',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        'Automatic Dispenser & Cattle Feeding Assistant',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10, color: AppColors.primaryAccent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Flow Diagram Steps
          _buildDiagramNode('1. FODDER STORAGE BIN', 'Monitors hay remaining depth & capacity', Icons.inventory_2_outlined, Colors.amberAccent),
          _buildArrowDown(),
          _buildDiagramNode('2. AUTOMATIC FEED GATE', 'Opens precisely to release required hay quantity', Icons.door_sliding_outlined, Colors.cyanAccent),
          _buildArrowDown(),
          _buildDiagramNode('3. FLOW ASSIST SENSOR', 'Monitors hay movement & assists flow if needed', Icons.sensors, Colors.orangeAccent),
          _buildArrowDown(),
          _buildDiagramNode('4. CATTLE TROUGH SCALE', 'Weighs feed in real-time for precise consumption', Icons.scale_outlined, Colors.lightGreenAccent),
          _buildArrowDown(),
          _buildDiagramNode('5. SMART FARMER APP', 'Recommends exact portions & alerts farmer instantly', Icons.mobile_friendly, Colors.purpleAccent),
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
