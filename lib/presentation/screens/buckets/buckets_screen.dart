import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/bucket_provider.dart';
import '../../../data/models/time_bucket.dart';
import '../../../data/repositories/experience_repository.dart';
import '../../../data/models/experience.dart';
import '../../widgets/common/icon_picker.dart';
import '../../widgets/common/bucket_icon.dart';
import '../../widgets/cards/hero_bucket_card.dart';

class BucketsScreen extends ConsumerStatefulWidget {
  const BucketsScreen({super.key});

  @override
  ConsumerState<BucketsScreen> createState() => _BucketsScreenState();
}

class _BucketsScreenState extends ConsumerState<BucketsScreen> {
  bool _showingCreateForm = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startAgeController = TextEditingController();
  final _endAgeController = TextEditingController();
  Color _selectedColor = Colors.blue;
  String? _selectedIconPath;
  bool _isLoading = false;

  final List<Color> _availableColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _startAgeController.dispose();
    _endAgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bucketsAsync = ref.watch(bucketsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'My Time Buckets',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        actions: [
          if (!_showingCreateForm)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () => setState(() => _showingCreateForm = true),
            )
          else
            IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () => _cancelBucketCreation(),
            ),
        ],
      ),
      body: Column(
        children: [
          if (_showingCreateForm) _buildInlineCreateForm(),
          Expanded(
            child: bucketsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
              data: (buckets) {
                if (buckets.isEmpty && !_showingCreateForm) {
                  return _buildEmptyState();
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: buckets.map((bucket) {
                      const currentAge = 28; // TODO: Get from user profile
                      final isActive = currentAge >= bucket.startAge && currentAge <= bucket.endAge;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: HeroBucketCard(
                          bucket: bucket,
                          experienceCount: 0, // TODO: Get actual count
                          isActive: isActive,
                          onTap: () => _showBucketDetails(bucket, []),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _showingCreateForm
          ? null
          : FloatingActionButton(
              onPressed: () => setState(() => _showingCreateForm = true),
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Time Buckets Yet',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first bucket to organize your life experiences',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => setState(() => _showingCreateForm = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text(
              'Create First Bucket',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineCreateForm() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create New Bucket',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Bucket Name *',
                  hintText: 'e.g., College Years, Career Building',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  contentPadding: EdgeInsets.all(16),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a bucket name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'What do you want to achieve during this time?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startAgeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Start Age *',
                        hintText: '18',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        contentPadding: EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        final age = int.tryParse(value);
                        if (age == null || age < 0 || age > 120) {
                          return 'Invalid age';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _endAgeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'End Age *',
                        hintText: '25',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        contentPadding: EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        final age = int.tryParse(value);
                        if (age == null || age < 0 || age > 120) {
                          return 'Invalid age';
                        }
                        final startAge = int.tryParse(_startAgeController.text);
                        if (startAge != null && age <= startAge) {
                          return 'Must be > start age';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose Color',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: _availableColors.map((color) {
                  final isSelected = color == _selectedColor;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(color: Colors.black54, width: 2)
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              IconPicker(
                currentImagePath: _selectedIconPath,
                onImageSelected: (iconPath) {
                  setState(() {
                    _selectedIconPath = iconPath;
                  });
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _cancelBucketCreation,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveBucket,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Create Bucket',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedBucketCard(TimeBucket bucket) {
    return FutureBuilder<List<Experience>>(
      future: ExperienceRepository().getBucketExperiences(bucket.id),
      builder: (context, experiencesSnapshot) {
        final experiences = experiencesSnapshot.data ?? [];
        return _buildBucketObjectCard(bucket, experiences);
      },
    );
  }

  Widget _buildBucketObjectCard(
      TimeBucket bucket, List<Experience> experiences) {
    final color = Color(
        int.parse(bucket.color?.replaceFirst('#', '0xFF') ?? '0xFF2196F3'));
    final bgColor = color.withOpacity(0.1);
    const currentAge = 28; // TODO: Get from user profile
    final isActive =
        currentAge >= bucket.startAge && currentAge <= bucket.endAge;
    final isFuture = currentAge < bucket.startAge;

    return GestureDetector(
      onTap: () => _showBucketDetails(bucket, experiences),
      onLongPress: () => _showBucketOptions(bucket),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isActive ? Border.all(color: color, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isActive ? 0.1 : 0.05),
              blurRadius: isActive ? 15 : 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Main bucket info
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Bucket icon with status
                  Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: BucketIcon(
                          iconPath: bucket.iconPath,
                          color: color,
                          size: 28,
                          fallbackIcon: isActive
                              ? Icons.folder_open
                              : isFuture
                                  ? Icons.folder_outlined
                                  : Icons.folder,
                        ),
                      ),
                      if (isActive)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Bucket details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bucket.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isActive ? color : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ages ${bucket.startAge}-${bucket.endAge}',
                          style: const TextStyle(
                            fontSize: 13,
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
                        const SizedBox(height: 8),
                        // Experience count and status
                        Row(
                          children: [
                            Icon(
                              Icons.explore,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${experiences.length} experience${experiences.length != 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? color.withOpacity(0.2)
                                    : isFuture
                                        ? Colors.blue.shade100
                                        : Colors.green.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isActive
                                    ? 'Active'
                                    : isFuture
                                        ? 'Future'
                                        : 'Past',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isActive
                                      ? color
                                      : isFuture
                                          ? Colors.blue.shade700
                                          : Colors.green.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Actions menu
                  GestureDetector(
                    onTap: () => _showBucketOptions(bucket),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.more_vert,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Experience preview (if any)
            if (experiences.isNotEmpty)
              _buildExperiencePreview(experiences, color),
          ],
        ),
      ),
    );
  }

  Widget _buildExperiencePreview(
      List<Experience> experiences, Color bucketColor) {
    final previewCount = experiences.length > 3 ? 3 : experiences.length;
    final hasMore = experiences.length > 3;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.explore_outlined,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Experiences',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const Spacer(),
                    if (hasMore)
                      Text(
                        '+${experiences.length - 3} more',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                ...experiences.take(previewCount).map(
                      (exp) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: exp.status == ExperienceStatus.completed
                                    ? Colors.green
                                    : exp.status == ExperienceStatus.inProgress
                                        ? Colors.orange
                                        : bucketColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                exp.title,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _cancelBucketCreation() {
    setState(() {
      _showingCreateForm = false;
      _nameController.clear();
      _descriptionController.clear();
      _startAgeController.clear();
      _endAgeController.clear();
      _selectedColor = Colors.blue;
      _selectedIconPath = null;
    });
  }

  Future<void> _saveBucket() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final bucket = TimeBucket(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        startAge: int.parse(_startAgeController.text),
        endAge: int.parse(_endAgeController.text),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        color: '#${_selectedColor.value.toRadixString(16).substring(2)}',
        iconPath: _selectedIconPath,
        orderIndex: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await ref.read(bucketsProvider.notifier).createBucket(bucket);

      if (mounted) {
        _cancelBucketCreation();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bucket "${bucket.name}" created successfully!'),
            backgroundColor: _selectedColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create bucket: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showBucketDetails(TimeBucket bucket, List<Experience> experiences) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          final color = Color(int.parse(
              bucket.color?.replaceFirst('#', '0xFF') ?? '0xFF2196F3'));
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: BucketIcon(
                              iconPath: bucket.iconPath,
                              color: color,
                              size: 30,
                              fallbackIcon: Icons.folder,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bucket.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Ages ${bucket.startAge}-${bucket.endAge}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'edit') {
                                Navigator.pop(context);
                                // TODO: Implement edit bucket dialog
                              } else if (value == 'delete') {
                                Navigator.pop(context);
                                final confirmed = await _showDeleteConfirmation(context, bucket.name);
                                if (confirmed && context.mounted) {
                                  print('UI: User confirmed deletion of bucket: ${bucket.name}');
                                  
                                  try {
                                    final success = await ref
                                        .read(bucketsProvider.notifier)
                                        .deleteBucket(bucket.id);
                                    
                                    print('UI: Delete operation completed with success: $success');
                                    
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
                                          SnackBar(
                                            content: Text('Bucket "${bucket.name}" deleted successfully'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    print('UI: Exception during deletion: $e');
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Error deleting bucket: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                }
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: ListTile(
                                  leading: Icon(Icons.edit, size: 20),
                                  title: Text('Edit Bucket'),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: ListTile(
                                  leading: Icon(Icons.delete, color: Colors.red, size: 20),
                                  title: Text('Delete Bucket', style: TextStyle(color: Colors.red)),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                            icon: const Icon(Icons.more_vert, color: Colors.grey),
                          ),
                        ],
                      ),
                      if (bucket.description != null &&
                          bucket.description!.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text(
                          bucket.description!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Experiences',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showAddExperienceDialog(context, bucket);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Add Experience'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (experiences.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.explore_outlined,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No Experiences Yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Add your first experience to this bucket',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ...experiences.map((exp) => Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: exp.status ==
                                              ExperienceStatus.completed
                                          ? Colors.green
                                          : exp.status ==
                                                  ExperienceStatus.inProgress
                                              ? Colors.orange
                                              : color.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          exp.title,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        if (exp.description != null &&
                                            exp.description!.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            exp.description!,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showBucketOptions(TimeBucket bucket) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('View Details'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final experiences = await ExperienceRepository()
                      .getBucketExperiences(bucket.id);
                  if (mounted) {
                    _showBucketDetails(bucket, experiences);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Bucket'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showEditBucketDialog(bucket);
                },
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Add Experience'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showAddExperienceDialog(context, bucket);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Bucket',
                    style: TextStyle(color: Colors.red)),
                onTap: () async {
                  Navigator.of(context).pop();
                  final confirmed =
                      await _showDeleteConfirmation(context, bucket.name);
                  if (confirmed && context.mounted) {
                    print('BucketsScreen: Attempting to delete bucket: ${bucket.id}');
                    final success = await ref
                        .read(bucketsProvider.notifier)
                        .deleteBucket(bucket.id);
                    print('BucketsScreen: Delete success: $success');

                    if (context.mounted) {
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${bucket.name} deleted successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Force refresh
                        ref.refresh(bucketsProvider);
                        print('Buckets screen: Refreshed buckets provider');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to delete bucket. Please try again.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _showDeleteConfirmation(
      BuildContext context, String bucketName) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Bucket'),
              content: Text(
                  'Are you sure you want to delete "$bucketName"? This action cannot be undone.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _showEditBucketDialog(TimeBucket bucket) {
    // TODO: Implement edit bucket dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit bucket functionality coming soon'),
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
                child: bucket.iconPath != null
                    ? BucketIcon(
                        iconPath: bucket.iconPath,
                        color: Color(int.parse(
                            bucket.color?.replaceFirst('#', '0xFF') ??
                                '0xFF2196F3')),
                        size: 20,
                        fallbackIcon: Icons.explore,
                      )
                    : Icon(
                        Icons.explore,
                        color: Color(int.parse(
                            bucket.color?.replaceFirst('#', '0xFF') ??
                                '0xFF2196F3')),
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
                          // Refresh the bucket list
                          setState(() {});
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
}
