import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class ParticipantInfoModal extends StatelessWidget {
  const ParticipantInfoModal({required this.participant, super.key});
  final BroadcastParticipant participant;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;

    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MAvatar(radius: 36, url: participant.imageUrl),
          Spaces.verticalLarge,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                MText(
                  participant.fullName,
                  style: textTheme.heading3Medium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // if (isCohost) ...[
                //   Spaces.horizontalSmall,
                //   const MBadge.cohost(),
                // ]
              ],
            ),
          ),
          Spaces.verticalMicro,
          if (participant.bio != null) ...[
            MText(
              participant.bio!,
              style: textTheme.subheadingRegular,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Spaces.verticalLarge,
          ],
          if (participant.role == Role.HOST ||
              participant.role == Role.host) ...[
            MPrimaryButton(
              label: 'View Profile',
              onPressed: () => router.push(Routes.profile),
            ),
          ] else ...[
            MPrimaryButton.icon(
              label: 'Subscribed',
              icon: const Icon(MIcons.user_check),
              onPressed: () {},
            ),
            Spaces.verticalSmall,
            MTextButton(
              label: 'View account',
              onPressed: () =>
                  router.push(Routes.profile, extra: participant.id),
            ),
          ],
          // MTextButton(
          //   label: "Remove as Co-host",
          //   onPressed: () {},
          // ),
        ],
      ),
    );
  }
}
