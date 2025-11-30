import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../common/index.dart';
import '../../../domain/index.dart';

/// Pokemon card widget for grid display with enhanced design and animations
class PokemonCard extends StatefulWidget {
  final Pokemon pokemon;
  final int index;

  const PokemonCard({super.key, required this.pokemon, this.index = 0});

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = PokemonTypeColors.getPokemonGradient(
      widget.pokemon.types.map((t) => t.name).toList(),
    );

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () {
        context.push('/pokemon/${widget.pokemon.id}', extra: widget.pokemon);
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
              stops: const [0.3, 1.0],
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withValues(alpha: _isPressed ? 0.3 : 0.4),
                blurRadius: _isPressed ? 8 : 16,
                offset: Offset(0, _isPressed ? 4 : 8),
                spreadRadius: _isPressed ? 0 : 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Stack(
              children: [
                // Background pattern - Pokeball watermark
                Positioned(
                  right: -30.w,
                  bottom: -30.h,
                  child: Opacity(
                    opacity: 0.15,
                    child: Icon(
                      Icons.catching_pokemon,
                      size: 140.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Decorative circles
                Positioned(
                  left: -20.w,
                  top: -20.h,
                  child: Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top section - ID, Name, Types
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pokemon ID badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                '#${widget.pokemon.id.toString().padLeft(3, '0')}',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            // Pokemon Name
                            Text(
                              widget.pokemon.name.capitalize,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    offset: const Offset(0, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8.h),
                            // Type chips with better styling
                            Wrap(
                              spacing: 6.w,
                              runSpacing: 4.h,
                              children: widget.pokemon.types.map((type) {
                                return _TypeChip(typeName: type.name);
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      // Pokemon image
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Hero(
                          tag: 'pokemon-${widget.pokemon.id}',
                          child: CachedNetworkImage(
                            imageUrl: widget.pokemon.imageUrl,
                            height: 85.h,
                            width: 85.w,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => SizedBox(
                              height: 85.h,
                              width: 85.w,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.catching_pokemon,
                              size: 60.sp,
                              color: Colors.white.withValues(alpha: 0.5),
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        typeName.capitalize,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
