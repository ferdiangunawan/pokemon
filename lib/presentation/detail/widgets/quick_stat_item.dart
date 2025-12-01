import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickStatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isLandscape;

  const QuickStatItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    // Use fixed pixel values for landscape mode
    final iconSize = isLandscape ? 22.0 : 18.sp;
    final labelFontSize = isLandscape ? 12.0 : 11.sp;
    final valueFontSize = isLandscape ? 16.0 : 14.sp;
    final spacing = isLandscape ? 8.0 : 6.w;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: iconSize, color: Colors.white.withValues(alpha: 0.9)),
        SizedBox(width: spacing),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: labelFontSize,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
