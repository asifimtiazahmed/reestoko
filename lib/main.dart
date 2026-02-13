import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:reestoko/app_crashalytics.dart';
import 'package:reestoko/router/app_router.dart';
import 'package:reestoko/screens/home_screen.dart';
import 'package:reestoko/services/app_config.dart';
import 'package:reestoko/services/app_initializer.dart';
import 'package:reestoko/theme/app_theme.dart';

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

// Defer resolution until used
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
        builder: (context, child) => AppInitializer(child: HomeScreen()),
      ),
    );
  }
}
