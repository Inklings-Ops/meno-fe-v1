import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/settings/settings.dart';
import 'package:meno/features/settings/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NotificationsSettingsPage extends WatchingWidget {
  const NotificationsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final manager = di<SettingsManager>();
    final mainSettings = watchValue((SettingsManager m) => m.settings);
    final settings = mainSettings.notificationSettings;

    return MScaffold(
      appBar: MAppBar.secondary(title: 'Notifications', centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Spaces.verticalLarge,
            MText(
              'Take control of how we keep you updated.',
              style: textTheme.captionMedium,
              color: colors.inActive,
            ),
            Spaces.verticalLarge,
            SettingsSection(
              title: 'Global',
              children: [
                SettingsListTile(
                  title: 'App Notifications',
                  trailing: Switch(
                    value: mainSettings.appNotifications,
                    onChanged: manager.setAppNotifications.run,
                  ),
                ),
                SettingsListTile(
                  title: 'Push Notifications',
                  trailing: Switch(
                    value: mainSettings.pushNotifications,
                    onChanged: manager.setPushNotifications.run,
                  ),
                ),
                SettingsListTile(
                  title: 'Email Notifications',
                  showDivider: false,
                  trailing: Switch(
                    value: mainSettings.emailNotifications,
                    onChanged: manager.setEmailNotifications.run,
                  ),
                ),
              ],
            ),
            Spaces.verticalXXLarge,
            SettingsSection(
              title: 'Broadcasts',
              children: [
                SettingsListTile(
                  title: 'Live broadcasts',
                  trailing: Switch(
                    value: settings.liveBroadcastStarted,
                    onChanged: manager.setLiveBroadcastNotifications.run,
                  ),
                ),
                SettingsListTile(
                  title: 'New subscribers',
                  trailing: Switch(
                    value: settings.userSubscribed,
                    onChanged: manager.setSubscribersNotifications.run,
                  ),
                ),
                SettingsListTile(
                  title: 'Added as co-host',
                  trailing: Switch(
                    value: settings.addedAsCoHost,
                    onChanged: manager.setAddedAsCohostNotifications.run,
                  ),
                ),
                SettingsListTile(
                  title: 'Scheduled Broadcasts',
                  showDivider: false,
                  trailing: Switch(
                    value: settings.scheduledBroadcast,
                    onChanged: manager.setScheduledBroadcastNotifications.run,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
