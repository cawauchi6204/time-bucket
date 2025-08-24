import 'package:flutter/material.dart';
import 'dart:io';
import '../../../config/theme.dart';
import '../../../data/models/time_bucket.dart';

class HeroBucketCard extends StatelessWidget {
  final TimeBucket bucket;
  final int experienceCount;
  final VoidCallback? onTap;
  final String? backgroundImageUrl;
  final bool isActive;

  const HeroBucketCard({
    super.key,
    required this.bucket,
    this.experienceCount = 0,
    this.onTap,
    this.backgroundImageUrl,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          child: Stack(
            children: [
              // Background Image
              _buildBackgroundImage(),
              
              // Gradient Overlay
              _buildGradientOverlay(),
              
              // Content Overlay
              _buildContentOverlay(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    // bucketのiconPathを背景画像として使用
    final imagePath = bucket.iconPath ?? backgroundImageUrl;
    
    if (imagePath != null && imagePath.isNotEmpty) {
      // ネットワークURLかローカルファイルパスかを判断
      if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
        return Positioned.fill(
          child: Image.network(
            imagePath,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            errorBuilder: (context, error, stackTrace) {
              return _buildDefaultBackground();
            },
          ),
        );
      } else {
        // ローカルファイルパスの場合
        return Positioned.fill(
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            errorBuilder: (context, error, stackTrace) {
              return _buildDefaultBackground();
            },
          ),
        );
      }
    }
    return _buildDefaultBackground();
  }

  Widget _buildDefaultBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            bucket.bucketColor.withOpacity(0.8),
            bucket.bucketColor.withOpacity(0.6),
            bucket.bucketColor.withOpacity(0.4),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.7),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildContentOverlay(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingS),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section - Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingS,
                      vertical: AppTheme.spacingXXS,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingXS),
                        Text(
                          'Active',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox.shrink(),
                
                // Menu Button
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
            
            // Bottom Section - Main Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Age Range Chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingS,
                    vertical: AppTheme.spacingXXS,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Ages ${bucket.startAge}-${bucket.endAge}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacingXS),
                
                // Title
                Text(
                  bucket.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: AppTheme.spacingXS),
                
                // Description or Experience Count
                if (bucket.description?.isNotEmpty == true)
                  Text(
                    bucket.description!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                else
                  Row(
                    children: [
                      Icon(
                        Icons.explore,
                        size: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(width: AppTheme.spacingXS),
                      Text(
                        '$experienceCount ${experienceCount == 1 ? 'experience' : 'experiences'}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 複数のバケットを横スクロールで表示するためのウィジェット
class HeroBucketCarousel extends StatelessWidget {
  final List<TimeBucket> buckets;
  final Function(TimeBucket) onBucketTap;
  final int currentAge;

  const HeroBucketCarousel({
    super.key,
    required this.buckets,
    required this.onBucketTap,
    this.currentAge = 28,
  });

  @override
  Widget build(BuildContext context) {
    if (buckets.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
        itemCount: buckets.length,
        itemBuilder: (context, index) {
          final bucket = buckets[index];
          final isActive = currentAge >= bucket.startAge && currentAge <= bucket.endAge;
          
          return Container(
            width: 280,
            margin: EdgeInsets.only(
              right: index == buckets.length - 1 ? 0 : AppTheme.spacingM,
            ),
            child: HeroBucketCard(
              bucket: bucket,
              experienceCount: 0, // TODO: Get actual count
              isActive: isActive,
              onTap: () => onBucketTap(bucket),
            ),
          );
        },
      ),
    );
  }

}