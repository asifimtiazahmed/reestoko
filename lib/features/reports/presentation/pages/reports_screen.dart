/// **Architecture Layer**: Presentation (Page)
/// **Purpose**: Displays the UI for this feature and consumes the ViewModel.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reestoko/features/reports/presentation/viewmodels/reports_view_model.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportsViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Reports')),
        body: Consumer<ReportsViewModel>(
          builder: (context, viewModel, child) {
            return const Center(
              child: Text('Reports Screen Placeholder'),
            );
          },
        ),
      ),
    );
  }
}
