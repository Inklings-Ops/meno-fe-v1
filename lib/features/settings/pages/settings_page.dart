import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/widgets/confirmation_dialog.dart';
import 'package:meno/features/auth/auth.dart';
import 'package:meno/features/profile/profile.dart';
import 'package:meno/features/settings/manager/settings_manager.dart';
import 'package:meno/features/settings/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

class SettingsPage extends WatchingWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    final manager = di<SettingsManager>();
    final settings = watchValue((SettingsManager m) => m.settings);
    final profile = watchValue((MyProfileManager m) => m.profile);

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
                  leadingIcon: MIcons.translate_02,
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
                  onTap: () => context.push(R.notificationSettings),
                ),
                SettingsListTile(
                  title: 'Dark Mode',
                  leadingIcon: MIcons.moon_01,
                  trailing: Switch(
                    value: settings.display == .dark,
                    onChanged: manager.toggleDarkMode,
                  ),
                ),
                SettingsListTile(
                  title: 'Location',
                  leadingIcon: MIcons.marker_pin_01,
                  trailing: Switch(
                    value: false,
                    onChanged: manager.toggleLocation,
                  ),
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
                  leadingIcon: MIcons.layers_three_01,
                  onTap: () {},
                  isDisabled: true,
                ),
                SettingsListTile(
                  title: 'Security',
                  leadingIcon: MIcons.shield,
                  onTap: () => context.push(R.securitySettings),
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
                  onTap: () => context.push(R.about),
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
                  onTap: () async => _onLogout(context, profile),
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

  Future<void> _onLogout(BuildContext context, Profile? profile) async {
    final fullName = profile?.fullName.getOrElse((_) => 'this account');
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Log out from account?',
      description: 'You are about to log out from $fullName',
    );
    if (confirmed ?? false) di<AuthManager>().logout.run();
  }
}
