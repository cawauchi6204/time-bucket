import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/experience.dart';
import '../../../data/models/time_bucket.dart';
import '../../../data/providers/bucket_provider.dart';
import '../../../data/providers/user_provider.dart';
import '../../../data/repositories/experience_repository.dart';

class AddExperienceScreen extends ConsumerStatefulWidget {
  const AddExperienceScreen({super.key});

  @override
  ConsumerState<AddExperienceScreen> createState() => _AddExperienceScreenState();
}

class _AddExperienceScreenState extends ConsumerState<AddExperienceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  final _timeController = TextEditingController();
  
  String? _selectedBucketId;
  int _selectedEnergy = 3;
  bool _isLoading = false;

  final ExperienceRepository _experienceRepository = ExperienceRepository();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to create experiences')),
      );
    }

    final bucketsAsync = ref.watch(userBucketsProvider(currentUser.id));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Add New Experience',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: bucketsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (buckets) => _buildForm(buckets),
      ),
    );
  }

  Widget _buildForm(List<TimeBucket> buckets) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Experience Details'),
            const SizedBox(height: 16),
            
            _buildTitleField(),
            const SizedBox(height: 20),
            
            _buildDescriptionField(),
            const SizedBox(height: 32),
            
            _buildSectionTitle('Bucket Assignment'),
            const SizedBox(height: 16),
            _buildBucketDropdown(buckets),
            const SizedBox(height: 32),
            
            _buildSectionTitle('Resource Requirements'),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(child: _buildCostField()),
                const SizedBox(width: 16),
                Expanded(child: _buildTimeField()),
              ],
            ),
            const SizedBox(height: 20),
            
            _buildEnergySelector(),
            const SizedBox(height: 40),
            
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTitleField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _titleController,
        decoration: const InputDecoration(
          labelText: 'Experience Title *',
          hintText: 'e.g., Learn Japanese Language, Visit Tokyo',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(16),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter an experience title';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _descriptionController,
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: 'Description',
          hintText: 'Describe what you want to achieve or experience',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildBucketDropdown(List<TimeBucket> buckets) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedBucketId,
        decoration: const InputDecoration(
          labelText: 'Select Bucket *',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(16),
        ),
        items: buckets.map((bucket) {
          return DropdownMenuItem<String>(
            value: bucket.id,
            child: Text(bucket.name),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedBucketId = value;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Please select a bucket';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCostField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _costController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(
          labelText: 'Estimated Cost',
          hintText: '0',
          prefixText: '\$ ',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(16),
        ),
        validator: (value) {
          if (value != null && value.isNotEmpty) {
            final cost = double.tryParse(value);
            if (cost == null || cost < 0) {
              return 'Invalid amount';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTimeField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _timeController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(
          labelText: 'Time Required',
          hintText: '0',
          suffixText: 'hours',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(16),
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
    );
  }

  Widget _buildEnergySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          const Text(
            'Energy Level Required',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '1',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Expanded(
                child: Slider(
                  value: _selectedEnergy.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  activeColor: _getEnergyColor(_selectedEnergy),
                  onChanged: (value) {
                    setState(() {
                      _selectedEnergy = value.round();
                    });
                  },
                ),
              ),
              const Text(
                '5',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          Center(
            child: Text(
              _getEnergyLabel(_selectedEnergy),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _getEnergyColor(_selectedEnergy),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getEnergyColor(int energy) {
    switch (energy) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.deepOrange;
      case 5:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _getEnergyLabel(int energy) {
    switch (energy) {
      case 1:
        return 'Very Low Energy';
      case 2:
        return 'Low Energy';
      case 3:
        return 'Medium Energy';
      case 4:
        return 'High Energy';
      case 5:
        return 'Very High Energy';
      default:
        return 'Medium Energy';
    }
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveExperience,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Create Experience',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _saveExperience() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      final experience = Experience(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        bucketId: _selectedBucketId!,
        userId: currentUser.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        estimatedCost: _costController.text.isEmpty
            ? 0
            : double.parse(_costController.text),
        energyRequired: _selectedEnergy,
        timeRequired: _timeController.text.isEmpty
            ? 0
            : double.parse(_timeController.text),
        status: ExperienceStatus.planned,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _experienceRepository.createExperience(experience);
      
      if (mounted) {
        context.pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Experience "${experience.title}" created successfully!'),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create experience: $e'),
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
}