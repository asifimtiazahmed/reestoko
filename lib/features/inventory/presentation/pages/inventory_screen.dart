/// **Architecture Layer**: Presentation (Page)
/// **Purpose**: Displays the UI for this feature and consumes the ViewModel.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reestoko/features/inventory/presentation/viewmodels/inventory_view_model.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InventoryViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Inventory')),
        body: Consumer<InventoryViewModel>(
          builder: (context, viewModel, child) {
            return const Center(
              child: Text('Inventory Screen Placeholder'),
            );
          },
        ),
      ),
    );
  }
}
