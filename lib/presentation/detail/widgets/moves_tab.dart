import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../common/index.dart';
import '../../../domain/index.dart';

/// Moves tab showing Pokemon moves list with enhanced design
class MovesTab extends StatefulWidget {
  final Pokemon pokemon;

  const MovesTab({super.key, required this.pokemon});

  @override
  State<MovesTab> createState() => _MovesTabState();
}

class _MovesTabState extends State<MovesTab>
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

    if (moves.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: theme.hintColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.flash_off_rounded,
                size: 48.sp,
                color: theme.hintColor.withValues(alpha: 0.5),
              ),
            ),
            Gap(16.h),
            Text(
              LocaleKeys.detailNoMoves.tr(),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.hintColor,
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
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            height: 48.h,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12.r),
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
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
              labelColor: primaryColor,
              unselectedLabelColor: theme.hintColor,
              indicator: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.all(4.w),
              dividerColor: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              tabs: [
                _MoveTabLabel(
                  text: LocaleKeys.detailMovesLevelUp.tr(),
                  count: levelUpMoves.length,
                  icon: Icons.trending_up_rounded,
                ),
                _MoveTabLabel(
                  text: LocaleKeys.detailMovesTmHm.tr(),
                  count: machineMoves.length,
                  icon: Icons.album_rounded,
                ),
                _MoveTabLabel(
                  text: LocaleKeys.detailMovesTutor.tr(),
                  count: tutorMoves.length,
                  icon: Icons.school_rounded,
                ),
                _MoveTabLabel(
                  text: LocaleKeys.detailMovesEgg.tr(),
                  count: eggMoves.length,
                  icon: Icons.egg_rounded,
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
                ),
                _MovesList(moves: machineMoves, primaryColor: primaryColor),
                _MovesList(moves: tutorMoves, primaryColor: primaryColor),
                _MovesList(moves: eggMoves, primaryColor: primaryColor),
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

  const _MoveTabLabel({
    required this.text,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp),
          Gap(4.w),
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

  const _MovesList({
    required this.moves,
    this.showLevel = false,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (moves.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty_rounded,
              size: 40.sp,
              color: theme.hintColor.withValues(alpha: 0.4),
            ),
            Gap(12.h),
            Text(
              LocaleKeys.detailNoMovesCategory.tr(),
              style: TextStyle(color: theme.hintColor, fontSize: 14.sp),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
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
            margin: EdgeInsets.only(bottom: 10.h),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(14.r),
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
                borderRadius: BorderRadius.circular(14.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  child: Row(
                    children: [
                      if (showLevel && move.levelLearnedAt != null) ...[
                        Container(
                          width: 48.w,
                          padding: EdgeInsets.symmetric(
                            vertical: 6.h,
                            horizontal: 4.w,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryColor.withValues(alpha: 0.15),
                                primaryColor.withValues(alpha: 0.08),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Lv',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor.withValues(alpha: 0.7),
                                ),
                              ),
                              Text(
                                '${move.levelLearnedAt}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(14.w),
                      ],
                      // Move icon
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.flash_on_rounded,
                          size: 18.sp,
                          color: primaryColor,
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: Text(
                          move.name.toReadable,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 20.sp,
                        color: theme.hintColor.withValues(alpha: 0.4),
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
