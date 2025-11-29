import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/index.dart';
import '../../../domain/index.dart';

/// Moves tab showing Pokemon moves list
class MovesTab extends StatelessWidget {
  final Pokemon pokemon;

  const MovesTab({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final moves = pokemon.moves;

    if (moves.isEmpty) {
      return const Center(child: Text('No moves available'));
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
          TabBar(
            isScrollable: true,
            labelStyle: TextStyle(fontSize: 12.sp),
            tabs: [
              Tab(text: 'Level Up (${levelUpMoves.length})'),
              Tab(text: 'TM/HM (${machineMoves.length})'),
              Tab(text: 'Tutor (${tutorMoves.length})'),
              Tab(text: 'Egg (${eggMoves.length})'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _MovesList(moves: levelUpMoves, showLevel: true),
                _MovesList(moves: machineMoves),
                _MovesList(moves: tutorMoves),
                _MovesList(moves: eggMoves),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MovesList extends StatelessWidget {
  final List<PokemonMove> moves;
  final bool showLevel;

  const _MovesList({required this.moves, this.showLevel = false});

  @override
  Widget build(BuildContext context) {
    if (moves.isEmpty) {
      return Center(
        child: Text(
          'No moves in this category',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: moves.length,
      itemBuilder: (context, index) {
        final move = moves[index];
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              if (showLevel && move.levelLearnedAt != null) ...[
                Container(
                  width: 40.w,
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    '${move.levelLearnedAt}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
              ],
              Expanded(
                child: Text(
                  move.name.toReadable,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
