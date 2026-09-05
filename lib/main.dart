/// **Architecture Layer**: Entry Point
/// **Purpose**: Bootstraps and runs the Reestoko Flutter application across Mobile, Web, and Desktop.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:reestoko/core/di/app_config.dart';
import 'package:reestoko/core/di/app_initializer.dart';
import 'package:reestoko/core/router/app_router.dart';
import 'package:reestoko/core/services/app_crashalytics.dart';
import 'package:reestoko/core/theme/app_theme.dart';
import 'package:reestoko/core/widgets/responsive_layout_wrapper.dart';

void main() async {
  runZonedGuarded(
    () async {
      await AppConfig.configure();
      runApp(const Reestoko());
    },
    (error, stack) {
      AppCrashalytics.recordError(error, stack, reason: 'Uncaught error in main zone');
    },
  );
}

// Defer router resolution until used
GoRouter get router => GetIt.I<AppRouter>().router;

class Reestoko extends StatelessWidget {
  const Reestoko({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp.router(
        title: 'Reestoko',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        builder: (context, child) => ResponsiveLayoutWrapper(
          child: AppInitializer(child: child!),
        ),
      ),
    );
  }
}
