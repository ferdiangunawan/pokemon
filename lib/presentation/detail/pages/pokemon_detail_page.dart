import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../common/index.dart';
import '../../../core/index.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/index.dart';
import '../cubit/index.dart';
import '../widgets/index.dart';

/// Pokemon detail page with tabs for About, Stats, Evolution, Moves
/// Enhanced with animations, responsive layouts, and better UX
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
          return _buildLoadingState(context);
        }

        if (state.pokemonLoadData.isError && pokemon == null) {
          return _buildErrorState(context, state);
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

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.2),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Icon(
                    Icons.catching_pokemon,
                    size: 64.sp,
                    color: theme.primaryColor.withValues(alpha: 0.6),
                  ),
                );
              },
            ),
            Gap(16.h),
            SizedBox(
              width: 40.w,
              height: 40.h,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, PokemonDetailState state) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 48.sp,
                  color: AppColors.red400,
                ),
              ),
              Gap(24.h),
              Text(
                LocaleKeys.commonError.tr(),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(24.h),
              ElevatedButton.icon(
                onPressed: () {
                  final pokemonId =
                      context.read<PokemonDetailCubit>().state.pokemon?.id ?? 1;
                  context.read<PokemonDetailCubit>().refresh(pokemonId);
                },
                icon: const Icon(Icons.refresh_rounded),
                label: Text(LocaleKeys.homeRetry.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Pokemon pokemon,
    Color typeColor,
    PokemonDetailState state,
  ) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return PokemonDetailLandscapeLayoutWidget(
            pokemon: pokemon,
            state: state,
            fadeAnimation: _fadeAnimation,
            slideAnimation: _slideAnimation,
          );
        } else {
          return PokemonDetailPortraitLayoutWidget(
            pokemon: pokemon,
            state: state,
            fadeAnimation: _fadeAnimation,
            slideAnimation: _slideAnimation,
          );
        }
      },
    );
  }
}
