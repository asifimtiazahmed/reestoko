/// **Architecture Layer**: Presentation (Page)
/// **Purpose**: Full App Settings & User Profile Preferences Screen.

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reestoko/features/settings/presentation/viewmodels/settings_view_model.dart';
import 'package:reestoko/features/settings/presentation/widgets/settings_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsViewModel(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const UserProfileHeaderCard(),
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text('HOUSEHOLD & SYNC', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  SettingTileOption(
                    icon: FluentIcons.home_24_regular,
                    title: 'Household Profile',
                    subtitle: 'Sweet Home (ID: house_123)',
                  ),
                  const Divider(height: 1),
                  SettingTileOption(
                    icon: FluentIcons.people_24_regular,
                    title: 'Household Members',
                    subtitle: '1 Member (Single Household Mode)',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text('PREFERENCES', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  SettingTileOption(
                    icon: FluentIcons.dark_theme_24_regular,
                    title: 'App Theme',
                    subtitle: 'System Default',
                  ),
                  const Divider(height: 1),
                  SettingTileOption(
                    icon: FluentIcons.alert_24_regular,
                    title: 'Expiration & Stock Alerts',
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (val) => setState(() => _notificationsEnabled = val),
                      activeTrackColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text('ABOUT & SYSTEM', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  SettingTileOption(
                    icon: FluentIcons.document_text_24_regular,
                    title: 'OpenAPI Documentation',
                    subtitle: 'OpenAPI 3.0 Contract v1.0.0',
                  ),
                  const Divider(height: 1),
                  SettingTileOption(
                    icon: FluentIcons.info_24_regular,
                    title: 'Reestoko Version',
                    subtitle: 'v1.0.6+15 (MVP Build)',
                    trailing: const SizedBox(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
