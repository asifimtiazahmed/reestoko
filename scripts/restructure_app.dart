import 'dart:io';

void main() async {
  final Map<String, String> moves = {
    'constants/app_constants.dart': 'core/constants/app_constants.dart',
    'services/app_config.dart': 'core/di/app_config.dart',
    'services/app_initializer.dart': 'core/di/app_initializer.dart',
    'screens/error_page.dart': 'core/error/error_page.dart',
    'router/app_router.dart': 'core/router/app_router.dart',
    'services/ad_manager.dart': 'core/services/ad_manager.dart',
    'manager/analytics_manager.dart': 'core/services/analytics_manager.dart',
    'manager/data_manager.dart': 'core/services/data_manager.dart',
    'services/local_storage_service.dart': 'core/services/local_storage_service.dart',
    'app_crashalytics.dart': 'core/services/app_crashalytics.dart',
    'manager/app_remote_config.dart': 'core/services/app_remote_config.dart',
    'theme/app_theme.dart': 'core/theme/app_theme.dart',
    'utils/app_logger.dart': 'core/utils/app_logger.dart',
    'widgets/common/loading_widget.dart': 'core/widgets/loading_widget.dart',
    'widgets/common/update_prompt_overlay.dart': 'core/widgets/update_prompt_overlay.dart',
    'widgets/home_widgets.dart': 'features/home/presentation/widgets/home_widgets.dart',
    'screens/home_screen/home_screen.dart': 'features/home/presentation/pages/home_screen.dart',
    'screens/home_screen/home_view_model.dart': 'features/home/presentation/viewmodels/home_view_model.dart',
    'screens/home_screen/home_screen_view_model.dart': 'features/home/presentation/viewmodels/home_screen_view_model.dart',
    'screens/inventory_screen/inventory_screen.dart': 'features/inventory/presentation/pages/inventory_screen.dart',
    'screens/inventory_screen/inventory_view_model.dart': 'features/inventory/presentation/viewmodels/inventory_view_model.dart',
    'screens/main_shell/main_shell.dart': 'features/main_shell/presentation/pages/main_shell.dart',
    'screens/main_shell/main_shell_view_model.dart': 'features/main_shell/presentation/viewmodels/main_shell_view_model.dart',
    'screens/reports_screen/reports_screen.dart': 'features/reports/presentation/pages/reports_screen.dart',
    'screens/reports_screen/reports_view_model.dart': 'features/reports/presentation/viewmodels/reports_view_model.dart',
    'screens/settings_screen/settings_screen.dart': 'features/settings/presentation/pages/settings_screen.dart',
    'screens/settings_screen/settings_view_model.dart': 'features/settings/presentation/viewmodels/settings_view_model.dart',
    'screens/shopping_screen/shopping_screen.dart': 'features/shopping/presentation/pages/shopping_screen.dart',
    'screens/shopping_screen/shopping_view_model.dart': 'features/shopping/presentation/viewmodels/shopping_view_model.dart',
    'models/user_model.dart': 'features/user/data/models/user_model.dart',
  };

  final Map<String, String> importUpdates = {};
  moves.forEach((oldPath, newPath) {
    importUpdates['package:reestoko/$oldPath'] = 'package:reestoko/$newPath';
  });

  final libDir = Directory('lib');
  
  // 1. Create directories and move files
  for (final entry in moves.entries) {
    final oldFile = File('lib/${entry.key}');
    final newFile = File('lib/${entry.value}');
    
    if (await oldFile.exists()) {
      await newFile.parent.create(recursive: true);
      await oldFile.rename(newFile.path);
      print('Moved ${entry.key} to ${entry.value}');
    }
  }

  // 2. Update imports and add headers to all dart files
  final allDartFiles = libDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  for (final file in allDartFiles) {
    String content = await file.readAsString();
    bool modified = false;

    // Fix imports
    importUpdates.forEach((oldImport, newImport) {
      if (content.contains(oldImport)) {
        content = content.replaceAll(oldImport, newImport);
        modified = true;
      }
    });

    // Fix relative imports if any existed by replacing with package imports or fixing the path
    // Mostly dart files are using package:reestoko/... based on standard practices, 
    // but the above dictionary swap catches any explicit package ones.

    // Add architectural header
    if (!content.startsWith('/// **Architecture Layer**')) {
      final relativePath = file.path.replaceAll('\\', '/').replaceAll('lib/', '');
      String layer = 'Unknown';
      String purpose = 'General utility or entry point.';
      
      if (relativePath.startsWith('core/')) {
        layer = 'Core';
        if (relativePath.contains('constants')) purpose = 'App-wide constants and configurations.';
        else if (relativePath.contains('di')) purpose = 'Dependency injection and app initialization setup.';
        else if (relativePath.contains('error')) purpose = 'Error handling and presentation.';
        else if (relativePath.contains('router')) purpose = 'Application navigation configuration.';
        else if (relativePath.contains('services')) purpose = 'External interfaces, API, or device services.';
        else if (relativePath.contains('theme')) purpose = 'Application styling and theming.';
        else if (relativePath.contains('utils')) purpose = 'General helper functions and loggers.';
        else if (relativePath.contains('widgets')) purpose = 'Shared reusable UI components.';
      } else if (relativePath.startsWith('features/')) {
        if (relativePath.contains('presentation/pages')) {
          layer = 'Presentation (Page)';
          purpose = 'Displays the UI for this feature and consumes the ViewModel.';
        } else if (relativePath.contains('presentation/viewmodels')) {
          layer = 'Presentation (ViewModel)';
          purpose = 'Manages the state and business logic for the associated Page.';
        } else if (relativePath.contains('presentation/widgets')) {
          layer = 'Presentation (Widget)';
          purpose = 'A reusable UI component specific to this feature.';
        } else if (relativePath.contains('data/models')) {
          layer = 'Data (Model)';
          purpose = 'Data representation and serialization for this feature.';
        }
      } else if (relativePath == 'main.dart') {
        layer = 'Entry Point';
        purpose = 'Bootstraps and runs the Flutter application.';
      } else if (relativePath == 'firebase_options.dart') {
        layer = 'Configuration';
        purpose = 'Firebase generated configuration file. Do not edit manually.';
      }

      final header = '''/// **Architecture Layer**: $layer
/// **Purpose**: $purpose

''';
      content = header + content;
      modified = true;
    }

    if (modified) {
      await file.writeAsString(content);
      print('Updated ${file.path}');
    }
  }

  // 3. Clean up empty directories
  final dirs = libDir.listSync(recursive: true).whereType<Directory>().toList()..sort((a, b) => b.path.length.compareTo(a.path.length));
  for (final dir in dirs) {
    if (dir.existsSync() && dir.listSync().isEmpty) {
      dir.deleteSync();
      print('Deleted empty directory ${dir.path}');
    }
  }
}
