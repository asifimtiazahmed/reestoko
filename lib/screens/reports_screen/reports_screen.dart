import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reestoko/screens/reports_screen/reports_view_model.dart';

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
