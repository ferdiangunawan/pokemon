import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Type chip widget for displaying Pokemon types
class PokemonTypeChipWidget extends StatelessWidget {
  final String typeName;

  const PokemonTypeChipWidget({super.key, required this.typeName});

  /// Capitalize the first letter
  String get _capitalizedName {
    if (typeName.isEmpty) return typeName;
    return '${typeName[0].toUpperCase()}${typeName.substring(1)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        _capitalizedName,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
