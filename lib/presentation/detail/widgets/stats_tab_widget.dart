import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../common/index.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/index.dart';

/// Stats tab showing Pokemon base stats with animated bars and enhanced design
class StatsTabWidget extends StatefulWidget {
  final Pokemon pokemon;
  final bool isLandscape;

  const StatsTabWidget({
    super.key,
    required this.pokemon,
    this.isLandscape = false,
  });

  @override
  State<StatsTabWidget> createState() => _StatsTabWidgetState();
}

class _StatsTabWidgetState extends State<StatsTabWidget>
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
    final size = MediaQuery.of(context).size;
    final isLandscape = widget.isLandscape;

    // Responsive sizing
    final basePadding = isLandscape ? size.width * 0.015 : 16.w;
    final gapMedium = isLandscape ? size.height * 0.035 : 20.h;
    final gapSmall = isLandscape ? size.height * 0.025 : 16.h;

    return SingleChildScrollView(
      padding: EdgeInsets.all(basePadding),
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
                isLandscape: isLandscape,
              ),
            );
          }),
          SizedBox(height: gapMedium),
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
              isLandscape: isLandscape,
            ),
          ),
          SizedBox(height: gapSmall),
          // Stat distribution chart hint
          Container(
            padding: EdgeInsets.all(isLandscape ? size.width * 0.012 : 12.w),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(isLandscape ? 12.0 : 12.r),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: isLandscape ? size.height * 0.04 : 18.sp,
                  color: theme.hintColor,
                ),
                SizedBox(width: isLandscape ? size.width * 0.008 : 8.w),
                Expanded(
                  child: Text(
                    'Max stat value: ${ApiConstants.maxStatValue}',
                    style: TextStyle(
                      fontSize: isLandscape ? size.height * 0.028 : 12.sp,
                      color: theme.hintColor,
                    ),
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
  final bool isLandscape;

  const _StatBar({
    required this.stat,
    required this.color,
    required this.index,
    this.isLandscape = false,
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
    final size = MediaQuery.of(context).size;

    // Responsive sizing
    final verticalPadding = isLandscape ? size.height * 0.018 : 10.h;
    final labelWidth = isLandscape ? size.width * 0.08 : 70.w;
    final valueWidth = isLandscape ? size.width * 0.05 : 45.w;
    final labelFontSize = isLandscape ? size.height * 0.028 : 12.sp;
    final valueFontSize = isLandscape ? size.height * 0.035 : 15.sp;
    final barHeight = isLandscape ? size.height * 0.022 : 10.h;
    final barRadius = isLandscape ? size.height * 0.011 : 5.r;
    final gapWidth = isLandscape ? size.width * 0.015 : 16.w;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Row(
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              statLabel,
              style: TextStyle(
                color: theme.hintColor,
                fontSize: labelFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: valueWidth,
            child: Text(
              stat.baseStat.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: valueFontSize,
                color: theme.textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(width: gapWidth),
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
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(barRadius),
                      ),
                    ),
                    // Progress bar
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: value.clamp(0.0, 1.0),
                      child: Container(
                        height: barHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              statColor.withValues(alpha: 0.7),
                              statColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(barRadius),
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
  final bool isLandscape;

  const _TotalStatBar({
    required this.total,
    required this.color,
    this.isLandscape = false,
  });

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
    final size = MediaQuery.of(context).size;

    // Responsive sizing
    final basePadding = isLandscape ? size.width * 0.015 : 16.w;
    final borderRadius = isLandscape ? 16.0 : 16.r;
    final iconPadding = isLandscape ? size.width * 0.008 : 8.w;
    final iconRadius = isLandscape ? 8.0 : 8.r;
    final iconSize = isLandscape ? size.height * 0.045 : 20.sp;
    final gapWidth = isLandscape ? size.width * 0.012 : 12.w;
    final titleFontSize = isLandscape ? size.height * 0.038 : 16.sp;
    final totalFontSize = isLandscape ? size.height * 0.055 : 24.sp;
    final ratingPaddingH = isLandscape ? size.width * 0.008 : 8.w;
    final ratingPaddingV = isLandscape ? size.height * 0.004 : 2.h;
    final ratingFontSize = isLandscape ? size.height * 0.025 : 10.sp;
    final gapHeight = isLandscape ? size.height * 0.03 : 16.h;
    final barHeight = isLandscape ? size.height * 0.03 : 14.h;
    final barRadius = isLandscape ? size.height * 0.015 : 7.r;

    return Container(
      padding: EdgeInsets.all(basePadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: isDark ? 0.2 : 0.1),
            color.withValues(alpha: isDark ? 0.1 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
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
                    padding: EdgeInsets.all(iconPadding),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(iconRadius),
                    ),
                    child: Icon(
                      Icons.bar_chart_rounded,
                      color: color,
                      size: iconSize,
                    ),
                  ),
                  SizedBox(width: gapWidth),
                  Text(
                    LocaleKeys.detailTotal.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleFontSize,
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
                      fontSize: totalFontSize,
                      color: color,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ratingPaddingH,
                      vertical: ratingPaddingV,
                    ),
                    decoration: BoxDecoration(
                      color: ratingColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(iconRadius),
                    ),
                    child: Text(
                      statRating,
                      style: TextStyle(
                        fontSize: ratingFontSize,
                        fontWeight: FontWeight.w600,
                        color: ratingColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: gapHeight),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            tween: Tween(begin: 0, end: progress),
            builder: (context, value, child) {
              return Stack(
                children: [
                  Container(
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(barRadius),
                    ),
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: value.clamp(0.0, 1.0),
                    child: Container(
                      height: barHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color.withValues(alpha: 0.7), color],
                        ),
                        borderRadius: BorderRadius.circular(barRadius),
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
