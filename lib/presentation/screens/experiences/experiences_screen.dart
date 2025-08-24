import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/bucket_provider.dart';
import '../../../data/models/time_bucket.dart';
import '../../../data/models/experience.dart';
import '../../../data/repositories/experience_repository.dart';

class ExperiencesScreen extends ConsumerWidget {
  const ExperiencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bucketsAsync = ref.watch(bucketsProvider);
    const currentAge = 28; // TODO: Get from user profile

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'My Experiences',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.grey[50],
        elevation: 0,
      ),
      body: bucketsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (buckets) {
          if (buckets.isEmpty) {
            return _buildEmptyState(context);
          }

          // Organize buckets by status
          final activeBuckets = buckets
              .where((bucket) =>
                  currentAge >= bucket.startAge && currentAge <= bucket.endAge)
              .toList();

          final futureBuckets =
              buckets.where((bucket) => currentAge < bucket.startAge).toList();

          final pastBuckets =
              buckets.where((bucket) => currentAge > bucket.endAge).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (activeBuckets.isNotEmpty) ...[
                  _buildSectionHeader('Active Now', Colors.green,
                      '${activeBuckets.length} bucket${activeBuckets.length != 1 ? 's' : ''}'),
                  const SizedBox(height: 16),
                  ...activeBuckets.map((bucket) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildBucketExperienceCard(bucket, true),
                      )),
                  const SizedBox(height: 24),
                ],
                if (futureBuckets.isNotEmpty) ...[
                  _buildSectionHeader('Coming Up', Colors.blue,
                      '${futureBuckets.length} bucket${futureBuckets.length != 1 ? 's' : ''}'),
                  const SizedBox(height: 16),
                  ...futureBuckets.map((bucket) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildBucketExperienceCard(bucket, false),
                      )),
                  const SizedBox(height: 24),
                ],
                if (pastBuckets.isNotEmpty) ...[
                  _buildSectionHeader('Completed', Colors.grey,
                      '${pastBuckets.length} bucket${pastBuckets.length != 1 ? 's' : ''}'),
                  const SizedBox(height: 16),
                  ...pastBuckets.map((bucket) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildBucketExperienceCard(bucket, false),
                      )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.explore_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Experiences Yet',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create time buckets first, then add experiences to them',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color, String subtitle) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBucketExperienceCard(TimeBucket bucket, bool isActive) {
    final color = Color(
        int.parse(bucket.color?.replaceFirst('#', '0xFF') ?? '0xFF2196F3'));

    return FutureBuilder<List<Experience>>(
      future: ExperienceRepository().getBucketExperiences(bucket.id),
      builder: (context, experiencesSnapshot) {
        final experiences = experiencesSnapshot.data ?? [];
        final completedCount = experiences
            .where((exp) => exp.status == ExperienceStatus.completed)
            .length;
        final inProgressCount = experiences
            .where((exp) => exp.status == ExperienceStatus.inProgress)
            .length;

        return Container(
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
          child: ExpansionTile(
            tilePadding: const EdgeInsets.all(20),
            childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isActive ? Icons.folder_open : Icons.folder_outlined,
                color: color,
                size: 24,
              ),
            ),
            title: Text(
              bucket.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isActive ? color : Colors.black87,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Ages ${bucket.startAge}-${bucket.endAge}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildExperienceStatusChip(
                        experiences.length, 'Total', Colors.grey.shade600),
                    const SizedBox(width: 8),
                    if (inProgressCount > 0)
                      _buildExperienceStatusChip(
                          inProgressCount, 'In Progress', Colors.orange),
                    if (inProgressCount > 0) const SizedBox(width: 8),
                    if (completedCount > 0)
                      _buildExperienceStatusChip(
                          completedCount, 'Completed', Colors.green),
                  ],
                ),
              ],
            ),
            children: [
              if (experiences.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.explore_outlined,
                        size: 24,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'No experiences yet. Add your first experience to this bucket.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            _showAddExperienceDialog(context, bucket),
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Experiences in this bucket',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () =>
                          _showAddExperienceDialog(context, bucket),
                      icon: Icon(Icons.add, size: 16, color: color),
                      label: Text(
                        'Add Experience',
                        style: TextStyle(color: color, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...experiences.map(
                    (experience) => _buildExperienceItem(experience, color)),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildExperienceStatusChip(int count, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$count $label',
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildExperienceItem(Experience experience, Color bucketColor) {
    Color statusColor;
    IconData statusIcon;

    switch (experience.status) {
      case ExperienceStatus.completed:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case ExperienceStatus.inProgress:
        statusColor = Colors.orange;
        statusIcon = Icons.play_circle_filled;
        break;
      case ExperienceStatus.planned:
      default:
        statusColor = bucketColor.withOpacity(0.7);
        statusIcon = Icons.radio_button_unchecked;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            statusIcon,
            size: 18,
            color: statusColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  experience.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                if (experience.description != null &&
                    experience.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    experience.description!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (experience.estimatedCost > 0) ...[
                      Icon(Icons.attach_money,
                          size: 12, color: Colors.grey.shade600),
                      Text(
                        '\$${experience.estimatedCost.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (experience.timeRequired > 0) ...[
                      Icon(Icons.schedule,
                          size: 12, color: Colors.grey.shade600),
                      Text(
                        '${experience.timeRequired.toStringAsFixed(0)}h',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Icon(Icons.battery_std,
                        size: 12, color: Colors.grey.shade600),
                    Text(
                      experience.energyLevel,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) =>
                _handleExperienceAction(value, experience, bucketColor),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'view', child: Text('View Details')),
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(
                  value: 'status', child: Text('Change Status')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
            child: Icon(
              Icons.more_vert,
              size: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExperienceDialog(BuildContext context, TimeBucket bucket) {
    final experienceRepository = ExperienceRepository();
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final costController = TextEditingController();
    final timeController = TextEditingController();
    int selectedEnergy = 3;
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(int.parse(
                          bucket.color?.replaceFirst('#', '0xFF') ??
                              '0xFF2196F3'))
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.explore,
                  color: Color(int.parse(
                      bucket.color?.replaceFirst('#', '0xFF') ?? '0xFF2196F3')),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Experience',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'to ${bucket.name}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Experience Title *',
                        hintText: 'e.g., Visit Paris, Learn Guitar',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'What do you want to do or achieve?',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: costController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Estimated Cost (\$)',
                              hintText: '0',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final cost = double.tryParse(value);
                                if (cost == null || cost < 0) {
                                  return 'Invalid cost';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: timeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Time (hours)',
                              hintText: '0',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final time = double.tryParse(value);
                                if (time == null || time < 0) {
                                  return 'Invalid time';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Energy Required',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(5, (index) {
                            final energy = index + 1;
                            return GestureDetector(
                              onTap: () =>
                                  setDialogState(() => selectedEnergy = energy),
                              child: Container(
                                width: 50,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: selectedEnergy == energy
                                      ? Colors.blue.shade100
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                  border: selectedEnergy == energy
                                      ? Border.all(color: Colors.blue)
                                      : null,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.battery_std,
                                      size: 16,
                                      color: selectedEnergy == energy
                                          ? Colors.blue
                                          : Colors.grey.shade600,
                                    ),
                                    Text(
                                      energy.toString(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: selectedEnergy == energy
                                            ? Colors.blue
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;

                      setDialogState(() => isLoading = true);

                      try {
                        final experience = Experience(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          bucketId: bucket.id,
                          title: titleController.text.trim(),
                          description: descriptionController.text.trim().isEmpty
                              ? null
                              : descriptionController.text.trim(),
                          estimatedCost: costController.text.isEmpty
                              ? 0
                              : double.parse(costController.text),
                          energyRequired: selectedEnergy,
                          timeRequired: timeController.text.isEmpty
                              ? 0
                              : double.parse(timeController.text),
                          status: ExperienceStatus.planned,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        );

                        await experienceRepository.createExperience(experience);

                        if (context.mounted) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Experience "${experience.title}" added to ${bucket.name}!'),
                              backgroundColor: Color(int.parse(
                                  bucket.color?.replaceFirst('#', '0xFF') ??
                                      '0xFF2196F3')),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to create experience: $e'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      } finally {
                        setDialogState(() => isLoading = false);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(int.parse(
                    bucket.color?.replaceFirst('#', '0xFF') ?? '0xFF2196F3')),
                foregroundColor: Colors.white,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Add Experience'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleExperienceAction(
      String action, Experience experience, Color bucketColor) {
    // TODO: Implement experience actions (view, edit, status change, delete)
    switch (action) {
      case 'view':
        // Show experience details
        break;
      case 'edit':
        // Show edit experience dialog
        break;
      case 'status':
        // Show status change options
        break;
      case 'delete':
        // Show delete confirmation
        break;
    }
  }
}
