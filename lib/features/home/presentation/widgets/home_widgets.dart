/// **Architecture Layer**: Presentation (Widget)
/// **Purpose**: A reusable UI component specific to this feature.

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

// =============================================================================
// Header Section
// =============================================================================

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning, Alex!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your kitchen is 85% stocked.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'), // Dummy profile pic
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Notification Banner (Apples expiring soon)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Icon(FluentIcons.cube_24_filled, color: Theme.of(context).primaryColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black87),
                      children: [
                        const TextSpan(text: 'Apples expiring soon! Use in a ', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: 'Recipe',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
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
}

// =============================================================================
// Stats Row
// =============================================================================

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatCard(
            context,
            icon: FluentIcons.cube_24_regular,
            label: '142 Items',
            color: Theme.of(context).colorScheme.primary, // Green
            isActive: true, // Example of active state styling
          ),
          _buildStatCard(
            context,
            icon: FluentIcons.warning_24_regular,
            label: '5 Low',
            color: Theme.of(context).colorScheme.tertiary, // Orange
            isActive: false,
          ),
          _buildStatCard(
            context,
            icon: FluentIcons.clock_24_regular,
            label: '3 Expiring',
            color: Theme.of(context).colorScheme.primary, // Using primary for Expiring based on design usually being green in this specific mockup? Wait, usually expiring is bad.
            // In the screenshot, "3 Expiring" is Green.
            isActive: true, // This one is filled green in screenshot
            isFilled: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      bool isActive = false,
      bool isFilled = false}) {
    final bgColor = isFilled ? color : Colors.white;
    final contentColor = isFilled ? Colors.white : color;
    final borderColor = isFilled ? Colors.transparent : color.withValues(alpha: 0.3);

    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: contentColor, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: contentColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Search Bar
// =============================================================================

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search items...',
            prefixIcon: Icon(FluentIcons.search_24_regular, color: Colors.grey[400]),
            suffixIcon: Icon(FluentIcons.barcode_scanner_24_regular, color: Colors.black87),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Zone Section
// =============================================================================

class ZoneGrid extends StatelessWidget {
  const ZoneGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'The Zones',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildZoneCard(context, 'Fridge', '42 items', FluentIcons.weather_snowflake_24_regular),
              _buildZoneCard(context, 'Pantry', '85 items', FluentIcons.archive_24_regular), // No explicit cabinet icon, using closest
              _buildZoneCard(context, 'Freezer', '15 items', FluentIcons.cube_24_regular),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZoneCard(BuildContext context, String title, String subtitle, IconData icon) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Priority Feed
// =============================================================================

class PriorityFeed extends StatelessWidget {
  const PriorityFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Priority Action Feed',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildFeedItem(
            context,
            title: 'Milk (Dairy Cow)',
            subtitle: 'Expires in a day',
            subtitleColor: Theme.of(context).colorScheme.tertiary,
            progress: 0.8,
            progressColor: Theme.of(context).colorScheme.tertiary,
            imageAsset: 'assets/images/milk.png', // Placeholder
          ),
          const SizedBox(height: 12),
          _buildFeedItem(
            context,
            title: 'Red Bell Pepper',
            subtitle: 'Low Stock',
            subtitleColor: Colors.grey,
            progress: 0.3,
            progressColor: Theme.of(context).primaryColor,
            imageAsset: 'assets/images/pepper.png', // Placeholder
          ),
          const SizedBox(height: 12),
          _buildFeedItem(
            context,
            title: 'Whole Wheat Bread',
            subtitle: 'Expires tomorrow',
            subtitleColor: Theme.of(context).colorScheme.tertiary,
            progress: 0.9,
            progressColor: Theme.of(context).colorScheme.tertiary,
            imageAsset: 'assets/images/bread.png', // Placeholder
          ),
           // Just to add some padding at bottom for FAB
           const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildFeedItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color subtitleColor,
    required double progress,
    required Color progressColor,
    required String imageAsset,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(FluentIcons.food_24_regular, color: Colors.grey), // Placeholder icon
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: subtitleColor, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(FluentIcons.add_24_regular, color: Theme.of(context).colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
  }
}
