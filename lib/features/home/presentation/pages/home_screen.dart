/// **Architecture Layer**: Presentation (Page)
/// **Purpose**: Displays the UI for this feature and consumes the ViewModel.

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:reestoko/core/utils/app_logger.dart';
import 'package:reestoko/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:reestoko/features/home/presentation/widgets/home_widgets.dart';
import 'package:reestoko/features/inventory/presentation/viewmodels/inventory_view_model.dart';
import 'package:reestoko/features/inventory/presentation/widgets/add_edit_item_modal.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openAddModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEditItemModal(
        onSave: (newItem) {
          final vm = InventoryViewModel();
          vm.addItem('house_123', newItem);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLogger.d('HomeScreen built');
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white, // Match design background
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const HomeHeader(),
                const StatsRow(),
                const HomeSearchBar(),
                const ZoneGrid(),
                const PriorityFeed(),
                Consumer<HomeViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.isAdLoaded && viewModel.bannerAd != null) {
                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(
                            width: viewModel.bannerAd!.size.width.toDouble(),
                            height: viewModel.bannerAd!.size.height.toDouble(),
                            child: AdWidget(ad: viewModel.bannerAd!),
                          ),
                          const SizedBox(height: 80), // Extra padding for FAB/BottomNav
                        ],
                      );
                    }
                    return const SizedBox(height: 80); // Default padding if no ad
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Builder(
          builder: (builderContext) => FloatingActionButton(
            onPressed: () => _openAddModal(builderContext),
            backgroundColor: Theme.of(builderContext).colorScheme.tertiary,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
