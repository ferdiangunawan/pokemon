import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                top: 160.h,
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
    final screenHeight = size.height;

    // Use fixed pixel values for landscape to avoid ScreenUtil issues
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
                bottom: -screenHeight * 0.05,
                left: -screenWidth * 0.05,
                child: PokeballWatermarkWidget(
                  size: screenHeight * 0.45,
                  opacity: 0.1,
                ),
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
                          vertical: screenHeight * 0.02,
                          horizontal: screenWidth * 0.02,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PokemonImageWidget(
                              pokemon: pokemon,
                              size: screenHeight * 0.42,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            PokemonTypeChipsWidget(
                              pokemon: pokemon,
                              isLandscape: true,
                            ),
                            SizedBox(height: screenHeight * 0.02),
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
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(screenWidth * 0.05),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(-5, 0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(screenWidth * 0.05),
                  ),
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
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.035,
        vertical: screenHeight * 0.025,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QuickStatItem(
            label: 'Height',
            value: pokemon.formattedHeight,
            icon: Icons.height_rounded,
          ),
          Container(
            width: 1,
            height: screenHeight * 0.05,
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
            color: Colors.white.withValues(alpha: 0.3),
          ),
          QuickStatItem(
            label: 'Weight',
            value: pokemon.formattedWeight,
            icon: Icons.fitness_center_rounded,
          ),
        ],
      ),
    );
  }
}
