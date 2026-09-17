import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/prototype_diagram_widget.dart';

class SystemOverviewScreen extends StatelessWidget {
  const SystemOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('How Smart Feeding Works'),
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
              color: AppColors.background.withValues(alpha: 0.90),
            ),
          ),

          const SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 14, right: 14, top: 12, bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrototypeDiagramWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
