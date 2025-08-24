import 'package:flutter/material.dart';
import 'dart:io';
import '../../../config/theme.dart';
import '../../../data/models/time_bucket.dart';
import '../../../data/models/experience.dart';
import 'skyscanner_card.dart';

class BucketResultCard extends StatelessWidget {
  final TimeBucket bucket;
  final int experienceCount;
  final VoidCallback? onTap;

  const BucketResultCard({
    super.key,
    required this.bucket,
    this.experienceCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SkyscannerCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkyscannerCardHeader(
            title: bucket.name,
            subtitle: bucket.description?.isNotEmpty == true ? bucket.description : null,
            trailing: _buildBucketIcon(context),
          ),
          const SizedBox(height: AppTheme.spacingM),
          _buildAgeRange(context),
          const SizedBox(height: AppTheme.spacingS),
          _buildExperienceCount(context),
        ],
      ),
    );
  }

  Widget _buildBucketIcon(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bucket.bucketColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: bucket.iconPath != null && bucket.iconPath!.isNotEmpty && !bucket.iconPath!.startsWith('icon:')
          ? ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              child: bucket.iconPath!.startsWith('http://') || bucket.iconPath!.startsWith('https://')
                  ? Image.network(
                      bucket.iconPath!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.access_time,
                          color: bucket.bucketColor,
                          size: 24,
                        );
                      },
                    )
                  : bucket.iconPath!.startsWith('assets/')
                      ? Image.asset(
                          bucket.iconPath!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.access_time,
                              color: bucket.bucketColor,
                              size: 24,
                            );
                          },
                        )
                      : Image.file(
                          File(bucket.iconPath!),
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.access_time,
                              color: bucket.bucketColor,
                              size: 24,
                            );
                          },
                        ),
            )
          : Icon(
              Icons.access_time,
              color: bucket.bucketColor,
              size: 24,
            ),
    );
  }

  Widget _buildAgeRange(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      decoration: BoxDecoration(
        color: AppTheme.lightGray,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
      ),
      child: Text(
        'Ages ${bucket.startAge} - ${bucket.endAge}',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildExperienceCount(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.list_alt,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: AppTheme.spacingXS),
        Text(
          '$experienceCount ${experienceCount == 1 ? 'experience' : 'experiences'}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class ExperienceResultCard extends StatelessWidget {
  final Experience experience;
  final VoidCallback? onTap;
  final bool showBucket;

  const ExperienceResultCard({
    super.key,
    required this.experience,
    this.onTap,
    this.showBucket = false,
  });

  @override
  Widget build(BuildContext context) {
    return SkyscannerCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkyscannerCardHeader(
            title: experience.title,
            subtitle: experience.description?.isNotEmpty == true ? experience.description : null,
            trailing: _buildResourcesChip(context),
          ),
          const SizedBox(height: AppTheme.spacingM),
          _buildResourceMetrics(context),
          if (experience.estimatedCost > 0) ...[
            const SizedBox(height: AppTheme.spacingS),
            _buildCostInfo(context),
          ],
        ],
      ),
    );
  }

  Widget _buildResourcesChip(BuildContext context) {
    final totalResources = experience.timeRequired + experience.energyRequired;
    
    if (totalResources == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryMint.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
      ),
      child: Text(
        '${totalResources.toInt()} points',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryMint,
        ),
      ),
    );
  }

  Widget _buildResourceMetrics(BuildContext context) {
    final resources = <String>[];
    
    if (experience.timeRequired > 0) {
      resources.add('Time: ${experience.timeRequired.toInt()}h');
    }
    if (experience.energyRequired > 0) {
      resources.add('Energy: ${experience.energyLevel}');
    }

    if (resources.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppTheme.spacingM,
      children: resources.map((resource) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingS,
            vertical: AppTheme.spacingXXS,
          ),
          decoration: BoxDecoration(
            color: AppTheme.lightGray,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
          ),
          child: Text(
            resource,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCostInfo(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.attach_money,
          size: 16,
          color: AppTheme.accentGold,
        ),
        const SizedBox(width: AppTheme.spacingXS),
        Text(
          '\$${experience.estimatedCost.toStringAsFixed(0)}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.accentGold,
          ),
        ),
      ],
    );
  }
}