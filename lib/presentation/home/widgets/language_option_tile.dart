import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Locale locale;
  final bool isSelected;

  const LanguageOptionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.locale,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Fix dark mode text visibility - use contrasting colors
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
        borderRadius: BorderRadius.circular(16.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                    ? Colors.red.withValues(alpha: 0.25)
                    : theme.primaryColor.withValues(alpha: 0.1))
                : (isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : theme.cardColor),
            borderRadius: BorderRadius.circular(16.r),
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
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: titleColor,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isSelected
                    ? Icon(
                        Icons.check_circle_rounded,
                        color: isDark ? Colors.red : theme.primaryColor,
                        size: 24.sp,
                      )
                    : Icon(
                        Icons.circle_outlined,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.4)
                            : theme.hintColor.withValues(alpha: 0.5),
                        size: 24.sp,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
