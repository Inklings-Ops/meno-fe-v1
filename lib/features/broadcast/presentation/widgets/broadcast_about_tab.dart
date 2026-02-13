import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/applications/applications.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastAboutTab extends WatchingWidget {
  const BroadcastAboutTab({super.key});

  @override
  Widget build(BuildContext context) {
    final description = di<LiveSessionManager>().broadcast.description;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MenoSpacer.v(Insets.xl),
          const Row(
            children: [
              Icon(MIcons.menu_03, size: Insets.lg),
              Spaces.horizontalSmall,
              MenoText.subheading(
                'About Broadcast',
                weight: MenoFontWeight.bold,
              ),
            ],
          ),
          const MenoSpacer.v(Insets.lg),
          MenoText.caption(
            description.getOrNull() ?? '',
            weight: MenoFontWeight.regular,
          ),
        ],
      ),
    );
  }
}
