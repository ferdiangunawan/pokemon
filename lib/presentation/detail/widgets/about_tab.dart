import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../common/index.dart';
import '../../../domain/index.dart';

/// About tab showing Pokemon details
class AboutTab extends StatelessWidget {
  final Pokemon pokemon;
  final PokemonSpecies? species;

  const AboutTab({super.key, required this.pokemon, this.species});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          if (species?.description != null) ...[
            Text(
              species!.description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            Gap(24.h),
          ],

          // Basic info section
          _buildInfoSection(context, [
            _InfoRow(
              label: 'detail.species'.tr(),
              value: species?.genus ?? 'Unknown',
            ),
            _InfoRow(
              label: 'detail.height'.tr(),
              value: pokemon.formattedHeight,
            ),
            _InfoRow(
              label: 'detail.weight'.tr(),
              value: pokemon.formattedWeight,
            ),
            _InfoRow(
              label: 'detail.abilities'.tr(),
              value: pokemon.abilities.map((a) => a.name.toReadable).join(', '),
            ),
          ]),
          Gap(24.h),

          // Gender section
          if (species != null) ...[
            Text(
              'detail.gender'.tr(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(8.h),
            _buildGenderInfo(context, species!),
            Gap(24.h),
          ],

          // Egg groups
          if (species != null && species!.eggGroups.isNotEmpty) ...[
            Text(
              'detail.egg_groups'.tr(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(8.h),
            Wrap(
              spacing: 8.w,
              children: species!.eggGroups.map((group) {
                return Chip(
                  label: Text(group.toReadable),
                  backgroundColor: theme.colorScheme.primaryContainer,
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, List<_InfoRow> rows) {
    return Container(
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
        children: rows.map((row) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100.w,
                  child: Text(
                    row.label,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    row.value,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGenderInfo(BuildContext context, PokemonSpecies species) {
    if (species.isGenderless) {
      return Text(
        'detail.genderless'.tr(),
        style: TextStyle(color: Colors.grey[600]),
      );
    }

    final femaleRatio = species.femaleRatio ?? 0;
    final maleRatio = species.maleRatio ?? 0;

    return Row(
      children: [
        Icon(Icons.male, color: Colors.blue, size: 20.sp),
        Gap(4.w),
        Text('${maleRatio.toStringAsFixed(1)}%'),
        Gap(16.w),
        Icon(Icons.female, color: Colors.pink, size: 20.sp),
        Gap(4.w),
        Text('${femaleRatio.toStringAsFixed(1)}%'),
      ],
    );
  }
}

class _InfoRow {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});
}
