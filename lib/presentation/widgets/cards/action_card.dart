import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import 'skyscanner_card.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool isEnabled;

  const ActionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SkyscannerCard(
      onTap: isEnabled ? onTap : null,
      color: backgroundColor ?? Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: (iconColor ?? AppTheme.accentCoral).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
            ),
            child: Icon(
              icon,
              size: 28,
              color: isEnabled ? (iconColor ?? AppTheme.accentCoral) : Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isEnabled ? Colors.black87 : Colors.grey.shade400,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isEnabled ? Colors.grey.shade600 : Colors.grey.shade400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final String? badge;

  const QuickActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.color,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return SkyscannerCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (color ?? AppTheme.primaryPink).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: color ?? AppTheme.primaryPink,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: 20,
              ),
            ],
          ),
          if (badge != null)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingS,
                  vertical: AppTheme.spacingXXS,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.accentCoral,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                ),
                child: Text(
                  badge!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CTACard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String buttonText;
  final VoidCallback onPressed;
  final Color? buttonColor;
  final IconData? icon;
  final Widget? background;

  const CTACard({
    super.key,
    required this.title,
    this.subtitle,
    required this.buttonText,
    required this.onPressed,
    this.buttonColor,
    this.icon,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return SkyscannerCard(
      color: AppTheme.offWhite,
      child: Stack(
        children: [
          if (background != null)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusCard),
                child: background!,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null) ...[
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: (buttonColor ?? AppTheme.accentCoral).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                    child: Icon(
                      icon,
                      size: 24,
                      color: buttonColor ?? AppTheme.accentCoral,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                ],
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
                const SizedBox(height: AppTheme.spacingL),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor ?? AppTheme.accentCoral,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(buttonText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}