import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/dependency_injector/injector.dart';
import 'package:meno_fe_v1/src/router/router.dart';

import '../../../profile/domain/domain.dart';
import '../../domain/domain.dart';

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
          MAvatar(radius: 36.r, url: participant.imageUrl),
          MCore.large.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0).r,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                MText(
                  participant.fullName,
                  style: MTextStyle.heading3Medium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // if (isCohost) ...[
                //   MCore.small.horizontalSpace,
                //   const MBadge.cohost(),
                // ]
              ],
            ),
          ),
          MCore.micro.verticalSpace,
          if (loading.value && profile.value == null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: MCore.xxLarge).r,
              child: MShimmer(height: 24.r),
            ),
            MCore.large.verticalSpace,
          ],
          if (profile.value?.bio != null) ...[
            MText(
              profile.value!.bio!.getOr(),
              style: MTextStyle.subheadingRegular,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            MCore.large.verticalSpace,
          ],
          MPrimaryButton.icon(
            label: 'Subscribed',
            icon: const Icon(MIcons.user_check),
            onPressed: () {},
          ),
          MCore.small.verticalSpace,
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
