/// **Architecture Layer**: Presentation (Widgets)
/// **Purpose**: Reusable widgets for Reports & Analytics Screen (Category Breakdown, Waste Stats).

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class StockHealthOverviewCard extends StatelessWidget {
  const StockHealthOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pantry Health Index', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Icon(FluentIcons.heart_pulse_24_filled, color: Colors.green),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '88%',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Great job! Your stock waste is down by 14% compared to last month.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: 0.88,
            backgroundColor: Colors.grey[200]!,
            progressColor: Theme.of(context).primaryColor,
            barRadius: const Radius.circular(4),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class CategoryBreakdownCard extends StatelessWidget {
  const CategoryBreakdownCard({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Dairy & Eggs', 'count': '42 items', 'percent': 0.45, 'color': Colors.blue},
      {'name': 'Fresh Produce', 'count': '28 items', 'percent': 0.30, 'color': Colors.green},
      {'name': 'Bakery & Grains', 'count': '18 items', 'percent': 0.15, 'color': Colors.orange},
      {'name': 'Beverages & Snacks', 'count': '10 items', 'percent': 0.10, 'color': Colors.purple},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Stock by Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          ...categories.map((c) {
            final color = c['color'] as Color;
            final percent = c['percent'] as double;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(c['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(c['count'] as String, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearPercentIndicator(
                    lineHeight: 6.0,
                    percent: percent,
                    backgroundColor: color.withValues(alpha: 0.1),
                    progressColor: color,
                    barRadius: const Radius.circular(3),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
