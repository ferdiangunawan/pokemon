import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/locale_keys.g.dart';
import '../cubit/index.dart';

/// Search bar widget for filtering Pokemon with enhanced design
class PokemonSearchBar extends StatefulWidget {
  final bool isLandscape;

  const PokemonSearchBar({super.key, this.isLandscape = false});

  @override
  State<PokemonSearchBar> createState() => _PokemonSearchBarState();
}

class _PokemonSearchBarState extends State<PokemonSearchBar>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_focusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isLandscape = widget.isLandscape;
    final size = MediaQuery.of(context).size;

    final borderRadius = isLandscape ? size.height * 0.04 : 16.r;
    final iconSize = isLandscape ? size.height * 0.06 : 24.sp;
    final iconPadding = isLandscape ? size.height * 0.03 : 12.w;
    final horizontalPadding = isLandscape ? size.width * 0.02 : 16.w;
    final verticalPadding = isLandscape ? size.height * 0.04 : 16.h;
    final clearIconSize = isLandscape ? size.height * 0.04 : 16.sp;
    final clearPadding = isLandscape ? size.height * 0.01 : 4.w;

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.searchQuery != current.searchQuery,
      builder: (context, state) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: isDark ? theme.cardColor.withValues(alpha: 0.8) : Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: _isFocused
                    ? theme.primaryColor.withValues(alpha: 0.5)
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isFocused
                      ? theme.primaryColor.withValues(alpha: 0.15)
                      : Colors.black.withValues(alpha: 0.08),
                  blurRadius: _isFocused ? 16 : 12,
                  offset: const Offset(0, 4),
                  spreadRadius: _isFocused ? 2 : 0,
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: (value) {
                context.read<HomeCubit>().search(value);
              },
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: isLandscape ? size.height * 0.045 : null,
              ),
              decoration: InputDecoration(
                hintText: LocaleKeys.homeSearchHint.tr(),
                hintStyle: TextStyle(
                  color: theme.hintColor.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w400,
                  fontSize: isLandscape ? size.height * 0.04 : null,
                ),
                prefixIcon: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(iconPadding),
                  child: Icon(
                    Icons.search_rounded,
                    color: _isFocused
                        ? theme.primaryColor
                        : theme.hintColor.withValues(alpha: 0.7),
                    size: iconSize,
                  ),
                ),
                suffixIcon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: state.searchQuery.isNotEmpty
                      ? IconButton(
                          key: const ValueKey('clear'),
                          icon: Container(
                            padding: EdgeInsets.all(clearPadding),
                            decoration: BoxDecoration(
                              color: theme.hintColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              size: clearIconSize,
                              color: theme.hintColor,
                            ),
                          ),
                          onPressed: () {
                            _controller.clear();
                            context.read<HomeCubit>().clearSearch();
                          },
                        )
                      : const SizedBox.shrink(key: ValueKey('empty')),
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
