/// **Architecture Layer**: Presentation (Page)
/// **Purpose**: Displays the UI for this feature and consumes the ViewModel.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reestoko/features/shopping/presentation/viewmodels/shopping_view_model.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShoppingViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Shopping List')),
        body: Consumer<ShoppingViewModel>(
          builder: (context, viewModel, child) {
            return const Center(
              child: Text('Shopping Screen Placeholder'),
            );
          },
        ),
      ),
    );
  }
}
