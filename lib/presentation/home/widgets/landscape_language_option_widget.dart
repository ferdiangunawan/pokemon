import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Landscape-specific language option widget using raw pixel values
class LandscapeLanguageOptionWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Locale locale;
  final bool isSelected;

  const LandscapeLanguageOptionWidget({
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
    final size = MediaQuery.of(context).size;

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
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.height * 0.03,
            vertical: size.height * 0.025,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                      ? Colors.red.withValues(alpha: 0.25)
                      : theme.primaryColor.withValues(alpha: 0.1))
                : (isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : theme.cardColor),
            borderRadius: BorderRadius.circular(12),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: size.height * 0.04,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: titleColor,
                      ),
                    ),
                    SizedBox(height: size.height * 0.005),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: size.height * 0.03,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: isSelected
                    ? (isDark ? Colors.red : theme.primaryColor)
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.4)
                          : theme.hintColor.withValues(alpha: 0.5)),
                size: size.height * 0.055,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
