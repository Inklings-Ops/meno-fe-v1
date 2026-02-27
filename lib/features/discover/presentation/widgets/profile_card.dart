import 'package:flutter/material.dart';
import 'package:meno/features/profile/domain/domain.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({required this.profile, super.key});
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    // final isSubscribed = profile.subscribed ?? false;

    return InkWell(
      // onTap: () => context.push(Routes.othersProfile, extra: profile.id),
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
                url: profile.imageUrl,
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
              // BlocListener<SubscriptionBloc, SubscriptionState>(
              //   listener: (context, state) {
              //     if (state.exception != null) {
              //       context.showErrorSnackBar(state.exception!.message);
              //     }
              //   },
              //   child: SubscribeButton(profile: profile),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
