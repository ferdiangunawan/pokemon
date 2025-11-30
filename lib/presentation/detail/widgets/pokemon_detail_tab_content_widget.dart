import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../domain/index.dart';
import '../cubit/index.dart';
import 'about_tab_widget.dart';
import 'evolution_tab_widget.dart';
import 'moves_tab_widget.dart';
import 'stats_tab_widget.dart';

/// Tab content widget for Pokemon detail page
class PokemonDetailTabContentWidget extends StatelessWidget {
  final Pokemon pokemon;
  final PokemonDetailState state;
  final bool isLandscape;

  const PokemonDetailTabContentWidget({
    super.key,
    required this.pokemon,
    required this.state,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // Use raw values for landscape, ScreenUtil for portrait
    final marginH = isLandscape ? size.width * 0.015 : 16.w;
    final marginV = isLandscape ? size.height * 0.015 : 8.h;
    final borderRadius = isLandscape ? 16.0 : 16.r;
    final indicatorRadius = isLandscape ? 12.0 : 12.r;
    final indicatorPadding = isLandscape ? size.width * 0.005 : 4.w;
    final labelFontSize = isLandscape ? size.height * 0.035 : 13.sp;
    final unselectedFontSize = isLandscape ? size.height * 0.032 : 13.sp;

    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          // Custom styled tab bar
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: marginH,
              vertical: marginV,
            ),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              isScrollable: isLandscape,
              labelColor: theme.brightness == Brightness.dark
                  ? theme.primaryColorLight
                  : theme.primaryColor,
              unselectedLabelColor: theme.hintColor,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: labelFontSize,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: unselectedFontSize,
              ),
              indicator: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? theme.primaryColorLight.withValues(alpha: 0.15)
                    : theme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(indicatorRadius),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.all(indicatorPadding),
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: LocaleKeys.detailAbout.tr()),
                Tab(text: LocaleKeys.detailBaseStats.tr()),
                Tab(text: LocaleKeys.detailEvolution.tr()),
                Tab(text: LocaleKeys.detailMoves.tr()),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                AboutTab(
                  pokemon: pokemon,
                  species: state.species,
                  isLandscape: isLandscape,
                ),
                StatsTab(pokemon: pokemon, isLandscape: isLandscape),
                EvolutionTab(
                  evolution: state.evolution,
                  isLandscape: isLandscape,
                ),
                MovesTab(pokemon: pokemon, isLandscape: isLandscape),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
