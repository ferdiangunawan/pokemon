import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/index.dart';
import '../cubit/index.dart';
import 'pokemon_card_widget.dart';
import 'pokemon_grid_states_widget.dart';

/// Widget displaying Pokemon grid content with cards and pagination
class PokemonGridContentWidget extends StatelessWidget {
  final int columnCount;
  final double childAspectRatio;

  const PokemonGridContentWidget({
    super.key,
    required this.columnCount,
    required this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final pokemons = state.filteredPokemons;

        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
              childAspectRatio: childAspectRatio,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              // Load more trigger
              if (index >= pokemons.length) {
                if (state.isLoadingMore) {
                  return const PokemonPaginationLoadingWidget();
                }
                // Trigger load more
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted && state.searchQuery.isEmpty) {
                    context.read<HomeCubit>().loadMorePokemons();
                  }
                });
                return const SizedBox.shrink();
              }

              return AnimatedGridItemWidget(
                index: index,
                child: PokemonCardWidget(
                  pokemon: pokemons[index],
                  index: index,
                ),
              );
            }, childCount: pokemons.length + (state.hasReachedMax ? 0 : 1)),
          ),
        );
      },
    );
  }
}
