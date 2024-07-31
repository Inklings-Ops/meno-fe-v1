import 'package:meno_fe_v1/meno.dart';

import 'package:meno_fe_v1/src/features/settings/presentation/widgets/settings_list_tile.dart';
import 'package:meno_fe_v1/src/features/settings/presentation/widgets/settings_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return MScaffold(
      appBar: MAppBar.primary(title: 'Settings'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spaces.verticalLarge,
            SettingsSection(
              title: 'General',
              children: [
                SettingsListTile(
                  title: 'Language',
                  leadingIcon: Icons.language,
                  onTap: () {},
                  trailing: MTextButton.icon(
                    label: 'English',
                    icon: Icon(
                      MIcons.chevron_right,
                      size: 18,
                      color: colors.onBackgroundVariant,
                    ),
                    iconPlacement: MButtonIconPlacement.right,
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: colors.onBackgroundVariant,
                    ),
                  ),
                ),
                SettingsListTile(
                  title: 'Notifications',
                  leadingIcon: MIcons.bell,
                  onTap: () {},
                ),
                SettingsListTile(
                  title: 'Dark Mode',
                  leadingIcon: Icons.dark_mode_outlined,
                  onTap: () {},
                  trailing: Switch(value: false, onChanged: (value) {}),
                ),
                SettingsListTile(
                  title: 'Location',
                  leadingIcon: Icons.pin_outlined,
                  onTap: () {},
                  trailing: Switch(value: true, onChanged: (value) {}),
                  showDivider: false,
                ),
              ],
            ),
            Spaces.verticalXXLarge,
            SettingsSection(
              title: 'Account & Security',
              children: [
                SettingsListTile(
                  title: 'Subscriptions',
                  leadingIcon: Icons.layers,
                  onTap: () {},
                  isDisabled: true,
                ),
                SettingsListTile(
                  title: 'Security',
                  leadingIcon: MIcons.shield,
                  onTap: () {},
                  showDivider: false,
                ),
              ],
            ),
            Spaces.verticalXXLarge,
            SettingsSection(
              title: 'Other',
              children: [
                SettingsListTile(
                  title: 'About Meno',
                  leadingIcon: MIcons.users,
                  onTap: () {},
                ),
                SettingsListTile(
                  title: 'FAQs',
                  leadingIcon: MIcons.help_circle,
                  onTap: () {},
                ),
                SettingsListTile(
                  title: 'Share with friends & family',
                  leadingIcon: MIcons.share,
                  onTap: () {},
                ),
                SettingsListTile(
                  title: 'Logout',
                  leadingIcon: MIcons.log_out,
                  onTap: context.read<SessionCubit>().logout,
                ),
                SettingsListTile(
                  title: 'Delete Account',
                  leadingIcon: MIcons.trash,
                  onTap: () {},
                  titleColor: colors.error,
                  iconColor: colors.error,
                  showDivider: false,
                ),
              ],
            ),
            Spaces.verticalXXLarge,
          ],
        ),
      ),
    );
  }
}
