import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../common/index.dart';
import '../../../domain/index.dart';

/// Pokemon card widget for grid display
class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final gradientColors = PokemonTypeColors.getPokemonGradient(
      pokemon.types.map((t) => t.name).toList(),
    );

    return GestureDetector(
      onTap: () {
        context.push('/pokemon/${pokemon.id}', extra: pokemon);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              right: -20.w,
              bottom: -20.h,
              child: Icon(
                Icons.catching_pokemon,
                size: 120.sp,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top section - ID, Name, Types
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pokemon ID
                      Text(
                        '#${pokemon.id.toString().padLeft(3, '0')}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Pokemon Name
                      Text(
                        pokemon.name.capitalize,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      // Type chips
                      Wrap(
                        spacing: 4.w,
                        runSpacing: 4.h,
                        children: pokemon.types.map((type) {
                          return _TypeChip(typeName: type.name);
                        }).toList(),
                      ),
                    ],
                  ),
                  // Pokemon image
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Hero(
                      tag: 'pokemon-${pokemon.id}',
                      child: CachedNetworkImage(
                        imageUrl: pokemon.imageUrl,
                        height: 80.h,
                        width: 80.w,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => SizedBox(
                          height: 80.h,
                          width: 80.w,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.catching_pokemon,
                          size: 60.sp,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String typeName;

  const _TypeChip({required this.typeName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        typeName.capitalize,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
