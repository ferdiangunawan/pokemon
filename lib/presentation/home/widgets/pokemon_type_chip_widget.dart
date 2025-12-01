import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Type chip widget for displaying Pokemon types
class PokemonTypeChipWidget extends StatelessWidget {
  final String typeName;
  final bool isCompact;

  const PokemonTypeChipWidget({
    super.key,
    required this.typeName,
    this.isCompact = false,
  });

  /// Capitalize the first letter
  String get _capitalizedName {
    if (typeName.isEmpty) return typeName;
    return '${typeName[0].toUpperCase()}${typeName.substring(1)}';
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = isCompact ? 6.0 : 10.w;
    final verticalPadding = isCompact ? 2.0 : 4.h;
    final fontSize = isCompact ? 8.0 : 10.sp;
    final borderRadius = isCompact ? 12.0 : 20.r;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        _capitalizedName,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
