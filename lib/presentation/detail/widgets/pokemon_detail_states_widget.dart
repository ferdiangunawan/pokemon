import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../core/theme/app_colors.dart';
import '../cubit/index.dart';

/// Loading state widget for Pokemon detail page
class PokemonDetailLoadingWidget extends StatelessWidget {
  const PokemonDetailLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
}

/// Error state widget for Pokemon detail page
class PokemonDetailErrorWidget extends StatelessWidget {
  final int? pokemonId;

  const PokemonDetailErrorWidget({super.key, this.pokemonId});

  @override
  Widget build(BuildContext context) {
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
                  final id =
                      pokemonId ??
                      context.read<PokemonDetailCubit>().state.pokemon?.id ??
                      1;
                  context.read<PokemonDetailCubit>().refresh(id);
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
}
