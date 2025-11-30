import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../common/index.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/index.dart';

/// Evolution tab showing Pokemon evolution chain with enhanced animations
class EvolutionTab extends StatefulWidget {
  final EvolutionChain? evolution;

  const EvolutionTab({super.key, this.evolution});

  @override
  State<EvolutionTab> createState() => _EvolutionTabState();
}

class _EvolutionTabState extends State<EvolutionTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    if (widget.evolution == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40.w,
              height: 40.h,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: theme.primaryColor,
              ),
            ),
            Gap(16.h),
            Text(
              LocaleKeys.commonLoading.tr(),
              style: TextStyle(color: theme.hintColor),
            ),
          ],
        ),
      );
    }

    if (widget.evolution!.chain.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: theme.hintColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.catching_pokemon,
                size: 48.sp,
                color: theme.hintColor.withValues(alpha: 0.5),
              ),
            ),
            Gap(16.h),
            Text(
              LocaleKeys.detailNoEvolution.tr(),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: _buildEvolutionTree(context, widget.evolution!.chain.first, 0),
    );
  }

  Widget _buildEvolutionTree(
    BuildContext context,
    EvolutionStage stage,
    int index,
  ) {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          key: ValueKey('evolution_card_${stage.pokemonId}'),
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 150)),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: _EvolutionCard(stage: stage),
        ),
        if (stage.evolvesTo.isNotEmpty) ...[
          ...stage.evolvesTo.asMap().entries.map((entry) {
            return Column(
              key: ValueKey('evolution_entry_${entry.value.pokemonId}'),
              children: [
                _EvolutionArrow(
                  minLevel: entry.value.minLevel,
                  trigger: entry.value.trigger,
                  item: entry.value.item,
                  index: index + entry.key,
                ),
                _buildEvolutionTree(
                  context,
                  entry.value,
                  index + entry.key + 1,
                ),
              ],
            );
          }),
        ],
      ],
    );
  }
}

class _EvolutionCard extends StatefulWidget {
  final EvolutionStage stage;

  const _EvolutionCard({required this.stage});

  @override
  State<_EvolutionCard> createState() => _EvolutionCardState();
}

class _EvolutionCardState extends State<_EvolutionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        context.push('/pokemon/${widget.stage.pokemonId}');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isPressed ? 0.08 : 0.12),
              blurRadius: _isPressed ? 8 : 16,
              offset: Offset(0, _isPressed ? 2 : 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Pokemon image with subtle animation
            Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        theme.primaryColor.withValues(alpha: 0.1),
                        theme.primaryColor.withValues(alpha: 0.02),
                      ],
                    ),
                  ),
                ),
                CachedNetworkImage(
                  imageUrl:
                      widget.stage.imageUrl ??
                      ApiConstants.getOfficialArtworkUrl(
                        widget.stage.pokemonId,
                      ),
                  height: 90.h,
                  width: 90.w,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => SizedBox(
                    height: 90.h,
                    width: 90.w,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.catching_pokemon,
                    size: 60.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Gap(12.h),
            // Pokemon name
            Text(
              widget.stage.pokemonName.capitalize,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                letterSpacing: -0.3,
              ),
            ),
            Gap(4.h),
            // Pokemon ID badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '#${widget.stage.pokemonId.toString().padLeft(3, '0')}',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EvolutionArrow extends StatelessWidget {
  final int? minLevel;
  final String? trigger;
  final String? item;
  final int index;

  const _EvolutionArrow({
    this.minLevel,
    this.trigger,
    this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Column(
          children: [
            // Arrow with animation line
            Container(
              width: 2,
              height: 30.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.primaryColor.withValues(alpha: 0.3),
                    theme.primaryColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_downward_rounded,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
            Gap(8.h),
            // Evolution info container
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (minLevel != null) ...[
                    Icon(
                      Icons.trending_up_rounded,
                      size: 16.sp,
                      color: theme.primaryColor,
                    ),
                    Gap(6.w),
                    Text(
                      'Lv. $minLevel',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: theme.textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (item != null) ...[
                    if (minLevel != null) Gap(12.w),
                    Icon(
                      Icons.inventory_2_rounded,
                      size: 16.sp,
                      color: Colors.amber[700],
                    ),
                    Gap(6.w),
                    Text(
                      item!.toReadable,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: theme.textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  if (trigger != null &&
                      trigger != 'level-up' &&
                      item == null) ...[
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 16.sp,
                      color: AppColors.purple400,
                    ),
                    Gap(6.w),
                    Text(
                      trigger!.toReadable,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: theme.hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
