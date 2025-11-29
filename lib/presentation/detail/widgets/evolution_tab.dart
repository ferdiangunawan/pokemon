import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../common/index.dart';
import '../../../domain/index.dart';

/// Evolution tab showing Pokemon evolution chain
class EvolutionTab extends StatelessWidget {
  final EvolutionChain? evolution;

  const EvolutionTab({super.key, this.evolution});

  @override
  Widget build(BuildContext context) {
    if (evolution == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            Gap(16.h),
            Text('common.loading'.tr()),
          ],
        ),
      );
    }

    if (evolution!.chain.isEmpty) {
      return Center(child: Text('detail.no_evolution'.tr()));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: _buildEvolutionTree(context, evolution!.chain.first),
    );
  }

  Widget _buildEvolutionTree(BuildContext context, EvolutionStage stage) {
    return Column(
      children: [
        _EvolutionCard(stage: stage),
        if (stage.evolvesTo.isNotEmpty) ...[
          ...stage.evolvesTo.map((nextStage) {
            return Column(
              children: [
                _EvolutionArrow(
                  minLevel: nextStage.minLevel,
                  trigger: nextStage.trigger,
                  item: nextStage.item,
                ),
                _buildEvolutionTree(context, nextStage),
              ],
            );
          }),
        ],
      ],
    );
  }
}

class _EvolutionCard extends StatelessWidget {
  final EvolutionStage stage;

  const _EvolutionCard({required this.stage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/pokemon/${stage.pokemonId}');
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl:
                  stage.imageUrl ??
                  ApiConstants.getOfficialArtworkUrl(stage.pokemonId),
              height: 80.h,
              width: 80.w,
              fit: BoxFit.contain,
              placeholder: (context, url) => SizedBox(
                height: 80.h,
                width: 80.w,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) =>
                  Icon(Icons.catching_pokemon, size: 60.sp, color: Colors.grey),
            ),
            Gap(8.h),
            Text(
              stage.pokemonName.capitalize,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
            Text(
              '#${stage.pokemonId.toString().padLeft(3, '0')}',
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class _EvolutionArrow extends StatelessWidget {
  final int? minLevel;
  final String? trigger;
  final String? item;

  const _EvolutionArrow({this.minLevel, this.trigger, this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          Icon(
            Icons.arrow_downward,
            color: Theme.of(context).primaryColor,
            size: 24.sp,
          ),
          if (minLevel != null)
            Text(
              'Lv. $minLevel',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          if (item != null)
            Text(
              item!.toReadable,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
          if (trigger != null && trigger != 'level-up')
            Text(
              trigger!.toReadable,
              style: TextStyle(fontSize: 10.sp, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
