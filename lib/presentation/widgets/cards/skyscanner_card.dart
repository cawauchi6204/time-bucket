import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class SkyscannerCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? elevation;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final bool showShadow;

  const SkyscannerCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.onTap,
    this.borderRadius,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final cardChild = Container(
      padding: padding ?? const EdgeInsets.all(AppTheme.cardPadding),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.borderRadiusCard),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return Container(
        margin: margin ?? const EdgeInsets.all(AppTheme.cardMargin),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.borderRadiusCard),
            child: cardChild,
          ),
        ),
      );
    }

    return Container(
      margin: margin ?? const EdgeInsets.all(AppTheme.cardMargin),
      child: cardChild,
    );
  }
}

class SkyscannerCardHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const SkyscannerCardHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: titleStyle ?? Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppTheme.spacingXS),
                Text(
                  subtitle!,
                  style: subtitleStyle ?? Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class SkyscannerCardSection extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const SkyscannerCardSection({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      child: child,
    );
  }
}