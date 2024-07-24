import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';

class ParticipantInfoModal extends HookWidget {
  final Participant participant;
  const ParticipantInfoModal({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    final facade = di<IProfileFacade>();

    final loading = useState<bool>(false);
    final profile = useState<Profile?>(null);

    useEffect(() {
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
    }, [profile, facade, participant.id]);

    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MAvatar(radius: 36.toScale, url: participant.imageUrl),
          $styles.spaces.verticalLarge,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0).radius,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                MText(
                  participant.fullName,
                  style: $styles.text.heading3Medium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // if (isCohost) ...[
                //   $styles.spaces.horizontalSmall,
                //   const MBadge.cohost(),
                // ]
              ],
            ),
          ),
          $styles.spaces.verticalMicro,
          if (loading.value && profile.value == null) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: $styles.insets.xxLarge),
              child: const MShimmer(height: 24),
            ),
            $styles.spaces.verticalLarge,
          ],
          if (profile.value?.bio != null) ...[
            MText(
              profile.value!.bio!.getOr(),
              style: $styles.text.subheadingRegular,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            $styles.spaces.verticalLarge,
          ],
          MPrimaryButton.icon(
            label: 'Subscribed',
            icon: const Icon(MIcons.user_check),
            onPressed: () {},
          ),
          $styles.spaces.verticalSmall,
          MTextButton(
            label: 'View account',
            onPressed: () => context.push(
              Routes.profile,
              extra: participant.id,
            ),
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
