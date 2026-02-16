import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/broadcast/domain/entities/participant.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ParticipantInfoModal extends StatelessWidget {
  const ParticipantInfoModal({required this.participant, super.key});

  final Participant participant;

  static Future<dynamic> show(BuildContext context, Participant participant) {
    return showModalBottomSheet<dynamic>(
      context: context,
      builder: (context) => ParticipantInfoModal(participant: participant),
      isScrollControlled: true,
      useRootNavigator: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);

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
              spacing: Insets.sm,
              children: [
                MText(
                  participant.fullName.getOrCrash(),
                  style: textTheme.heading3Medium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                switch (participant.role) {
                  .host => MBadge.host(context),
                  .cohost => MBadge.cohost(context),
                  _ => const SizedBox.shrink(),
                },
              ],
            ),
          ),
          Spaces.verticalMicro,
          if (participant.bio != null) ...[
            MText(
              participant.bio?.getOrCrash() ?? BoneMock.paragraph,
              style: textTheme.subheadingRegular,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Spaces.verticalLarge,
          ] else
            Spaces.verticalLarge,
          const MPrimaryButton.icon(
            label: 'Subscribe',
            icon: Icon(MIcons.user_check),
            onPressed: null,
          ),
          Spaces.verticalSmall,
          MTextButton(
            label: 'View account',
            onPressed: () => context.pushNamed(
              R.othersProfile,
              pathParameters: {'id': participant.id.getOrCrash()},
            ),
          ),
        ],
      ),
    );
  }
}
