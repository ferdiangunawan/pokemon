import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../common/index.dart';
import '../../../domain/index.dart';

/// Header widget for the Pokemon detail page
class PokemonDetailHeaderWidget extends StatelessWidget {
  final Pokemon pokemon;
  final bool isLandscape;

  const PokemonDetailHeaderWidget({
    super.key,
    required this.pokemon,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Use raw values for landscape, ScreenUtil for portrait
    final horizontalPadding = isLandscape ? size.width * 0.02 : 16.w;
    final verticalPadding = isLandscape ? size.height * 0.02 : 12.h;
    final buttonRadius = isLandscape ? 12.0 : 12.r;
    final buttonPadding = isLandscape ? size.height * 0.02 : 10.w;
    final iconSize = isLandscape ? size.height * 0.06 : 24.sp;
    final gap = isLandscape ? size.width * 0.015 : 16.w;
    final titleFontSize = isLandscape ? size.height * 0.055 : 26.sp;
    final badgePaddingH = isLandscape ? size.width * 0.015 : 12.w;
    final badgePaddingV = isLandscape ? size.height * 0.012 : 6.h;
    final badgeFontSize = isLandscape ? size.height * 0.04 : 16.sp;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        children: [
          // Back button with better styling
          Material(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(buttonRadius),
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              },
              borderRadius: BorderRadius.circular(buttonRadius),
              child: Padding(
                padding: EdgeInsets.all(buttonPadding),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: iconSize,
                ),
              ),
            ),
          ),
          SizedBox(width: gap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  pokemon.name.capitalize,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!isLandscape) ...[
                  Gap(6.h),
                  PokemonTypeChipsWidget(pokemon: pokemon),
                ],
              ],
            ),
          ),
          // Pokemon ID badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: badgePaddingH,
              vertical: badgePaddingV,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(buttonRadius),
            ),
            child: Text(
              '#${pokemon.id.toString().padLeft(3, '0')}',
              style: TextStyle(
                color: Colors.white,
                fontSize: badgeFontSize,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget showing Pokemon type chips
class PokemonTypeChipsWidget extends StatelessWidget {
  final Pokemon pokemon;
  final bool isLandscape;

  const PokemonTypeChipsWidget({
    super.key,
    required this.pokemon,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscapeMode = isLandscape || size.width > size.height;

    final spacing = isLandscapeMode ? size.width * 0.01 : 8.w;
    final runSpacing = isLandscapeMode ? size.height * 0.01 : 4.h;
    final paddingH = isLandscapeMode ? size.width * 0.018 : 14.w;
    final paddingV = isLandscapeMode ? size.height * 0.012 : 6.h;
    final borderRadius = isLandscapeMode ? 20.0 : 20.r;
    final fontSize = isLandscapeMode ? size.height * 0.03 : 12.sp;

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: pokemon.types.map((type) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: paddingH,
            vertical: paddingV,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Text(
            type.name.capitalize,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Widget showing Pokemon image with hero animation
class PokemonImageWidget extends StatelessWidget {
  final Pokemon pokemon;
  final double? size;

  const PokemonImageWidget({super.key, required this.pokemon, this.size});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    // If size is provided (landscape), use it directly as raw pixels
    // Otherwise use ScreenUtil for portrait
    final imageSize = size ?? 180;
    final displayHeight = size != null ? size! : imageSize.h;
    final displayWidth = size != null ? size! : imageSize.w;
    final errorIconSize = size != null
        ? size! * 0.6
        : (isLandscape ? screenSize.height * 0.15 : (imageSize * 0.6).sp);

    return Hero(
      tag: 'pokemon-${pokemon.id}',
      flightShuttleBuilder:
          (
            BuildContext flightContext,
            Animation<double> animation,
            HeroFlightDirection flightDirection,
            BuildContext fromHeroContext,
            BuildContext toHeroContext,
          ) {
            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Material(
                  color: Colors.transparent,
                  child: CachedNetworkImage(
                    imageUrl: pokemon.imageUrl,
                    height: displayHeight,
                    width: displayWidth,
                    fit: BoxFit.contain,
                    memCacheWidth: 512,
                    memCacheHeight: 512,
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    errorWidget: (context, url, error) => Icon(
                      Icons.catching_pokemon,
                      size: errorIconSize,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                );
              },
            );
          },
      child: Material(
        color: Colors.transparent,
        child: CachedNetworkImage(
          imageUrl: pokemon.imageUrl,
          height: displayHeight,
          width: displayWidth,
          fit: BoxFit.contain,
          memCacheWidth: 512,
          memCacheHeight: 512,
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          placeholder: (context, url) => SizedBox(
            height: displayHeight,
            width: displayWidth,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Icon(
            Icons.catching_pokemon,
            size: errorIconSize,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

/// Pokeball watermark decoration widget
class PokeballWatermarkWidget extends StatelessWidget {
  final double size;
  final double opacity;
  final AlignmentGeometry alignment;

  const PokeballWatermarkWidget({
    super.key,
    this.size = 200,
    this.opacity = 0.15,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Icon(Icons.catching_pokemon, size: size.sp, color: Colors.white),
    );
  }
}
