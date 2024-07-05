import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

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
            MCore.large.verticalSpace,
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
                      size: 18.r,
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
            MCore.xxLarge.verticalSpace,
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
            MCore.xxLarge.verticalSpace,
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
                  onTap: () {},
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
            MCore.xxLarge.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MText(
          title,
          style: MTextStyle.captionMedium,
          color: colors.inActive,
        ),
        MCore.small.verticalSpace,
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MCore.large).r,
            ),
            color: colors.surfaceTint,
          ),
          child: Material(
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.onTap,
    this.isDisabled = false,
    this.trailing,
    this.showDivider = true,
    this.titleColor,
    this.iconColor,
  });

  final String title;
  final IconData leadingIcon;
  final bool isDisabled;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool showDivider;
  final MColor? titleColor;
  final MColor? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return Column(
      children: [
        ListTile(
          tileColor: resolveDisabledWithOpacity(colors.surfaceTint),
          onTap: isDisabled ? null : onTap,
          minTileHeight: 56.h,
          leading: Icon(
            leadingIcon,
            size: 20.r,
            color: iconColor ?? resolveDisabledWithOpacity(colors.primary),
          ),
          horizontalTitleGap: MCore.small.w,
          title: MText(
            title,
            style: MTextStyle.captionMedium,
            color: titleColor ??
                resolveDisabled(colors.onBackground, colors.onInActive),
          ),
          trailing: trailing ??
              Icon(
                MIcons.chevron_right,
                size: 20.r,
                color: resolveDisabledWithOpacity(colors.onBackgroundVariant),
              ),
        ),
        if (showDivider) const MDivider()
      ],
    );
  }

  MColor? resolveDisabled(MColor? main, MColor? disabled) {
    return !isDisabled ? main : disabled;
  }

  Color? resolveDisabledWithOpacity(Color? color) {
    return !isDisabled ? color : color?.withOpacity(0.5);
  }
}
