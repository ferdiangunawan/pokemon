import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../common/index.dart';
import '../../shared/index.dart';
import '../cubit/index.dart';
import 'pokemon_card_widget.dart';

/// Grid widget displaying Pokemon cards with staggered animations
class PokemonGrid extends StatelessWidget {
  final bool isLandscape;

  const PokemonGrid({super.key, this.isLandscape = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // Loading state
        if (state.pokemonsLoadData.isLoading) {
          return _buildLoadingGrid(context);
        }

        // Error state
        if (state.pokemonsLoadData.isError) {
          return _buildErrorState(context, state.pokemonsLoadData.message);
        }

        // Empty state
        if (state.filteredPokemons.isEmpty &&
            state.pokemonsLoadData.isHasData) {
          return _buildEmptyState(context);
        }

        // Data state
        return _buildPokemonGrid(context, state);
      },
    );
  }

  Widget _buildLoadingGrid(BuildContext context) {
    final columnCount = ResponsiveUtils.getGridColumnCount(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: ResponsiveUtils.getCardAspectRatio(context),
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return AnimatedGridItem(
            index: index,
            child: Shimmer.fromColors(
              baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          );
        }, childCount: 10),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final theme = Theme.of(context);

    return SliverFillRemaining(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon with animation
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline_rounded,
                    size: 48.sp,
                    color: Colors.red[400],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                LocaleKeys.homeError.tr(),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
              ),
              SizedBox(height: 32.h),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<HomeCubit>().loadPokemons();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 16.h,
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: Text(LocaleKeys.homeRetry.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return SliverFillRemaining(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.catching_pokemon,
                    size: 56.sp,
                    color: theme.primaryColor.withOpacity(0.6),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                LocaleKeys.homeNoResults.tr(),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Try searching for a different Pokémon',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPokemonGrid(BuildContext context, HomeState state) {
    final columnCount = ResponsiveUtils.getGridColumnCount(context);
    final pokemons = state.filteredPokemons;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: ResponsiveUtils.getCardAspectRatio(context),
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          // Load more trigger
          if (index >= pokemons.length) {
            if (state.isLoadingMore) {
              return _buildLoadingIndicator(context);
            }
            // Trigger load more
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted && state.searchQuery.isEmpty) {
                context.read<HomeCubit>().loadMorePokemons();
              }
            });
            return const SizedBox.shrink();
          }

          return AnimatedGridItem(
            index: index,
            child: PokemonCard(pokemon: pokemons[index], index: index),
          );
        }, childCount: pokemons.length + (state.hasReachedMax ? 0 : 1)),
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: SizedBox(
          width: 24.w,
          height: 24.h,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
