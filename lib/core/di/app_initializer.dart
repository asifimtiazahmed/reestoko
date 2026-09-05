/// **Architecture Layer**: Core
/// **Purpose**: Dependency injection and app startup loader displaying SplashLoadingScreen.

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:reestoko/core/di/app_config.dart';
import 'package:reestoko/core/services/app_remote_config.dart';
import 'package:reestoko/core/utils/app_logger.dart';
import 'package:reestoko/core/widgets/splash_loading_screen.dart';
import 'package:reestoko/core/widgets/update_prompt_overlay.dart';

class AppInitializer extends StatefulWidget {
  final Widget child;
  const AppInitializer({super.key, required this.child});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late final Future<void> _init = _initialize();
  String _statusMessage = 'Initializing Reestoko engine...';

  Future<void> _initialize() async {
    try {
      AppLogger.d('AppInitializer: Starting initialization...');

      // 1. Run universal cross-platform AppConfig
      setState(() => _statusMessage = 'Configuring cross-platform services...');
      await AppConfig.configure();

      // 2. Simulate short splash delay for smooth visual transition
      setState(() => _statusMessage = 'Restoring user session & household...');
      await Future.delayed(const Duration(milliseconds: 1000));

      _checkUpdate();
      AppLogger.d('AppInitializer: Initialization complete.');
    } catch (e) {
      AppLogger.e('AppInitializer error: $e');
    }
  }

  void _checkUpdate() {
    if (GetIt.I.isRegistered<AppRemoteConfig>()) {
      final remoteConfig = GetIt.I<AppRemoteConfig>();
      if (remoteConfig.isUpdateRequired) {
        Future.delayed(const Duration(seconds: 1), () {
          showOverlay((context, t) {
            return UpdatePromptOverlay(
              forceUpdate: true,
              onIgnore: () {
                OverlaySupportEntry.of(context)?.dismiss();
              },
            );
          }, duration: Duration.zero);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SplashLoadingScreen(message: _statusMessage);
        }
        return widget.child;
      },
    );
  }
}
