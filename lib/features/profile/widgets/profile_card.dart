import 'package:flutter/material.dart';
import 'package:meno/_core/value_objects/image_value_objects.dart';
import 'package:meno/features/profile/profile.dart';
import 'package:meno/features/profile/widgets/subscribe_button.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({required this.profile, required this.onTap, super.key});

  final Profile profile;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    // final isSubscribed = profile.subscribed ?? false;

    return InkWell(
      onTap: onTap,
      borderRadius: Corners.lg,
      child: Card(
        margin: .zero,
        shape: const RoundedRectangleBorder(borderRadius: Corners.lg),
        child: Padding(
          padding: const .all(Insets.lg),
          child: Column(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .stretch,
            children: [
              MAvatar(
                radius: Insets.xxl,
                url: profile.image?.getUrl(),
                hasBorder: false,
              ),
              const Spacer(),
              SizedBox(
                height: Insets.xl,
                child: MText(
                  profile.fullName.getOrCrash(),
                  style: textTheme.captionMedium,
                  maxLines: 1,
                  textAlign: .center,
                  overflow: .ellipsis,
                ),
              ),
              Spaces.verticalMicro,
              SizedBox(
                height: 18,
                child: MText(
                  profile.stats.subscribers.toSanitizedStr('Subscribers'),
                  style: textTheme.captionRegular,
                  maxLines: 1,
                  textAlign: .center,
                  overflow: .ellipsis,
                  color: colors.onBackground.withValues(alpha: 0.6),
                ),
              ),
              const Spacer(),
              SubscribeButton(profile: profile),
            ],
          ),
        ),
      ),
    );
  }
}
