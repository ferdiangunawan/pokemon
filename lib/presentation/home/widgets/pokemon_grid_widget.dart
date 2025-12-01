import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/index.dart';
import '../cubit/index.dart';
import 'pokemon_grid_content_widget.dart';
import 'pokemon_grid_states_widget.dart';

/// Grid widget displaying Pokemon cards with staggered animations
class PokemonGridWidget extends StatelessWidget {
  final bool isLandscape;

  const PokemonGridWidget({super.key, this.isLandscape = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final columnCount = ResponsiveUtils.getGridColumnCount(context);
        final childAspectRatio = ResponsiveUtils.getCardAspectRatio(context);

        // Loading state
        if (state.pokemonsLoadData.isLoading) {
          return PokemonLoadingGridWidget(
            columnCount: columnCount,
            childAspectRatio: childAspectRatio,
          );
        }

        // Error state
        if (state.pokemonsLoadData.isError) {
          return PokemonGridErrorWidget(
            message: state.pokemonsLoadData.message,
          );
        }

        // Empty state
        if (state.filteredPokemons.isEmpty &&
            state.pokemonsLoadData.isHasData) {
          return const PokemonGridEmptyWidget();
        }

        // Data state
        return PokemonGridContentWidget(
          columnCount: columnCount,
          childAspectRatio: childAspectRatio,
        );
      },
    );
  }
}
