import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routes.dart';

class BucketsScreen extends StatelessWidget {
  const BucketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'My Buckets',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () => context.push(AppRoutes.addBucket),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildBucketCard(
              context,
              'My 20s',
              '12 Goals',
              '3 Completed',
              'Highlight: Backpacking in SE Asia',
              Colors.orange.shade100,
              Colors.orange,
              'https://images.unsplash.com/photo-1551632811-561732d1e306?w=100&h=100&fit=crop',
            ),
            const SizedBox(height: 16),
            _buildBucketCard(
              context,
              'My 30s',
              '15 Goals',
              '5 Completed',
              'Highlight: Getting my Masters',
              Colors.purple.shade100,
              Colors.purple,
              'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=100&h=100&fit=crop',
            ),
            const SizedBox(height: 16),
            _buildBucketCard(
              context,
              'Marriage',
              '8 Goals',
              '2 Completed',
              'Highlight: Our honeymoon in Italy',
              Colors.pink.shade100,
              Colors.pink,
              'https://images.unsplash.com/photo-1469371670807-013ccf25f16a?w=100&h=100&fit=crop',
            ),
            const SizedBox(height: 16),
            _buildBucketCard(
              context,
              'Parenthood',
              '10 Goals',
              '1 Completed',
              'Highlight: First family vacation',
              Colors.green.shade100,
              Colors.green,
              'https://images.unsplash.com/photo-1511895426328-dc8714191300?w=100&h=100&fit=crop',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addBucket),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBucketCard(
    BuildContext context,
    String title,
    String goals,
    String completed,
    String highlight,
    Color bgColor,
    Color accentColor,
    String imageUrl,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
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
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      goals,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      completed,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  highlight,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: bgColor,
                    child: Icon(Icons.photo, color: accentColor, size: 30),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}