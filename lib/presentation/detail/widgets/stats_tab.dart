import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../common/index.dart';
import '../../../domain/index.dart';

/// Stats tab showing Pokemon base stats with animated bars
class StatsTab extends StatelessWidget {
  final Pokemon pokemon;

  const StatsTab({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final primaryColor = PokemonTypeColors.getTypeColor(pokemon.primaryType);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          ...pokemon.stats.map((stat) {
            return _StatBar(stat: stat, color: primaryColor);
          }),
          Gap(16.h),
          // Total stats
          _TotalStatBar(total: pokemon.totalStats, color: primaryColor),
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final PokemonStats stat;
  final Color color;

  const _StatBar({required this.stat, required this.color});

  String get statLabel {
    switch (stat.name) {
      case 'hp':
        return 'detail.hp'.tr();
      case 'attack':
        return 'detail.attack'.tr();
      case 'defense':
        return 'detail.defense'.tr();
      case 'special-attack':
        return 'detail.sp_atk'.tr();
      case 'special-defense':
        return 'detail.sp_def'.tr();
      case 'speed':
        return 'detail.speed'.tr();
      default:
        return stat.name.toReadable;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = stat.baseStat / ApiConstants.maxStatValue;
    final isHighStat = stat.baseStat >= 100;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              statLabel,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            width: 40.w,
            child: Text(
              stat.baseStat.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              textAlign: TextAlign.right,
            ),
          ),
          Gap(16.w),
          Expanded(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              tween: Tween(begin: 0, end: progress),
              builder: (context, value, child) {
                return Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: value.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isHighStat ? color : color.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4.r),
                        gradient: LinearGradient(
                          colors: [color.withOpacity(0.8), color],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalStatBar extends StatelessWidget {
  final int total;
  final Color color;

  const _TotalStatBar({required this.total, required this.color});

  @override
  Widget build(BuildContext context) {
    // Max total is 6 stats * 255 = 1530
    final maxTotal = 6 * ApiConstants.maxStatValue;
    final progress = total / maxTotal;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Text(
            'detail.total'.tr(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
          ),
          Gap(16.w),
          Text(
            total.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: color,
            ),
          ),
          Gap(16.w),
          Expanded(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              tween: Tween(begin: 0, end: progress),
              builder: (context, value, child) {
                return Container(
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: value.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color.withOpacity(0.6), color],
                        ),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
