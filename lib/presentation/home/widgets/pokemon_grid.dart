import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/index.dart';
import '../cubit/index.dart';
import 'pokemon_card.dart';

/// Grid widget displaying Pokemon cards
class PokemonGrid extends StatelessWidget {
  const PokemonGrid({super.key});

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
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return Shimmer.fromColors(
            baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          );
        }, childCount: 10),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(
              'home.error'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                context.read<HomeCubit>().loadPokemons();
              },
              icon: const Icon(Icons.refresh),
              label: Text('home.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.catching_pokemon, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'home.no_results'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPokemonGrid(BuildContext context, HomeState state) {
    final columnCount = ResponsiveUtils.getGridColumnCount(context);
    final pokemons = state.filteredPokemons;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.75,
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

          return PokemonCard(pokemon: pokemons[index]);
        }, childCount: pokemons.length + (state.hasReachedMax ? 0 : 1)),
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
