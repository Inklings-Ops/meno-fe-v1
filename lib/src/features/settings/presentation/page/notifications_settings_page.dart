import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/settings/settings.dart';

class NotificationsSettingsPage extends StatelessWidget {
  const NotificationsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<SettingsBloc>();
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
                  trailing: Switch(
                    value: bloc.state.receiveLiveBroadcastsNotifications,
                    onChanged: (value) {
                      bloc.add(ToggleLiveBroadcastsNotifications(value));
                    },
                  ),
                ),
                SettingsListTile(
                  title: 'New subscribers',
                  trailing: Switch(
                    value: bloc.state.receiveNewSubscribersNotifications,
                    onChanged: (value) {
                      bloc.add(ToggleNewSubscribersNotifications(value));
                    },
                  ),
                ),
                SettingsListTile(
                  title: 'Added as co-host',
                  showDivider: false,
                  trailing: Switch(
                    value: bloc.state.receiveAddedCohostNotifications,
                    onChanged: (value) {
                      bloc.add(ToggleAddedCohostNotifications(value));
                    },
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
