import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Section title widget with icon
class SectionTitleWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isLandscape;

  const SectionTitleWidget({
    super.key,
    required this.title,
    required this.icon,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final iconSize = isLandscape ? size.height * 0.045 : 20.sp;
    final gapWidth = isLandscape ? size.width * 0.008 : 8.w;

    return Row(
      children: [
        Icon(icon, size: iconSize, color: theme.hintColor),
        Gap(gapWidth),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: isLandscape ? size.height * 0.038 : null,
          ),
        ),
      ],
    );
  }
}

/// Gender label widget for displaying male/female ratios
class GenderLabelWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final double percentage;
  final bool isLandscape;

  const GenderLabelWidget({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.percentage,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final iconSize = isLandscape ? size.height * 0.05 : 22.sp;
    final gapSmall = isLandscape ? size.width * 0.006 : 6.w;
    final gapTiny = isLandscape ? size.height * 0.008 : 4.h;
    final labelFontSize = isLandscape ? size.height * 0.03 : 13.sp;
    final percentFontSize = isLandscape ? size.height * 0.038 : 16.sp;

    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: iconSize),
            Gap(gapSmall),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: labelFontSize,
              ),
            ),
          ],
        ),
        Gap(gapTiny),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: percentFontSize,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Info row data model
class InfoRowData {
  final String label;
  final String value;
  final IconData icon;

  const InfoRowData({
    required this.label,
    required this.value,
    required this.icon,
  });
}
