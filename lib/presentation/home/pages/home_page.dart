import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../core/index.dart';
import '../cubit/index.dart';
import '../widgets/index.dart';

/// Home page displaying list of Pokemon with enhanced UI
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

class _HomePageContent extends StatefulWidget {
  const _HomePageContent();

  @override
  State<_HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<_HomePageContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Set status bar style based on theme
    SystemChrome.setSystemUIOverlayStyle(
      isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Unfocus any focused widget when tapping outside
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: OrientationBuilder(
              builder: (context, orientation) {
                final isLandscape = orientation == Orientation.landscape;
                final size = MediaQuery.of(context).size;

                // Use raw values for landscape, ScreenUtil for portrait
                final horizontalPadding = isLandscape
                    ? size.width * 0.025
                    : 20.w;
                final iconPadding = isLandscape ? size.width * 0.01 : 8.w;
                final iconRadius = isLandscape ? 12.0 : 12.r;
                final iconSize = isLandscape ? size.height * 0.055 : 24.sp;
                final titleGap = isLandscape ? size.width * 0.012 : 12.w;
                final searchGap = isLandscape ? size.height * 0.025 : 16.h;
                final bottomGap = isLandscape ? size.height * 0.02 : 12.h;
                final appBarHeight = isLandscape ? size.height * 0.35 : 140.h;

                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<HomeCubit>().loadPokemons();
                  },
                  color: theme.primaryColor,
                  backgroundColor: theme.cardColor,
                  displacement: 60,
                  strokeWidth: 3,
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      // App Bar
                      SliverAppBar(
                        floating: true,
                        snap: true,
                        backgroundColor: theme.scaffoldBackgroundColor,
                        surfaceTintColor: Colors.transparent,
                        expandedHeight: appBarHeight,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Title with icon
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(iconPadding),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                theme.primaryColor,
                                                theme.primaryColor.withValues(
                                                  alpha: 0.8,
                                                ),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              iconRadius,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: theme.primaryColor
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.catching_pokemon,
                                            color: Colors.white,
                                            size: iconSize,
                                          ),
                                        ),
                                        SizedBox(width: titleGap),
                                        Text(
                                          LocaleKeys.homeTitle.tr(),
                                          style: theme.textTheme.headlineMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: -0.5,
                                                fontSize: isLandscape
                                                    ? size.height * 0.06
                                                    : null,
                                              ),
                                        ),
                                      ],
                                    ),
                                    // Action buttons
                                    Row(
                                      children: [
                                        HomeActionButton(
                                          icon: Icons.language_rounded,
                                          onPressed: () =>
                                              _showLanguageDialog(context),
                                          isLandscape: isLandscape,
                                        ),
                                        SizedBox(
                                          width: isLandscape
                                              ? size.width * 0.01
                                              : 8.w,
                                        ),
                                        BlocBuilder<ThemeCubit, ThemeState>(
                                          builder: (context, state) {
                                            return HomeActionButton(
                                              icon:
                                                  state.themeMode ==
                                                      ThemeMode.dark
                                                  ? Icons.light_mode_rounded
                                                  : Icons.dark_mode_rounded,
                                              onPressed: () {
                                                HapticFeedback.lightImpact();
                                                context
                                                    .read<ThemeCubit>()
                                                    .toggleTheme();
                                              },
                                              isLandscape: isLandscape,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: searchGap),
                                PokemonSearchBarWidget(
                                  isLandscape: isLandscape,
                                ),
                                SizedBox(height: bottomGap),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Pokemon Grid
                      PokemonGridWidget(isLandscape: isLandscape),
                      // Bottom spacing
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: isLandscape ? size.height * 0.05 : 20.h,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    HapticFeedback.lightImpact();
    final theme = Theme.of(context);
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    if (isLandscape) {
      final size = MediaQuery.of(context).size;
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: theme.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: size.width * 0.35,
            constraints: BoxConstraints(maxWidth: 320),
            padding: EdgeInsets.all(size.height * 0.04),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.settingsLanguage.tr(),
                  style: TextStyle(
                    fontSize: size.height * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                _LandscapeLanguageOption(
                  title: LocaleKeys.settingsEnglish.tr(),
                  subtitle: 'English',
                  locale: const Locale('en'),
                  isSelected: context.locale == const Locale('en'),
                ),
                SizedBox(height: size.height * 0.02),
                _LandscapeLanguageOption(
                  title: LocaleKeys.settingsIndonesian.tr(),
                  subtitle: 'Bahasa Indonesia',
                  locale: const Locale('id'),
                  isSelected: context.locale == const Locale('id'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: theme.hintColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  Gap(20.h),
                  Text(
                    LocaleKeys.settingsLanguage.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(20.h),
                  LanguageOptionTile(
                    title: LocaleKeys.settingsEnglish.tr(),
                    subtitle: 'English',
                    locale: const Locale('en'),
                    isSelected: context.locale == const Locale('en'),
                  ),
                  Gap(12.h),
                  LanguageOptionTile(
                    title: LocaleKeys.settingsIndonesian.tr(),
                    subtitle: 'Bahasa Indonesia',
                    locale: const Locale('id'),
                    isSelected: context.locale == const Locale('id'),
                  ),
                  Gap(16.h),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

/// Landscape-specific language option widget using raw pixel values
class _LandscapeLanguageOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final Locale locale;
  final bool isSelected;

  const _LandscapeLanguageOption({
    required this.title,
    required this.subtitle,
    required this.locale,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    final titleColor = isSelected
        ? (isDark ? Colors.white : theme.primaryColor)
        : (isDark ? Colors.white : theme.textTheme.titleMedium?.color);
    final subtitleColor = isDark
        ? Colors.white.withValues(alpha: 0.7)
        : theme.hintColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          context.setLocale(locale);
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.height * 0.03,
            vertical: size.height * 0.025,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                      ? Colors.red.withValues(alpha: 0.25)
                      : theme.primaryColor.withValues(alpha: 0.1))
                : (isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : theme.cardColor),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? (isDark ? Colors.red : theme.primaryColor)
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : theme.dividerColor.withValues(alpha: 0.3)),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: size.height * 0.04,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: titleColor,
                      ),
                    ),
                    SizedBox(height: size.height * 0.005),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: size.height * 0.03,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: isSelected
                    ? (isDark ? Colors.red : theme.primaryColor)
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.4)
                          : theme.hintColor.withValues(alpha: 0.5)),
                size: size.height * 0.055,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
