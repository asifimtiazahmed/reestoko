/// **Architecture Layer**: Presentation (Page)
/// **Purpose**: Displays the UI for this feature and consumes the ViewModel.

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reestoko/features/main_shell/presentation/viewmodels/main_shell_view_model.dart';
import 'package:reestoko/core/utils/app_logger.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({
    super.key,
    required this.navigationShell,
  });

  void _onItemTapped(int index, BuildContext context) {
    AppLogger.d('Navigating to index: $index');
    context.read<MainShellViewModel>().setIndex(index);
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainShellViewModel>();
    
    // Sync viewModel with navigation shell in case of routing changes outside of Nav bar taps
    if (viewModel.currentIndex != navigationShell.currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<MainShellViewModel>().setIndex(navigationShell.currentIndex);
      });
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: viewModel.currentIndex,
        onDestinationSelected: (index) => _onItemTapped(index, context),
        backgroundColor: Colors.white,
        elevation: 10,
        shadowColor: Colors.black12,
        indicatorColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(FluentIcons.home_24_regular),
            selectedIcon: Icon(FluentIcons.home_24_filled),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(FluentIcons.box_24_regular),
            selectedIcon: Icon(FluentIcons.box_24_filled),
            label: 'Inventory',
          ),
          NavigationDestination(
            icon: Icon(FluentIcons.cart_24_regular),
            selectedIcon: Icon(FluentIcons.cart_24_filled),
            label: 'Shopping',
          ),
          NavigationDestination(
            icon: Icon(FluentIcons.data_usage_24_regular),
            selectedIcon: Icon(FluentIcons.data_usage_24_filled),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(FluentIcons.settings_24_regular),
            selectedIcon: Icon(FluentIcons.settings_24_filled),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
