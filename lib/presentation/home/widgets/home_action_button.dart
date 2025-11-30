import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isLandscape;

  const HomeActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    final borderRadius = isLandscape ? size.height * 0.03 : 12.r;
    final padding = isLandscape ? size.height * 0.025 : 10.w;
    final iconSize = isLandscape ? size.height * 0.06 : 22.sp;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Icon(icon, size: iconSize, color: theme.iconTheme.color),
        ),
      ),
    );
  }
}
