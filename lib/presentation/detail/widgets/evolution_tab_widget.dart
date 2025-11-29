import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../common/index.dart';
import '../../../domain/index.dart';

/// Evolution tab showing Pokemon evolution chain with enhanced animations
class EvolutionTab extends StatefulWidget {
  final EvolutionChain? evolution;
  final bool isLandscape;

  const EvolutionTab({super.key, this.evolution, this.isLandscape = false});

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
    final size = MediaQuery.of(context).size;
    final isLandscape = widget.isLandscape;

    // Responsive sizing
    final loaderSize = isLandscape ? size.height * 0.08 : 40.w;
    final loaderHeight = isLandscape ? size.height * 0.08 : 40.h;
    final iconSize = isLandscape ? size.height * 0.1 : 48.sp;
    final gapHeight = isLandscape ? size.height * 0.03 : 16.h;
    final basePadding = isLandscape ? size.width * 0.015 : 16.w;
    final containerPadding = isLandscape ? size.width * 0.025 : 24.w;

    if (widget.evolution == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: loaderSize,
              height: loaderHeight,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: theme.primaryColor,
              ),
            ),
            SizedBox(height: gapHeight),
            Text(
              LocaleKeys.commonLoading.tr(),
              style: TextStyle(
                color: theme.hintColor,
                fontSize: isLandscape ? size.height * 0.032 : null,
              ),
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
              padding: EdgeInsets.all(containerPadding),
              decoration: BoxDecoration(
                color: theme.hintColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.catching_pokemon,
                size: iconSize,
                color: theme.hintColor.withOpacity(0.5),
              ),
            ),
            SizedBox(height: gapHeight),
            Text(
              LocaleKeys.detailNoEvolution.tr(),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.hintColor,
                fontSize: isLandscape ? size.height * 0.035 : null,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(basePadding),
      child: _buildEvolutionTree(
        context,
        widget.evolution!.chain.first,
        0,
        isLandscape,
      ),
    );
  }

  Widget _buildEvolutionTree(
    BuildContext context,
    EvolutionStage stage,
    int index,
    bool isLandscape,
  ) {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          key: ValueKey('evolution_card_${stage.pokemonId}'),
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 150)),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            // Clamp value to ensure it stays within valid range
            final clampedValue = value.clamp(0.0, 1.0);
            return Transform.scale(
              scale: 0.8 + (0.2 * clampedValue),
              child: Opacity(opacity: clampedValue, child: child),
            );
          },
          child: _EvolutionCard(stage: stage, isLandscape: isLandscape),
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
                  isLandscape: isLandscape,
                ),
                _buildEvolutionTree(
                  context,
                  entry.value,
                  index + entry.key + 1,
                  isLandscape,
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
  final bool isLandscape;

  const _EvolutionCard({required this.stage, this.isLandscape = false});

  @override
  State<_EvolutionCard> createState() => _EvolutionCardState();
}

class _EvolutionCardState extends State<_EvolutionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isLandscape = widget.isLandscape;

    // Responsive sizing
    final cardPadding = isLandscape ? size.width * 0.02 : 20.w;
    final borderRadius = isLandscape ? 20.0 : 20.r;
    final circleSize = isLandscape ? size.height * 0.18 : 100.w;
    final imageSize = isLandscape ? size.height * 0.16 : 90.w;
    final nameFontSize = isLandscape ? size.height * 0.038 : 16.sp;
    final idFontSize = isLandscape ? size.height * 0.028 : 12.sp;
    final gapSmall = isLandscape ? size.height * 0.02 : 12.h;
    final gapTiny = isLandscape ? size.height * 0.008 : 4.h;
    final badgePaddingH = isLandscape ? size.width * 0.01 : 10.w;
    final badgePaddingV = isLandscape ? size.height * 0.008 : 4.h;
    final badgeRadius = isLandscape ? 12.0 : 12.r;
    final errorIconSize = isLandscape ? size.height * 0.12 : 60.sp;

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
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isPressed ? 0.08 : 0.12),
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
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        theme.primaryColor.withOpacity(0.1),
                        theme.primaryColor.withOpacity(0.02),
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
                  height: imageSize,
                  width: imageSize,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => SizedBox(
                    height: imageSize,
                    width: imageSize,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.catching_pokemon,
                    size: errorIconSize,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: gapSmall),
            // Pokemon name
            Text(
              widget.stage.pokemonName.capitalize,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: nameFontSize,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: gapTiny),
            // Pokemon ID badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: badgePaddingH,
                vertical: badgePaddingV,
              ),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(badgeRadius),
              ),
              child: Text(
                '#${widget.stage.pokemonId.toString().padLeft(3, '0')}',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: idFontSize,
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
  final bool isLandscape;

  const _EvolutionArrow({
    this.minLevel,
    this.trigger,
    this.item,
    required this.index,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // Responsive sizing
    final verticalPadding = isLandscape ? size.height * 0.025 : 12.h;
    final lineHeight = isLandscape ? size.height * 0.06 : 30.h;
    final circlePadding = isLandscape ? size.width * 0.008 : 8.w;
    final arrowIconSize = isLandscape ? size.height * 0.04 : 18.sp;
    final gapHeight = isLandscape ? size.height * 0.015 : 8.h;
    final infoPaddingH = isLandscape ? size.width * 0.015 : 16.w;
    final infoPaddingV = isLandscape ? size.height * 0.015 : 8.h;
    final borderRadius = isLandscape ? 12.0 : 12.r;
    final iconSize = isLandscape ? size.height * 0.035 : 16.sp;
    final fontSize = isLandscape ? size.height * 0.03 : 13.sp;
    final smallFontSize = isLandscape ? size.height * 0.028 : 12.sp;
    final gapWidth = isLandscape ? size.width * 0.006 : 6.w;
    final gapWidthMedium = isLandscape ? size.width * 0.012 : 12.w;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        // Clamp value to ensure it stays within valid range
        final clampedValue = value.clamp(0.0, 1.0);
        return Opacity(opacity: clampedValue, child: child);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: Column(
          children: [
            // Arrow with animation line
            Container(
              width: 2,
              height: lineHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.primaryColor.withOpacity(0.3),
                    theme.primaryColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            Container(
              padding: EdgeInsets.all(circlePadding),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_downward_rounded,
                color: Colors.white,
                size: arrowIconSize,
              ),
            ),
            SizedBox(height: gapHeight),
            // Evolution info container
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: infoPaddingH,
                vertical: infoPaddingV,
              ),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (minLevel != null) ...[
                    Icon(
                      Icons.trending_up_rounded,
                      size: iconSize,
                      color: theme.primaryColor,
                    ),
                    SizedBox(width: gapWidth),
                    Text(
                      'Lv. $minLevel',
                      style: TextStyle(
                        fontSize: fontSize,
                        color: theme.textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (item != null) ...[
                    if (minLevel != null) SizedBox(width: gapWidthMedium),
                    Icon(
                      Icons.inventory_2_rounded,
                      size: iconSize,
                      color: Colors.amber[700],
                    ),
                    SizedBox(width: gapWidth),
                    Text(
                      item!.toReadable,
                      style: TextStyle(
                        fontSize: fontSize,
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
                      size: iconSize,
                      color: Colors.purple[400],
                    ),
                    SizedBox(width: gapWidth),
                    Text(
                      trigger!.toReadable,
                      style: TextStyle(
                        fontSize: smallFontSize,
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
