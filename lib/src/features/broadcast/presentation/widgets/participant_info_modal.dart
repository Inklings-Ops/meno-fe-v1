import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

class ParticipantInfoModal extends StatelessWidget {
  const ParticipantInfoModal({required this.participant, super.key});
  final Participant participant;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OthersProfileCubit, OthersProfileState>(
      builder: (context, state) => MModal(
        builder: (context) => switch (state) {
          OthersProfileLoadFailure(:final exception) => Text(exception.message),
          OthersProfileLoadSuccess(:final profile) =>
            _Content(profile: profile),
          _ => const _Content(isLoading: true),
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({this.profile, this.isLoading = false});

  final Profile? profile;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    final colors = MColorScheme.of(context);
    final bloc = context.watch<SubscriptionBloc>();

    final isSubscribedToUser = profile?.isSubscribedToUser ?? false;

    final subscribed = (profile?.subscribed ?? false) ||
        (bloc.subscribeMap[profile?.id] ?? false);

    final isSubscribed = isSubscribedToUser || subscribed;

    final defaultStyle = OutlinedButton.styleFrom(
      backgroundColor: isSubscribed ? colors.primary : Colors.transparent,
      foregroundColor: isSubscribed ? colors.onPrimary : colors.primary,
    );

    return Skeletonizer(
      enabled: isLoading,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MAvatar(radius: 36, url: profile?.imageUrl),
          Spaces.verticalLarge,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                MText(
                  profile?.fullName.getOrCrash() ?? BoneMock.fullName,
                  style: textTheme.heading3Medium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Spaces.verticalMicro,
          if (profile?.bio != null) ...[
            MText(
              profile?.bio?.getOrCrash() ?? BoneMock.paragraph,
              style: textTheme.subheadingRegular,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Spaces.verticalLarge,
          ] else
            Spaces.verticalLarge,
          if (profile == null || isLoading)
            MPrimaryButton.icon(
              label: isSubscribed ? 'Subscribed' : 'Subscribe',
              icon: const Icon(MIcons.user_check),
              onPressed: null,
            )
          else
            SubscribeButton(
              profile: profile!,
              style: defaultStyle,
              showIcon: true,
            ),
          Spaces.verticalSmall,
          MTextButton(
            label: 'View account',
            onPressed: isLoading
                ? null
                : () => router.push(Routes.othersProfile, extra: profile?.id),
          ),
        ],
      ),
    );
  }
}
