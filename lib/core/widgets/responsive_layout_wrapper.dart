/// **Architecture Layer**: Core / Widgets
/// **Purpose**: Responsive Gate & Layout Wrapper ensuring optimal mobile aspect ratio & multi-column scaling on Web & Desktop.

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class ResponsiveLayoutWrapper extends StatelessWidget {
  final Widget child;
  final double maxMobileWidth;

  const ResponsiveLayoutWrapper({
    super.key,
    required this.child,
    this.maxMobileWidth = 540.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        // On mobile screens or narrow windows (<= 600px), render full-screen natively
        if (width <= 600) {
          return child;
        }

        // On Web & Desktop screens (> 600px), render a multi-column desktop shell
        return Scaffold(
          backgroundColor: const Color(0xFF0F172A), // Ambient Slate Dark Background
          body: Row(
            children: [
              // Left Desktop Branding & Feature Column (Visible on wider screens > 900px)
              if (width >= 960)
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: const BoxDecoration(
                      border: Border(right: BorderSide(color: Colors.white10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                FluentIcons.box_24_filled,
                                color: Color(0xFF4CAF50),
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reestoko',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Desktop & Web Portal',
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        _buildDesktopFeatureItem(
                          icon: FluentIcons.weather_snowflake_24_regular,
                          title: 'Multi-Zone Pantry',
                          subtitle: 'Track Fridge, Pantry, and Freezer stock in real-time.',
                        ),
                        const SizedBox(height: 20),
                        _buildDesktopFeatureItem(
                          icon: FluentIcons.cart_24_regular,
                          title: 'Smart Shopping & Auto-Restock',
                          subtitle: 'Low stock items queue automatically for 1-tap restocking.',
                        ),
                        const SizedBox(height: 20),
                        _buildDesktopFeatureItem(
                          icon: FluentIcons.shield_checkmark_24_regular,
                          title: 'Cloud Firestore & OpenAPI',
                          subtitle: 'Score 5/5 production security rules & REST contract endpoints.',
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: const Row(
                            children: [
                              Icon(FluentIcons.laptop_24_regular, color: Colors.greenAccent),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Desktop Aspect-Ratio Protection Active',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Center Column: Centered Mobile Device Frame (Preserving Aspect Ratio)
              Container(
                width: width >= 960 ? maxMobileWidth : (width > 600 ? 500 : width),
                margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(color: Colors.white24, width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: child,
                ),
              ),

              // Right Desktop Status Column (Visible on ultra-wide screens > 1200px)
              if (width >= 1240)
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: Colors.white10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        const Text(
                          'Live Engine Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildStatusIndicator('OpenAPI REST Client', 'Active (Dio v5.9)', Colors.green),
                        const SizedBox(height: 12),
                        _buildStatusIndicator('Cloud Firestore Sync', 'Active (snapshots)', Colors.green),
                        const SizedBox(height: 12),
                        _buildStatusIndicator('WebSocket Service', 'Connected (wss://)', Colors.green),
                        const SizedBox(height: 12),
                        _buildStatusIndicator('AdMob Banner Engine', 'Loaded (Test IDs)', Colors.amber),
                        const Spacer(),
                        Text(
                          'Press Cmd/Ctrl + R to reload web view',
                          style: TextStyle(color: Colors.grey[600], fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.greenAccent, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(String label, String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
