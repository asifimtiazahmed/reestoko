import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:reestoko/manager/app_remote_config.dart';
import 'package:reestoko/utils/app_logger.dart';
import 'package:reestoko/widgets/common/loading_widget.dart';
import 'package:reestoko/widgets/common/update_prompt_overlay.dart';

class AppInitializer extends StatefulWidget {
  final Widget child;
  const AppInitializer({super.key, required this.child});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late final Future<void> _init = _initialize();

  Future<void> _initialize() async {
    AppLogger.d('AppInitializer: Starting initialization...');

    // TODO: Add your asset loading here
    // Example: await precacheImage(AssetImage('assets/images/logo.png'), context);

    // TODO: Add any other essential async setup that needs to block the UI
    // Example: await GetIt.I<SomeHeavyService>().init();

    // Simulate some startup delay to show splash/loading screen
    // Remove this in production if not needed
    await Future.delayed(const Duration(milliseconds: 1500));

    _checkUpdate();
    AppLogger.d('AppInitializer: Initialization complete.');
  }

  void _checkUpdate() {
    final remoteConfig = GetIt.I<AppRemoteConfig>();
    if (remoteConfig.isUpdateRequired) {
      // Small delay to ensure overlay context is ready
      Future.delayed(const Duration(seconds: 1), () {
        showOverlay((context, t) {
          return UpdatePromptOverlay(
            forceUpdate: true, // You can make this conditional based on remote config too
            onIgnore: () {
              OverlaySupportEntry.of(context)?.dismiss();
            },
          );
        }, duration: Duration.zero);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: LoadingWidget(message: 'Loading resources...'));
        }
        return widget.child;
      },
    );
  }
}
