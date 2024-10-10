import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';

class ParticipantInfoModal extends HookWidget {
  const ParticipantInfoModal({required this.participant, super.key});
  final BroadcastParticipant participant;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;

    final facade = di<IProfileFacade>();

    final loading = useState<bool>(false);
    final profile = useState<Profile?>(null);

    useEffect(
      () {
        if (profile.value == null) {
          loading.value = true;
          facade.getProfile(participant.id).then((v) {
            v.fold((l) => null, (r) {
              profile.value = r;
              loading.value = false;
            });
          });
        }
        return null;
      },
      [profile, facade, participant.id],
    );

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
          if (loading.value && profile.value == null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.xxl),
              child: MShimmer(height: 24),
            ),
            Spaces.verticalLarge,
          ],
          if (profile.value?.bio != null) ...[
            MText(
              profile.value!.bio!.getOr(),
              style: textTheme.subheadingRegular,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Spaces.verticalLarge,
          ],
          MPrimaryButton.icon(
            label: 'Subscribed',
            icon: const Icon(MIcons.user_check),
            onPressed: () {},
          ),
          Spaces.verticalSmall,
          MTextButton(
            label: 'View account',
            onPressed: () => router.push(Routes.profile, extra: participant.id),
          ),
          // MTextButton(
          //   label: "Remove as Co-host",
          //   onPressed: () {},
          // ),
        ],
      ),
    );
  }
}
