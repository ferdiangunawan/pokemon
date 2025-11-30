import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../common/index.dart';
import '../../../domain/index.dart';

/// Moves tab showing Pokemon moves list with enhanced design
class MovesTabWidget extends StatefulWidget {
  final Pokemon pokemon;
  final bool isLandscape;

  const MovesTabWidget({
    super.key,
    required this.pokemon,
    this.isLandscape = false,
  });

  @override
  State<MovesTabWidget> createState() => _MovesTabWidgetState();
}

class _MovesTabWidgetState extends State<MovesTabWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final moves = widget.pokemon.moves;
    final theme = Theme.of(context);
    final primaryColor = PokemonTypeColors.getTypeColor(
      widget.pokemon.primaryType,
    );
    final size = MediaQuery.of(context).size;
    final isLandscape = widget.isLandscape;

    // Responsive sizing
    final containerPadding = isLandscape ? size.width * 0.025 : 24.w;
    final iconSize = isLandscape ? size.height * 0.1 : 48.sp;
    final gapHeight = isLandscape ? size.height * 0.03 : 16.h;
    final marginH = isLandscape ? size.width * 0.015 : 16.w;
    final marginV = isLandscape ? size.height * 0.015 : 8.h;
    final tabHeight = isLandscape ? size.height * 0.1 : 48.h;
    final tabFontSize = isLandscape ? size.height * 0.028 : 12.sp;
    final borderRadius = isLandscape ? 12.0 : 12.r;
    final tabPadding = isLandscape ? size.width * 0.004 : 4.w;

    if (moves.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(containerPadding),
              decoration: BoxDecoration(
                color: theme.hintColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.flash_off_rounded,
                size: iconSize,
                color: theme.hintColor.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: gapHeight),
            Text(
              LocaleKeys.detailNoMoves.tr(),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.hintColor,
                fontSize: isLandscape ? size.height * 0.035 : null,
              ),
            ),
          ],
        ),
      );
    }

    // Group moves by learn method
    final levelUpMoves =
        moves.where((m) => m.learnMethod == 'level-up').toList()..sort(
          (a, b) => (a.levelLearnedAt ?? 0).compareTo(b.levelLearnedAt ?? 0),
        );
    final machineMoves = moves
        .where((m) => m.learnMethod == 'machine')
        .toList();
    final tutorMoves = moves.where((m) => m.learnMethod == 'tutor').toList();
    final eggMoves = moves.where((m) => m.learnMethod == 'egg').toList();

    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          // Custom styled inner tab bar
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: marginH,
              vertical: marginV,
            ),
            height: tabHeight,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              isScrollable: true,
              labelStyle: TextStyle(
                fontSize: tabFontSize,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: tabFontSize,
                fontWeight: FontWeight.w500,
              ),
              labelColor: primaryColor,
              unselectedLabelColor: theme.hintColor,
              indicator: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(isLandscape ? 10.0 : 10.r),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.all(tabPadding),
              dividerColor: Colors.transparent,
              tabAlignment: TabAlignment.start,
              padding: EdgeInsets.zero,
              tabs: [
                _MoveTabLabel(
                  text: LocaleKeys.detailMovesLevelUp.tr(),
                  count: levelUpMoves.length,
                  icon: Icons.trending_up_rounded,
                  isLandscape: isLandscape,
                ),
                _MoveTabLabel(
                  text: LocaleKeys.detailMovesTmHm.tr(),
                  count: machineMoves.length,
                  icon: Icons.album_rounded,
                  isLandscape: isLandscape,
                ),
                _MoveTabLabel(
                  text: LocaleKeys.detailMovesTutor.tr(),
                  count: tutorMoves.length,
                  icon: Icons.school_rounded,
                  isLandscape: isLandscape,
                ),
                _MoveTabLabel(
                  text: LocaleKeys.detailMovesEgg.tr(),
                  count: eggMoves.length,
                  icon: Icons.egg_rounded,
                  isLandscape: isLandscape,
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _MovesList(
                  moves: levelUpMoves,
                  showLevel: true,
                  primaryColor: primaryColor,
                  isLandscape: isLandscape,
                ),
                _MovesList(
                  moves: machineMoves,
                  primaryColor: primaryColor,
                  isLandscape: isLandscape,
                ),
                _MovesList(
                  moves: tutorMoves,
                  primaryColor: primaryColor,
                  isLandscape: isLandscape,
                ),
                _MovesList(
                  moves: eggMoves,
                  primaryColor: primaryColor,
                  isLandscape: isLandscape,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoveTabLabel extends StatelessWidget {
  final String text;
  final int count;
  final IconData icon;
  final bool isLandscape;

  const _MoveTabLabel({
    required this.text,
    required this.count,
    required this.icon,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final iconSize = isLandscape ? size.height * 0.035 : 16.sp;
    final gapWidth = isLandscape ? size.width * 0.004 : 4.w;

    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize),
          SizedBox(width: gapWidth),
          Text('$text ($count)'),
        ],
      ),
    );
  }
}

class _MovesList extends StatelessWidget {
  final List<PokemonMove> moves;
  final bool showLevel;
  final Color primaryColor;
  final bool isLandscape;

  const _MovesList({
    required this.moves,
    this.showLevel = false,
    required this.primaryColor,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // Responsive sizing
    final emptyIconSize = isLandscape ? size.height * 0.08 : 40.sp;
    final emptyGapHeight = isLandscape ? size.height * 0.025 : 12.h;
    final emptyFontSize = isLandscape ? size.height * 0.032 : 14.sp;
    final listPadding = isLandscape ? size.width * 0.015 : 16.w;
    final itemMargin = isLandscape ? size.height * 0.02 : 10.h;
    final borderRadius = isLandscape ? 14.0 : 14.r;
    final itemPaddingH = isLandscape ? size.width * 0.015 : 16.w;
    final itemPaddingV = isLandscape ? size.height * 0.025 : 14.h;
    final levelWidth = isLandscape ? size.width * 0.05 : 48.w;
    final levelPaddingV = isLandscape ? size.height * 0.012 : 6.h;
    final levelPaddingH = isLandscape ? size.width * 0.004 : 4.w;
    final levelBorderRadius = isLandscape ? 10.0 : 10.r;
    final smallFontSize = isLandscape ? size.height * 0.024 : 10.sp;
    final levelFontSize = isLandscape ? size.height * 0.032 : 14.sp;
    final gapWidth = isLandscape ? size.width * 0.014 : 14.w;
    final iconPadding = isLandscape ? size.width * 0.008 : 8.w;
    final iconSize = isLandscape ? size.height * 0.04 : 18.sp;
    final moveFontSize = isLandscape ? size.height * 0.035 : 15.sp;
    final gapSmall = isLandscape ? size.width * 0.012 : 12.w;

    if (moves.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty_rounded,
              size: emptyIconSize,
              color: theme.hintColor.withValues(alpha: 0.4),
            ),
            SizedBox(height: emptyGapHeight),
            Text(
              LocaleKeys.detailNoMovesCategory.tr(),
              style: TextStyle(color: theme.hintColor, fontSize: emptyFontSize),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(listPadding),
      itemCount: moves.length,
      itemBuilder: (context, index) {
        final move = moves[index];

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 200 + (index * 30).clamp(0, 300)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(20 * (1 - value), 0),
                child: child,
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: itemMargin),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Could show move details in a bottom sheet
                },
                borderRadius: BorderRadius.circular(borderRadius),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: itemPaddingH,
                    vertical: itemPaddingV,
                  ),
                  child: Row(
                    children: [
                      if (showLevel && move.levelLearnedAt != null) ...[
                        Container(
                          width: levelWidth,
                          padding: EdgeInsets.symmetric(
                            vertical: levelPaddingV,
                            horizontal: levelPaddingH,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryColor.withValues(alpha: 0.15),
                                primaryColor.withValues(alpha: 0.08),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              levelBorderRadius,
                            ),
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Lv',
                                style: TextStyle(
                                  fontSize: smallFontSize,
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor.withValues(alpha: 0.7),
                                ),
                              ),
                              Text(
                                '${move.levelLearnedAt}',
                                style: TextStyle(
                                  fontSize: levelFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: gapWidth),
                      ],
                      // Move icon
                      Container(
                        padding: EdgeInsets.all(iconPadding),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            levelBorderRadius,
                          ),
                        ),
                        child: Icon(
                          Icons.flash_on_rounded,
                          size: iconSize,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(width: gapSmall),
                      Expanded(
                        child: Text(
                          move.name.toReadable,
                          style: TextStyle(
                            fontSize: moveFontSize,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
