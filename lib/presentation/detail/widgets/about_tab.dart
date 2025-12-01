import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../common/index.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/index.dart';

/// About tab showing Pokemon details with enhanced design
class AboutTab extends StatefulWidget {
  final Pokemon pokemon;
  final PokemonSpecies? species;

  const AboutTab({super.key, required this.pokemon, this.species});

  @override
  State<AboutTab> createState() => _AboutTabState();
}

class _AboutTabState extends State<AboutTab>
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

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
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
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16.r),
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
                      size: 24.sp,
                    ),
                    Gap(12.w),
                    Expanded(
                      child: Text(
                        widget.species!.description!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(
                            0.8,
                          ),
                          height: 1.6,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap(24.h),
          ],

          // Basic info section with staggered animation
          _buildInfoSection(context, primaryColor, [
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
          Gap(24.h),

          // Gender section with visual progress bar
          if (widget.species != null) ...[
            _SectionTitle(
              title: LocaleKeys.detailGender.tr(),
              icon: Icons.wc_rounded,
            ),
            Gap(12.h),
            _buildGenderInfo(context, widget.species!, primaryColor),
            Gap(24.h),
          ],

          // Egg groups with chips
          if (widget.species != null &&
              widget.species!.eggGroups.isNotEmpty) ...[
            _SectionTitle(
              title: LocaleKeys.detailEggGroups.tr(),
              icon: Icons.egg_rounded,
            ),
            Gap(12.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 8.h,
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
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primaryColor.withValues(alpha: 0.1),
                          primaryColor.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      entry.value.toReadable,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: 13.sp,
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
    List<_InfoRow> rows,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
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
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(row.icon, size: 18.sp, color: primaryColor),
                      ),
                      Gap(14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              row.label,
                              style: TextStyle(
                                color: theme.hintColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Gap(4.h),
                            Text(
                              row.value,
                              style: TextStyle(
                                color: theme.textTheme.bodyLarge?.color,
                                fontSize: 15.sp,
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
  ) {
    final theme = Theme.of(context);

    if (species.isGenderless) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
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
            Icon(Icons.not_interested_rounded, color: Colors.grey, size: 20.sp),
            Gap(8.w),
            Text(
              LocaleKeys.detailGenderless.tr(),
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    final femaleRatio = species.femaleRatio ?? 0;
    final maleRatio = species.maleRatio ?? 0;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
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
                height: 12.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: (maleRatio * value).round(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.male,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(6.r),
                            right: femaleRatio == 0
                                ? Radius.circular(6.r)
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
                            right: Radius.circular(6.r),
                            left: maleRatio == 0
                                ? Radius.circular(6.r)
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
          Gap(16.h),
          // Gender labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _GenderLabel(
                icon: Icons.male_rounded,
                color: AppColors.male,
                label: LocaleKeys.detailMale.tr(),
                percentage: maleRatio,
              ),
              Container(
                width: 1,
                height: 30.h,
                color: theme.dividerColor.withValues(alpha: 0.3),
              ),
              _GenderLabel(
                icon: Icons.female_rounded,
                color: Colors.pink[300]!,
                label: LocaleKeys.detailFemale.tr(),
                percentage: femaleRatio,
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

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20.sp, color: theme.hintColor),
        Gap(8.w),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
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

  const _GenderLabel({
    required this.icon,
    required this.color,
    required this.label,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 22.sp),
            Gap(6.w),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
            ),
          ],
        ),
        Gap(4.h),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
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
