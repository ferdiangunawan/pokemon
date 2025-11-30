import 'package:flutter/material.dart';

class QuickStatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const QuickStatItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    final baseFontSize = isLandscape ? size.height * 0.045 : size.width * 0.035;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: baseFontSize * 0.9,
          color: Colors.white.withValues(alpha: 0.9),
        ),
        SizedBox(width: size.width * 0.015),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: baseFontSize * 0.55,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: baseFontSize * 0.7,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
