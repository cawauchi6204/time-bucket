import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import '../../../config/routes.dart';
import '../../../data/providers/bucket_provider.dart';
import '../../../data/models/time_bucket.dart';
import '../../widgets/cards/hero_bucket_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.grey),
            onPressed: () => context.go(AppRoutes.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Section
            _buildProfileSection(context),
            const SizedBox(height: 32),

            // Life Resource Meter
            _buildLifeResourceMeter(context),
            const SizedBox(height: 32),

            // My Time Buckets (Object-Oriented)
            _buildMyTimeBuckets(context, ref),
            const SizedBox(height: 32),

            // Recommended Experiences
            _buildRecommendedExperiences(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.orange.shade200,
                Colors.orange.shade400,
              ],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(52),
                child: Image.network(
                  'https://images.unsplash.com/photo-1494790108755-2616b612b740?w=200&h=200&fit=crop&crop=face',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.person,
                          size: 60, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Sophia',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Age 28',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text(
            'Next Time Bucket in 5 years',
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLifeResourceMeter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Life Resource Meter',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildResourceCard(
                'Health', '85%', Colors.red.shade100, Colors.red),
            _buildResourceCard(
                'Time', '70%', Colors.blue.shade100, Colors.blue),
            _buildResourceCard(
                'Money', '60%', Colors.green.shade100, Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _buildResourceCard(
      String title, String percentage, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              percentage,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyTimeBuckets(BuildContext context, WidgetRef ref) {
    final bucketsAsync = ref.watch(bucketsProvider);
    final currentAge = 28; // TODO: Get from user profile

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Time Buckets',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            GestureDetector(
              onTap: () => _showCreateBucketDialog(context, ref),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 16, color: Colors.blue.shade700),
                    const SizedBox(width: 4),
                    Text(
                      'New Bucket',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        bucketsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text('Error loading buckets: $error'),
          ),
          data: (buckets) {
            if (buckets.isEmpty) {
              return _buildEmptyBucketsState(context, ref);
            }

            // Filter buckets relevant to current age (current + future)
            final relevantBuckets = buckets
                .where((bucket) => bucket.endAge >= currentAge)
                .take(3)
                .toList();

            return HeroBucketCarousel(
              buckets: relevantBuckets,
              currentAge: currentAge,
              onBucketTap: (bucket) => _openBucketDetails(context, ref, bucket),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInteractiveBucketCard(
      BuildContext context, WidgetRef ref, TimeBucket bucket, int currentAge) {
    final color = Color(
        int.parse(bucket.color?.replaceFirst('#', '0xFF') ?? '0xFF2196F3'));
    final bgColor = color.withOpacity(0.1);
    final isActive =
        currentAge >= bucket.startAge && currentAge <= bucket.endAge;
    final isFuture = currentAge < bucket.startAge;

    String status;
    if (isActive) {
      status = 'Active Now';
    } else if (isFuture) {
      final yearsUntil = bucket.startAge - currentAge;
      status = 'Starts in $yearsUntil year${yearsUntil > 1 ? 's' : ''}';
    } else {
      status = 'Completed';
    }

    return GestureDetector(
      onTap: () => _openBucketDetails(context, ref, bucket),
      onLongPress: () => _showBucketContextMenu(context, ref, bucket),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isActive ? Border.all(color: color, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isActive ? 0.1 : 0.05),
              blurRadius: isActive ? 15 : 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bucket.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isActive ? color : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ages ${bucket.startAge}-${bucket.endAge}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  if (bucket.description != null &&
                      bucket.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      bucket.description!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive ? color.withOpacity(0.2) : bgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 11,
                        color: isActive ? color : Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: bucket.iconPath != null && bucket.iconPath!.isNotEmpty && !bucket.iconPath!.startsWith('icon:')
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: bucket.iconPath!.startsWith('http://') || bucket.iconPath!.startsWith('https://')
                              ? Image.network(
                                  bucket.iconPath!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      isActive
                                          ? Icons.play_circle_fill
                                          : isFuture
                                              ? Icons.schedule
                                              : Icons.check_circle,
                                      color: color,
                                      size: 30,
                                    );
                                  },
                                )
                              : bucket.iconPath!.startsWith('assets/')
                                  ? Image.asset(
                                      bucket.iconPath!,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          isActive
                                              ? Icons.play_circle_fill
                                              : isFuture
                                                  ? Icons.schedule
                                                  : Icons.check_circle,
                                          color: color,
                                          size: 30,
                                        );
                                      },
                                    )
                                  : Image.file(
                                      File(bucket.iconPath!),
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          isActive
                                              ? Icons.play_circle_fill
                                              : isFuture
                                                  ? Icons.schedule
                                                  : Icons.check_circle,
                                          color: color,
                                          size: 30,
                                        );
                                      },
                                    ),
                        )
                      : Icon(
                          isActive
                              ? Icons.play_circle_fill
                              : isFuture
                                  ? Icons.schedule
                                  : Icons.check_circle,
                          color: color,
                          size: 30,
                        ),
                ),
                Positioned(
                  top: -2,
                  right: -2,
                  child: GestureDetector(
                    onTap: () => _showBucketContextMenu(context, ref, bucket),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.more_vert,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedExperiences(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended Experiences',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildExperienceCard(
                'Hike in the Alps',
                'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=150&h=120&fit=crop',
              ),
              const SizedBox(width: 12),
              _buildExperienceCard(
                'Explore Tokyo',
                'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=150&h=120&fit=crop',
              ),
              const SizedBox(width: 12),
              _buildExperienceCard(
                'Barcelona Adventure',
                'https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=150&h=120&fit=crop',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyBucketsState(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.folder_open,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Time Buckets Yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first time bucket to organize your life experiences',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showCreateBucketDialog(context, ref),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Create First Bucket',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(String title, String imageUrl) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 100,
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child:
                        const Icon(Icons.image, size: 40, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openBucketDetails(
      BuildContext context, WidgetRef ref, TimeBucket bucket) {
    // TODO: Navigate to bucket detail screen or show modal
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(bucket.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ages: ${bucket.startAge}-${bucket.endAge}'),
            if (bucket.description != null) ...[
              const SizedBox(height: 8),
              Text(bucket.description!),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showBucketContextMenu(
      BuildContext context, WidgetRef ref, TimeBucket bucket) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('View Details'),
              onTap: () {
                Navigator.of(context).pop();
                _openBucketDetails(context, ref, bucket);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Bucket'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Show edit bucket dialog
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Experience'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Show add experience dialog for this bucket
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Bucket',
                  style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.of(context).pop();
                final confirmed =
                    await _showDeleteConfirmation(context, bucket.name, bucket.id);
                if (confirmed && context.mounted) {
                  print('Attempting to delete bucket: ${bucket.id}');
                  final success = await ref
                      .read(bucketsProvider.notifier)
                      .deleteBucket(bucket.id);
                  print('Delete success: $success');
                  
                  if (context.mounted) {
                    if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to delete bucket. Please try again.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bucket deleted successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Force refresh the buckets list
                      ref.refresh(bucketsProvider);
                      print('Home screen: Refreshed buckets provider');
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(
      BuildContext context, String bucketName, String bucketId) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Bucket'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Are you sure you want to delete "$bucketName"?'),
                const SizedBox(height: 8),
                Text('ID: $bucketId', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                const Text(
                  'This action cannot be undone.',
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showCreateBucketDialog(BuildContext context, WidgetRef ref) {
    // Navigate to buckets screen where inline creation is available
    context.go(AppRoutes.buckets);
  }
}
