import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.grey[50],
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account section
              const Text(
                'Account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              
              _buildSettingItem(
                'Profile',
                'View and edit your profile',
                Icons.person_outline,
                Colors.orange.shade100,
                Colors.orange,
                () {},
              ),
              const SizedBox(height: 12),
              
              _buildSettingItem(
                'Subscription',
                'Manage your subscription',
                Icons.star_outline,
                Colors.blue.shade100,
                Colors.blue,
                () {},
              ),
              
              const SizedBox(height: 32),
              
              // Preferences section
              const Text(
                'Preferences',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              
              _buildSettingItem(
                'Theme',
                'Customize the app\'s appearance',
                Icons.wb_sunny_outlined,
                Colors.yellow.shade100,
                Colors.orange,
                () {},
              ),
              const SizedBox(height: 12),
              
              _buildSettingItem(
                'Notifications',
                'Manage notifications and reminders',
                Icons.notifications_none,
                Colors.red.shade100,
                Colors.red,
                () {},
              ),
              const SizedBox(height: 12),
              
              _buildSettingItem(
                'Integrations',
                'Link external accounts',
                Icons.link,
                Colors.purple.shade100,
                Colors.purple,
                () {},
              ),
              
              const SizedBox(height: 32),
              
              // Support section
              const Text(
                'Support',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              
              _buildSettingItem(
                'Help & Support',
                'Get help and support',
                Icons.help_outline,
                Colors.green.shade100,
                Colors.green,
                () {},
              ),
              const SizedBox(height: 12),
              
              _buildSettingItem(
                'About',
                'Learn more about Timebucket',
                Icons.info_outline,
                Colors.cyan.shade100,
                Colors.cyan,
                () => _showAboutDialog(context),
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildSettingItem(
    String title,
    String subtitle,
    IconData icon,
    Color bgColor,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return Container(
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
          size: 24,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'TimeBucket',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 TimeBucket. All rights reserved.',
      children: const [
        Text('Plan your life, live your dreams.'),
        SizedBox(height: 16),
        Text('TimeBucket helps you organize your life goals into meaningful time periods, inspired by the "Die With Zero" philosophy.'),
      ],
    );
  }
}