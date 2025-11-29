import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../common/index.dart';
import '../../../core/index.dart';
import '../../../domain/index.dart';
import '../cubit/index.dart';
import '../widgets/index.dart';

/// Pokemon detail page with tabs for About, Stats, Evolution, Moves
class PokemonDetailPage extends StatelessWidget {
  final int pokemonId;
  final Pokemon? pokemon;

  const PokemonDetailPage({super.key, required this.pokemonId, this.pokemon});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<PokemonDetailCubit>()
            ..loadPokemonDetail(pokemonId, initialPokemon: pokemon),
      child: const _PokemonDetailContent(),
    );
  }
}

class _PokemonDetailContent extends StatelessWidget {
  const _PokemonDetailContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonDetailCubit, PokemonDetailState>(
      builder: (context, state) {
        final pokemon = state.pokemon;

        if (state.pokemonLoadData.isLoading && pokemon == null) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        }

        if (state.pokemonLoadData.isError && pokemon == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                  Gap(16.h),
                  Text('common.error'.tr()),
                  Gap(16.h),
                  ElevatedButton(
                    onPressed: () {
                      final pokemonId =
                          context
                              .read<PokemonDetailCubit>()
                              .state
                              .pokemon
                              ?.id ??
                          1;
                      context.read<PokemonDetailCubit>().refresh(pokemonId);
                    },
                    child: Text('home.retry'.tr()),
                  ),
                ],
              ),
            ),
          );
        }

        if (pokemon == null) return const SizedBox.shrink();

        final primaryType = pokemon.primaryType;
        final typeColor = PokemonTypeColors.getTypeColor(primaryType);

        return Scaffold(
          backgroundColor: typeColor,
          body: SafeArea(
            child: _buildContent(context, pokemon, typeColor, state),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    Pokemon pokemon,
    Color typeColor,
    PokemonDetailState state,
  ) {
    final isLandscape = ResponsiveUtils.isLandscape(context);

    if (isLandscape) {
      return _buildLandscapeLayout(context, pokemon, typeColor, state);
    }
    return _buildPortraitLayout(context, pokemon, typeColor, state);
  }

  Widget _buildPortraitLayout(
    BuildContext context,
    Pokemon pokemon,
    Color typeColor,
    PokemonDetailState state,
  ) {
    return Column(
      children: [
        // Header
        _buildHeader(context, pokemon),
        // Pokemon image and info
        Expanded(
          child: Stack(
            children: [
              // White background container
              Positioned.fill(
                top: 180.h,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 80.h),
                    child: _buildTabContent(context, pokemon, state),
                  ),
                ),
              ),
              // Pokemon image
              Positioned(
                top: 20.h,
                left: 0,
                right: 0,
                child: _buildPokemonImage(pokemon),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(
    BuildContext context,
    Pokemon pokemon,
    Color typeColor,
    PokemonDetailState state,
  ) {
    return Row(
      children: [
        // Left side - Pokemon info
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildHeader(context, pokemon),
              Expanded(
                child: Center(child: _buildPokemonImage(pokemon, size: 200)),
              ),
              _buildTypeChips(pokemon),
              Gap(16.h),
            ],
          ),
        ),
        // Right side - Tab content
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(32.r),
              ),
            ),
            child: _buildTabContent(context, pokemon, state),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, Pokemon pokemon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pokemon.name.capitalize,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!ResponsiveUtils.isLandscape(context))
                  _buildTypeChips(pokemon),
              ],
            ),
          ),
          Text(
            '#${pokemon.id.toString().padLeft(3, '0')}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChips(Pokemon pokemon) {
    return Wrap(
      spacing: 8.w,
      children: pokemon.types.map((type) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            type.name.capitalize,
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPokemonImage(Pokemon pokemon, {double? size}) {
    final imageSize = size ?? 200;
    return Hero(
      tag: 'pokemon-${pokemon.id}',
      child: CachedNetworkImage(
        imageUrl: pokemon.imageUrl,
        height: imageSize.h,
        width: imageSize.w,
        fit: BoxFit.contain,
        placeholder: (context, url) => SizedBox(
          height: imageSize.h,
          width: imageSize.w,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.catching_pokemon,
          size: (imageSize * 0.6).sp,
          color: Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    Pokemon pokemon,
    PokemonDetailState state,
  ) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: 'detail.about'.tr()),
              Tab(text: 'detail.base_stats'.tr()),
              Tab(text: 'detail.evolution'.tr()),
              Tab(text: 'detail.moves'.tr()),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                AboutTab(pokemon: pokemon, species: state.species),
                StatsTab(pokemon: pokemon),
                EvolutionTab(evolution: state.evolution),
                MovesTab(pokemon: pokemon),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
