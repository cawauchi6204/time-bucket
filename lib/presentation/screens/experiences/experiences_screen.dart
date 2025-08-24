import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme.dart';
import '../../../config/routes.dart';

class ExperiencesScreen extends StatefulWidget {
  const ExperiencesScreen({super.key});

  @override
  State<ExperiencesScreen> createState() => _ExperiencesScreenState();
}

class _ExperiencesScreenState extends State<ExperiencesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  AppBar(
                    title: const Text('Experiences'),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    tabs: const [
                      Tab(text: 'Planned'),
                      Tab(text: 'In Progress'),
                      Tab(text: 'Completed'),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildExperiencesList('planned'),
                  _buildExperiencesList('in_progress'),
                  _buildExperiencesList('completed'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addExperience),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildExperiencesList(String status) {
    final experiences = _getMockExperiences(status);

    if (experiences.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star_border,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              'No ${status.replaceAll('_', ' ')} experiences',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              'Tap the + button to add your first experience',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade500,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: experiences.length,
      itemBuilder: (context, index) {
        final experience = experiences[index];
        return _buildExperienceCard(context, experience);
      },
    );
  }

  Widget _buildExperienceCard(
      BuildContext context, Map<String, dynamic> experience) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to experience details
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(AppTheme.spacingXS),
                      decoration: BoxDecoration(
                        color: experience['bucketColor'].withOpacity(0.2),
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadiusSmall),
                      ),
                      child: Text(
                        experience['bucket'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: experience['bucketColor'],
                              fontWeight: FontWeight.w600,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showExperienceOptions(context),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                experience['title'],
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (experience['description'] != null) ...[
                const SizedBox(height: AppTheme.spacingXS),
                Text(
                  experience['description'],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: AppTheme.spacingM),
              Wrap(
                spacing: AppTheme.spacingM,
                runSpacing: AppTheme.spacingS,
                children: [
                  _buildMetric(
                      context, Icons.attach_money, '\$${experience['cost']}'),
                  _buildMetric(context, Icons.energy_savings_leaf,
                      '${experience['energy']}/5'),
                  _buildMetric(
                      context, Icons.schedule, '${experience['time']}h'),
                ],
              ),
              if (experience['status'] != 'planned') ...[
                const SizedBox(height: AppTheme.spacingM),
                LinearProgressIndicator(
                  value: experience['progress'],
                  backgroundColor: AppTheme.lightGray,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(experience['bucketColor']),
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Text(
                  '${(experience['progress'] * 100).toInt()}% complete',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(BuildContext context, IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: AppTheme.spacingXS),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getMockExperiences(String status) {
    switch (status) {
      case 'planned':
        return [
          {
            'title': 'Learn Japanese Language',
            'description':
                'Take conversational Japanese lessons and pass JLPT N4',
            'bucket': '20s',
            'bucketColor': AppTheme.primaryPink,
            'cost': 500,
            'energy': 4,
            'time': 120,
            'status': 'planned',
            'progress': 0.0,
          },
          {
            'title': 'Visit Tokyo',
            'description':
                'Two-week trip to explore Japan and practice Japanese',
            'bucket': '20s',
            'bucketColor': AppTheme.primaryPink,
            'cost': 3000,
            'energy': 5,
            'time': 336,
            'status': 'planned',
            'progress': 0.0,
          },
        ];
      case 'in_progress':
        return [
          {
            'title': 'Learn Professional Photography',
            'description': 'Master DSLR camera techniques and photo editing',
            'bucket': '20s',
            'bucketColor': AppTheme.primaryPink,
            'cost': 800,
            'energy': 3,
            'time': 80,
            'status': 'in_progress',
            'progress': 0.6,
          },
        ];
      case 'completed':
        return [
          {
            'title': 'Learn to Cook Italian Cuisine',
            'description': 'Master 10 traditional Italian dishes',
            'bucket': '20s',
            'bucketColor': AppTheme.primaryPink,
            'cost': 200,
            'energy': 3,
            'time': 40,
            'status': 'completed',
            'progress': 1.0,
          },
          {
            'title': 'Get Driving License',
            'description': 'Pass driving test and get first car',
            'bucket': 'Teens',
            'bucketColor': AppTheme.primaryLavender,
            'cost': 1500,
            'energy': 2,
            'time': 60,
            'status': 'completed',
            'progress': 1.0,
          },
        ];
      default:
        return [];
    }
  }

  void _showExperienceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Experience'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Navigate to edit experience
              },
            ),
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text('Start Experience'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Start experience
              },
            ),
            ListTile(
              leading: const Icon(Icons.check),
              title: const Text('Mark Complete'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Mark as complete
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Experience'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Show delete confirmation
              },
            ),
          ],
        ),
      ),
    );
  }
}
