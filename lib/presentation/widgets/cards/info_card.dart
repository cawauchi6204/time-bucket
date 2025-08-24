import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import 'skyscanner_card.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? valueColor;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SkyscannerCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (iconColor ?? AppTheme.primaryPink).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor ?? AppTheme.primaryPink,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
          ],
          Text(
            value,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black87,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? trend;
  final bool isPositiveTrend;
  final IconData? icon;
  final Color? color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.trend,
    this.isPositiveTrend = true,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SkyscannerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                  color: color ?? AppTheme.primaryPink,
                ),
                const SizedBox(width: AppTheme.spacingS),
              ],
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color ?? Colors.black87,
                  ),
                ),
              ),
              if (trend != null) ...[
                const SizedBox(width: AppTheme.spacingS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingS,
                    vertical: AppTheme.spacingXXS,
                  ),
                  decoration: BoxDecoration(
                    color: isPositiveTrend
                        ? AppTheme.success.withOpacity(0.1)
                        : AppTheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositiveTrend ? Icons.trending_up : Icons.trending_down,
                        size: 12,
                        color: isPositiveTrend ? AppTheme.success : AppTheme.error,
                      ),
                      const SizedBox(width: AppTheme.spacingXXS),
                      Text(
                        trend!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isPositiveTrend ? AppTheme.success : AppTheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class ProgressCard extends StatelessWidget {
  final String title;
  final double progress;
  final String progressText;
  final Color? progressColor;
  final String? subtitle;

  const ProgressCard({
    super.key,
    required this.title,
    required this.progress,
    required this.progressText,
    this.progressColor,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SkyscannerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                progressText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: progressColor ?? AppTheme.primaryPink,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
          const SizedBox(height: AppTheme.spacingM),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                progressColor ?? AppTheme.primaryPink,
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final List<SummaryItem> items;
  final VoidCallback? onViewAll;

  const SummaryCard({
    super.key,
    required this.title,
    required this.items,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return SkyscannerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkyscannerCardHeader(
            title: title,
            trailing: onViewAll != null
                ? TextButton(
                    onPressed: onViewAll,
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryPink,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('View All'),
                  )
                : null,
          ),
          const SizedBox(height: AppTheme.spacingM),
          ...items.map((item) => _buildSummaryItem(context, item)),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, SummaryItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Row(
        children: [
          if (item.icon != null) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: (item.color ?? AppTheme.primaryPink).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
              ),
              child: Icon(
                item.icon,
                size: 16,
                color: item.color ?? AppTheme.primaryPink,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (item.subtitle != null)
                  Text(
                    item.subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ),
          if (item.value != null)
            Text(
              item.value!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: item.color ?? Colors.black87,
              ),
            ),
        ],
      ),
    );
  }
}

class SummaryItem {
  final String title;
  final String? subtitle;
  final String? value;
  final IconData? icon;
  final Color? color;

  const SummaryItem({
    required this.title,
    this.subtitle,
    this.value,
    this.icon,
    this.color,
  });
}