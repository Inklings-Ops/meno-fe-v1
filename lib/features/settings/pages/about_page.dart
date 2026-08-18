import 'package:flutter/material.dart';
import 'package:meno/features/settings/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    final trailingColor = colors.onBackgroundVariant;
    return MScaffold(
      appBar: MAppBar.secondary(title: 'About Menō', centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            SettingsSection(
              children: [
                SettingsListTile(
                  title: 'Version',
                  trailing: MText(
                    'Beta',
                    style: textTheme.captionMedium,
                    color: trailingColor,
                  ),
                  onTap: () {},
                ),
                SettingsListTile(title: 'Report an app problem', onTap: () {}),
                SettingsListTile(
                  title: 'Privacy Policy',
                  onTap: () {},
                  trailing: Icon(
                    MIcons.arrow_narrow_up_right,
                    size: 20,
                    color: trailingColor,
                  ),
                ),
                SettingsListTile(
                  title: 'Terms & Conditions',
                  showDivider: false,
                  onTap: () {},
                  trailing: Icon(
                    MIcons.arrow_narrow_up_right,
                    size: 20,
                    color: trailingColor,
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
