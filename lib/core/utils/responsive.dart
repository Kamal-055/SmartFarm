import 'package:flutter/material.dart';

class Responsive {
  static bool isSmall(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 360;
  }

  static bool isMedium(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= 360 && width < 600;
  }

  static bool isLarge(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 600;
  }

  static T valueByDevice<T>(
    BuildContext context, {
    required T small,
    required T medium,
    required T large,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 360) return small;
    if (width < 600) return medium;
    return large;
  }

  static double horizontalPadding(BuildContext context) {
    return isSmall(context) ? 10.0 : 14.0;
  }

  static double sensorGridRatio(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 340) return 1.12;
    if (width < 375) return 1.25;
    if (width < 450) return 1.45;
    return 1.60;
  }
}
