import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../common/index.dart';
import '../../../core/index.dart';
import '../cubit/index.dart';
import '../widgets/index.dart';

/// Home page displaying list of Pokemon
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..loadPokemons(),
      child: const _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLandscape = ResponsiveUtils.isLandscape(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: theme.scaffoldBackgroundColor,
              surfaceTintColor: Colors.transparent,
              expandedHeight: isLandscape ? 80.h : 120.h,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'home.title'.tr(),
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              // Language toggle
                              IconButton(
                                icon: const Icon(Icons.language),
                                onPressed: () => _showLanguageDialog(context),
                              ),
                              // Theme toggle
                              BlocBuilder<ThemeCubit, ThemeState>(
                                builder: (context, state) {
                                  return IconButton(
                                    icon: Icon(
                                      state.themeMode == ThemeMode.dark
                                          ? Icons.light_mode
                                          : Icons.dark_mode,
                                    ),
                                    onPressed: () {
                                      context.read<ThemeCubit>().toggleTheme();
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Gap(8.h),
                      const PokemonSearchBar(),
                      Gap(8.h),
                    ],
                  ),
                ),
              ),
            ),
            // Pokemon Grid
            const PokemonGrid(),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('settings.language'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('settings.english'.tr()),
              leading: Radio<Locale>(
                value: const Locale('en'),
                groupValue: context.locale,
                onChanged: (value) {
                  if (value != null) {
                    context.setLocale(value);
                    Navigator.pop(context);
                  }
                },
              ),
              onTap: () {
                context.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('settings.indonesian'.tr()),
              leading: Radio<Locale>(
                value: const Locale('id'),
                groupValue: context.locale,
                onChanged: (value) {
                  if (value != null) {
                    context.setLocale(value);
                    Navigator.pop(context);
                  }
                },
              ),
              onTap: () {
                context.setLocale(const Locale('id'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
