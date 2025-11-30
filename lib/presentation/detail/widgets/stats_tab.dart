import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../common/index.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/index.dart';

/// Stats tab showing Pokemon base stats with animated bars and enhanced design
class StatsTab extends StatefulWidget {
  final Pokemon pokemon;

  const StatsTab({super.key, required this.pokemon});

  @override
  State<StatsTab> createState() => _StatsTabState();
}

class _StatsTabState extends State<StatsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final primaryColor = PokemonTypeColors.getTypeColor(
      widget.pokemon.primaryType,
    );
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Stats list with staggered animations
          ...widget.pokemon.stats.asMap().entries.map((entry) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 400 + (entry.key * 100)),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(20 * (1 - value), 0),
                    child: child,
                  ),
                );
              },
              child: _StatBar(
                stat: entry.value,
                color: primaryColor,
                index: entry.key,
              ),
            );
          }),
          Gap(20.h),
          // Total stats with enhanced design
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.scale(
                  scale: 0.95 + (0.05 * value),
                  child: child,
                ),
              );
            },
            child: _TotalStatBar(
              total: widget.pokemon.totalStats,
              color: primaryColor,
            ),
          ),
          Gap(16.h),
          // Stat distribution chart hint
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 18.sp,
                  color: theme.hintColor,
                ),
                Gap(8.w),
                Expanded(
                  child: Text(
                    'Max stat value: ${ApiConstants.maxStatValue}',
                    style: TextStyle(fontSize: 12.sp, color: theme.hintColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final PokemonStats stat;
  final Color color;
  final int index;

  const _StatBar({
    required this.stat,
    required this.color,
    required this.index,
  });

  String get statLabel {
    switch (stat.name) {
      case 'hp':
        return LocaleKeys.detailHp.tr();
      case 'attack':
        return LocaleKeys.detailAttack.tr();
      case 'defense':
        return LocaleKeys.detailDefense.tr();
      case 'special-attack':
        return LocaleKeys.detailSpAtk.tr();
      case 'special-defense':
        return LocaleKeys.detailSpDef.tr();
      case 'speed':
        return LocaleKeys.detailSpeed.tr();
      default:
        return stat.name.toReadable;
    }
  }

  Color get statColor {
    // Different colors based on stat value
    if (stat.baseStat >= 150) return AppColors.purple;
    if (stat.baseStat >= 120) return AppColors.green;
    if (stat.baseStat >= 90) return color;
    if (stat.baseStat >= 60) return AppColors.orange;
    return AppColors.red;
  }

  @override
  Widget build(BuildContext context) {
    final progress = stat.baseStat / ApiConstants.maxStatValue;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          SizedBox(
            width: 70.w,
            child: Text(
              statLabel,
              style: TextStyle(
                color: theme.hintColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 45.w,
            child: Text(
              stat.baseStat.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: theme.textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Gap(16.w),
          Expanded(
            child: TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 600 + (index * 100)),
              curve: Curves.easeOutCubic,
              tween: Tween(begin: 0, end: progress),
              builder: (context, value, child) {
                return Stack(
                  children: [
                    // Background bar
                    Container(
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    ),
                    // Progress bar
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: value.clamp(0.0, 1.0),
                      child: Container(
                        height: 10.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              statColor.withValues(alpha: 0.7),
                              statColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(5.r),
                          boxShadow: [
                            BoxShadow(
                              color: statColor.withValues(alpha: 0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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

  String get statRating {
    if (total >= 600) return 'Legendary';
    if (total >= 500) return 'Excellent';
    if (total >= 400) return 'Good';
    if (total >= 300) return 'Average';
    return 'Below Average';
  }

  Color get ratingColor {
    if (total >= 600) return AppColors.purple;
    if (total >= 500) return AppColors.green;
    if (total >= 400) return AppColors.blue;
    if (total >= 300) return AppColors.orange;
    return AppColors.red;
  }

  @override
  Widget build(BuildContext context) {
    // Max total is 6 stats * 255 = 1530
    final maxTotal = 6 * ApiConstants.maxStatValue;
    final progress = total / maxTotal;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: isDark ? 0.2 : 0.1),
            color.withValues(alpha: isDark ? 0.1 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.bar_chart_rounded,
                      color: color,
                      size: 20.sp,
                    ),
                  ),
                  Gap(12.w),
                  Text(
                    LocaleKeys.detailTotal.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    total.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                      color: color,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: ratingColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      statRating,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: ratingColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gap(16.h),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            tween: Tween(begin: 0, end: progress),
            builder: (context, value, child) {
              return Stack(
                children: [
                  Container(
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: value.clamp(0.0, 1.0),
                    child: Container(
                      height: 14.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color.withValues(alpha: 0.7), color],
                        ),
                        borderRadius: BorderRadius.circular(7.r),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
