import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../common/index.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/index.dart';

/// About tab showing Pokemon details with enhanced design
class AboutTabWidget extends StatefulWidget {
  final Pokemon pokemon;
  final PokemonSpecies? species;
  final bool isLandscape;

  const AboutTabWidget({
    super.key,
    required this.pokemon,
    this.species,
    this.isLandscape = false,
  });

  @override
  State<AboutTabWidget> createState() => _AboutTabWidgetState();
}

class _AboutTabWidgetState extends State<AboutTabWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final primaryColor = PokemonTypeColors.getTypeColor(
      widget.pokemon.primaryType,
    );
    final size = MediaQuery.of(context).size;
    final isLandscape = widget.isLandscape;

    // Responsive sizing - use raw values for landscape
    final basePadding = isLandscape ? size.width * 0.015 : 16.w;
    final iconSize = isLandscape ? size.height * 0.05 : 24.sp;
    final gapSmall = isLandscape ? size.height * 0.015 : 12.w;
    final gapMedium = isLandscape ? size.height * 0.025 : 24.h;
    final borderRadius = isLandscape ? 16.0 : 16.r;

    return SingleChildScrollView(
      padding: EdgeInsets.all(basePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description with fade-in animation
          if (widget.species?.description != null) ...[
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 400),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 10 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(basePadding),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.format_quote_rounded,
                      color: primaryColor.withValues(alpha: 0.5),
                      size: iconSize,
                    ),
                    Gap(gapSmall),
                    Expanded(
                      child: Text(
                        widget.species!.description!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(
                            0.8,
                          ),
                          height: 1.6,
                          fontStyle: FontStyle.italic,
                          fontSize: isLandscape ? size.height * 0.032 : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap(gapMedium),
          ],

          // Basic info section with staggered animation
          _buildInfoSection(context, primaryColor, isLandscape, [
            _InfoRow(
              label: LocaleKeys.detailSpecies.tr(),
              value: widget.species?.genus ?? LocaleKeys.detailUnknown.tr(),
              icon: Icons.category_rounded,
            ),
            _InfoRow(
              label: LocaleKeys.detailHeight.tr(),
              value: widget.pokemon.formattedHeight,
              icon: Icons.height_rounded,
            ),
            _InfoRow(
              label: LocaleKeys.detailWeight.tr(),
              value: widget.pokemon.formattedWeight,
              icon: Icons.fitness_center_rounded,
            ),
            _InfoRow(
              label: LocaleKeys.detailAbilities.tr(),
              value: widget.pokemon.abilities
                  .map((a) => a.name.toReadable)
                  .join(', '),
              icon: Icons.auto_awesome_rounded,
            ),
          ]),
          Gap(gapMedium),

          // Gender section with visual progress bar
          if (widget.species != null) ...[
            _SectionTitle(
              title: LocaleKeys.detailGender.tr(),
              icon: Icons.wc_rounded,
              isLandscape: isLandscape,
            ),
            Gap(gapSmall),
            _buildGenderInfo(
              context,
              widget.species!,
              primaryColor,
              isLandscape,
            ),
            Gap(gapMedium),
          ],

          // Egg groups with chips
          if (widget.species != null &&
              widget.species!.eggGroups.isNotEmpty) ...[
            _SectionTitle(
              title: LocaleKeys.detailEggGroups.tr(),
              icon: Icons.egg_rounded,
              isLandscape: isLandscape,
            ),
            Gap(gapSmall),
            Wrap(
              spacing: isLandscape ? size.width * 0.01 : 10.w,
              runSpacing: isLandscape ? size.height * 0.015 : 8.h,
              children: widget.species!.eggGroups.asMap().entries.map((entry) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 300 + entry.key * 100),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isLandscape ? size.width * 0.015 : 16.w,
                      vertical: isLandscape ? size.height * 0.02 : 10.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primaryColor.withValues(alpha: 0.1),
                          primaryColor.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(borderRadius),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      entry.value.toReadable,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: isLandscape ? size.height * 0.03 : 13.sp,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    Color primaryColor,
    bool isLandscape,
    List<_InfoRow> rows,
  ) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final basePadding = isLandscape ? size.width * 0.015 : 16.w;
    final borderRadius = isLandscape ? 20.0 : 20.r;

    return Container(
      padding: EdgeInsets.all(basePadding),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final row = entry.value;
          final isLast = entry.key == rows.length - 1;

          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 300 + (entry.key * 100)),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(15 * (1 - value), 0),
                  child: child,
                ),
              );
            },
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: isLandscape ? size.height * 0.02 : 12.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                          isLandscape ? size.width * 0.008 : 8.w,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            isLandscape ? 10.0 : 10.r,
                          ),
                        ),
                        child: Icon(
                          row.icon,
                          size: isLandscape ? size.height * 0.04 : 18.sp,
                          color: primaryColor,
                        ),
                      ),
                      Gap(isLandscape ? size.width * 0.012 : 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              row.label,
                              style: TextStyle(
                                color: theme.hintColor,
                                fontSize: isLandscape
                                    ? size.height * 0.028
                                    : 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: isLandscape ? size.height * 0.008 : 4.h,
                            ),
                            Text(
                              row.value,
                              style: TextStyle(
                                color: theme.textTheme.bodyLarge?.color,
                                fontSize: isLandscape
                                    ? size.height * 0.035
                                    : 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(
                    color: theme.dividerColor.withValues(alpha: 0.3),
                    height: 1,
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGenderInfo(
    BuildContext context,
    PokemonSpecies species,
    Color primaryColor,
    bool isLandscape,
  ) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final basePadding = isLandscape ? size.width * 0.015 : 16.w;
    final borderRadius = isLandscape ? 16.0 : 16.r;
    final iconSize = isLandscape ? size.height * 0.045 : 20.sp;
    final gapSmall = isLandscape ? size.width * 0.008 : 8.w;

    if (species.isGenderless) {
      return Container(
        padding: EdgeInsets.all(basePadding),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.not_interested_rounded,
              color: Colors.grey,
              size: iconSize,
            ),
            Gap(gapSmall),
            Text(
              LocaleKeys.detailGenderless.tr(),
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
                fontSize: isLandscape ? size.height * 0.032 : null,
              ),
            ),
          ],
        ),
      );
    }

    final femaleRatio = species.femaleRatio ?? 0;
    final maleRatio = species.maleRatio ?? 0;
    final barHeight = isLandscape ? size.height * 0.025 : 12.h;
    final barRadius = isLandscape ? size.height * 0.012 : 6.r;
    final gapMedium = isLandscape ? size.height * 0.03 : 16.h;
    final dividerHeight = isLandscape ? size.height * 0.06 : 30.h;

    return Container(
      padding: EdgeInsets.all(basePadding),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Gender ratio bar
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Container(
                height: barHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(barRadius),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: (maleRatio * value).round(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.male,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(barRadius),
                            right: femaleRatio == 0
                                ? Radius.circular(barRadius)
                                : Radius.zero,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: (femaleRatio * value).round(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.pink[300],
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(barRadius),
                            left: maleRatio == 0
                                ? Radius.circular(barRadius)
                                : Radius.zero,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Gap(gapMedium),
          // Gender labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _GenderLabel(
                icon: Icons.male_rounded,
                color: AppColors.male,
                label: LocaleKeys.detailMale.tr(),
                percentage: maleRatio,
                isLandscape: isLandscape,
              ),
              Container(
                width: 1,
                height: dividerHeight,
                color: theme.dividerColor.withValues(alpha: 0.3),
              ),
              _GenderLabel(
                icon: Icons.female_rounded,
                color: Colors.pink[300]!,
                label: LocaleKeys.detailFemale.tr(),
                percentage: femaleRatio,
                isLandscape: isLandscape,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isLandscape;

  const _SectionTitle({
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

class _GenderLabel extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final double percentage;
  final bool isLandscape;

  const _GenderLabel({
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

class _InfoRow {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });
}
