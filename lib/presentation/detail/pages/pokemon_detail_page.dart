import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/index.dart';
import '../../../core/index.dart';
import '../../../domain/index.dart';
import '../cubit/index.dart';
import '../widgets/index.dart';
import '../widgets/pokemon_detail_states_widget.dart';

/// Pokemon detail page with tabs for About, Stats, Evolution, Moves
/// Enhanced with animations, responsive layouts, and better UX
class PokemonDetailPage extends StatelessWidget {
  final int pokemonId;
  final Pokemon? pokemon;

  const PokemonDetailPage({super.key, required this.pokemonId, this.pokemon});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PokemonDetailCubit>()
        ..loadPokemonDetail(pokemonId, initialPokemon: pokemon),
      child: const _PokemonDetailContent(),
    );
  }
}

class _PokemonDetailContent extends StatefulWidget {
  const _PokemonDetailContent();

  @override
  State<_PokemonDetailContent> createState() => _PokemonDetailContentState();
}

class _PokemonDetailContentState extends State<_PokemonDetailContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonDetailCubit, PokemonDetailState>(
      builder: (context, state) {
        final pokemon = state.pokemon;

        if (state.pokemonLoadData.isLoading && pokemon == null) {
          return const PokemonDetailLoadingWidget();
        }

        if (state.pokemonLoadData.isError && pokemon == null) {
          return PokemonDetailErrorWidget(
            pokemonId: context.read<PokemonDetailCubit>().state.pokemon?.id,
          );
        }

        if (pokemon == null) return const SizedBox.shrink();

        final primaryType = pokemon.primaryType;
        final typeColor = PokemonTypeColors.getTypeColor(primaryType);
        final theme = Theme.of(context);

        // Set status bar to light for colored background
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

        return Scaffold(
          backgroundColor: typeColor,
          body: SafeArea(
            bottom: false,
            child: OrientationBuilder(
              builder: (context, orientation) {
                final isLandscape = orientation == Orientation.landscape;
                return Column(
                  children: [
                    Expanded(
                      child: _buildContent(context, pokemon, typeColor, state),
                    ),
                    Container(
                      height: MediaQuery.of(context).padding.bottom,
                      color: isLandscape
                          ? typeColor
                          : theme.scaffoldBackgroundColor,
                    ),
                  ],
                );
              },
            ),
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
    return _BodySectionView(
      pokemon: pokemon,
      state: state,
      fadeAnimation: _fadeAnimation,
      slideAnimation: _slideAnimation,
    );
  }
}

class _BodySectionView extends StatelessWidget {
  final Pokemon pokemon;
  final PokemonDetailState state;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const _BodySectionView({
    required this.pokemon,
    required this.state,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return PokemonDetailLandscapeLayoutWidget(
            pokemon: pokemon,
            state: state,
            fadeAnimation: fadeAnimation,
            slideAnimation: slideAnimation,
          );
        } else {
          return PokemonDetailPortraitLayoutWidget(
            pokemon: pokemon,
            state: state,
            fadeAnimation: fadeAnimation,
            slideAnimation: slideAnimation,
          );
        }
      },
    );
  }
}
