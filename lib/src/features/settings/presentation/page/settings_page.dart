import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/settings/settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final bloc = context.watch<SettingsBloc>();
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
                  onTap: () => router.push(Routes.notificationSettings),
                ),
                SettingsListTile(
                  title: 'Dark Mode',
                  leadingIcon: Icons.dark_mode_outlined,
                  trailing: Switch(
                    value: bloc.state.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      if (value) {
                        bloc.add(
                          const SettingsChangeThemeRequested(ThemeMode.dark),
                        );
                      } else {
                        bloc.add(
                          const SettingsChangeThemeRequested(ThemeMode.light),
                        );
                      }
                    },
                  ),
                ),
                SettingsListTile(
                  title: 'Location',
                  leadingIcon: Icons.pin_outlined,
                  trailing: Switch(
                    value: bloc.state.useLocation,
                    onChanged: (value) => bloc.add(
                      SettingsToggleLocationServices(value),
                    ),
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
                  leadingIcon: Icons.layers,
                  onTap: () {},
                  isDisabled: true,
                ),
                SettingsListTile(
                  title: 'Security',
                  leadingIcon: MIcons.shield,
                  onTap: () => router.push(Routes.securitySettings),
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
                  onTap: () => router.push(Routes.about),
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
                  onTap: () => router.push(Routes.logoutConfirmationDialog),
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
