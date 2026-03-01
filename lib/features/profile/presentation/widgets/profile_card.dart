import 'package:flutter/material.dart';
import 'package:meno/features/profile/domain/domain.dart';
import 'package:meno/features/profile/presentation/presentation.dart';
import 'package:meno/shared/domain/domain.dart';
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
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: Corners.lg),
        child: Padding(
          padding: const EdgeInsets.all(Insets.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  style: MTextTheme.of(context).captionMedium,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spaces.verticalMicro,
              SizedBox(
                height: 18,
                child: MText(
                  '${profile.numberOfSubscribers} Subscribers',
                  style: textTheme.captionRegular,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
