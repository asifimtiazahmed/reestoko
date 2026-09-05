/// **Architecture Layer**: Presentation (Page)
/// **Purpose**: Reports & Analytics Screen displaying stock health and category metrics.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reestoko/features/reports/presentation/viewmodels/reports_view_model.dart';
import 'package:reestoko/features/reports/presentation/widgets/reports_widgets.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportsViewModel(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Reports & Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              StockHealthOverviewCard(),
              SizedBox(height: 16),
              CategoryBreakdownCard(),
            ],
          ),
        ),
      ),
    );
  }
}
