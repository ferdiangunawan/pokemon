import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../domain/index.dart';
import '../cubit/index.dart';
import '../widgets/quick_stat_item.dart';
import 'pokemon_detail_header_widget.dart';
import 'pokemon_detail_tab_content_widget.dart';

/// Portrait layout for Pokemon detail page
class PokemonDetailPortraitLayoutWidget extends StatelessWidget {
  final Pokemon pokemon;
  final PokemonDetailState state;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const PokemonDetailPortraitLayoutWidget({
    super.key,
    required this.pokemon,
    required this.state,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Header
        PokemonDetailHeaderWidget(pokemon: pokemon),
        // Pokemon image and info
        Expanded(
          child: Stack(
            children: [
              // White background container with tabs
              Positioned.fill(
                top: 100.h,
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(36.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 60.h),
                        child: PokemonDetailTabContentWidget(
                          pokemon: pokemon,
                          state: state,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Pokemon image - positioned above the white container
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: PokemonImageWidget(pokemon: pokemon),
              ),
              // Pokeball watermark
              Positioned(
                top: 40.h,
                right: -40.w,
                child: const PokeballWatermarkWidget(size: 200),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Landscape layout for Pokemon detail page
class PokemonDetailLandscapeLayoutWidget extends StatelessWidget {
  final Pokemon pokemon;
  final PokemonDetailState state;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const PokemonDetailLandscapeLayoutWidget({
    super.key,
    required this.pokemon,
    required this.state,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;

    // Use ScreenUtil for consistent sizing
    final leftPanelWidth = screenWidth * 0.42;

    return Row(
      children: [
        // Left side - Pokemon info with gradient background
        SizedBox(
          width: leftPanelWidth,
          child: Stack(
            children: [
              // Pokeball watermark
              Positioned(
                bottom: -40.h,
                left: -40.w,
                child: PokeballWatermarkWidget(size: 180.h, opacity: 0.1),
              ),
              // Content
              Column(
                children: [
                  PokemonDetailHeaderWidget(
                    pokemon: pokemon,
                    isLandscape: true,
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 12.w,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PokemonImageWidget(pokemon: pokemon, size: 200.h),
                            Gap(12.h),
                            PokemonTypeChipsWidget(
                              pokemon: pokemon,
                              isLandscape: true,
                            ),
                            Gap(12.h),
                            // Pokemon stats summary in landscape
                            _buildQuickStats(context, pokemon),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Right side - Tab content
        Expanded(
          child: FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(-5, 0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: PokemonDetailTabContentWidget(
                    pokemon: pokemon,
                    state: state,
                    isLandscape: true,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context, Pokemon pokemon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: QuickStatItem(
              label: LocaleKeys.detailHeight.tr(),
              value: pokemon.formattedHeight,
              icon: Icons.height_rounded,
              isLandscape: true,
            ),
          ),
          Container(
            width: 1,
            height: 32,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.white.withValues(alpha: 0.3),
          ),
          Flexible(
            child: QuickStatItem(
              label: LocaleKeys.detailWeight.tr(),
              value: pokemon.formattedWeight,
              icon: Icons.fitness_center_rounded,
              isLandscape: true,
            ),
          ),
        ],
      ),
    );
  }
}
