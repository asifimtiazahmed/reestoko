/// **Architecture Layer**: Presentation (Page)
/// **Purpose**: Displays the UI for this feature and consumes the ViewModel.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reestoko/features/settings/presentation/viewmodels/settings_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Consumer<SettingsViewModel>(
          builder: (context, viewModel, child) {
            return const Center(
              child: Text('Settings Screen Placeholder'),
            );
          },
        ),
      ),
    );
  }
}
