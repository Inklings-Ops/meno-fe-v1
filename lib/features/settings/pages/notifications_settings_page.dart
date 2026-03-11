import 'package:flutter/material.dart';
import 'package:meno/features/settings/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NotificationsSettingsPage extends StatelessWidget {
  const NotificationsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      appBar: MAppBar.secondary(title: 'Notifications', centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            SettingsSection(
              title: 'Take control of how we keep you updated.',
              titleContainerHeight: 40,
              children: [
                SettingsListTile(
                  title: 'Live broadcasts',
                  trailing: Switch(value: false, onChanged: (value) {}),
                ),
                SettingsListTile(
                  title: 'New subscribers',
                  trailing: Switch(value: false, onChanged: (value) {}),
                ),
                SettingsListTile(
                  title: 'Added as co-host',
                  showDivider: false,
                  trailing: Switch(value: false, onChanged: (value) {}),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
