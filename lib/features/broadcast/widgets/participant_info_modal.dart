import 'package:flutter/material.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/features/broadcast/model/entities/participant.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ParticipantInfoModal extends StatelessWidget {
  const ParticipantInfoModal._({required this.participant, super.key});

  final Participant participant;

  static Future<dynamic> show(BuildContext context, Participant participant) {
    return showModalBottomSheet<dynamic>(
      context: context,
      builder: (context) => ParticipantInfoModal._(
        key: const ValueKey<String>('ParticipantInfoModal'),
        participant: participant,
      ),
      isScrollControlled: true,
      useRootNavigator: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);

    return MModal(
      builder: (context) => Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          MAvatar(radius: 36, url: participant.imageUrl),
          Spaces.verticalLarge,
          Padding(
            padding: const .symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: .center,
              mainAxisSize: .min,
              spacing: Insets.sm,
              children: [
                MText(
                  participant.fullName.getOrCrash(),
                  style: textTheme.heading3Medium,
                  maxLines: 1,
                  overflow: .ellipsis,
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
              textAlign: .center,
              maxLines: 2,
              overflow: .ellipsis,
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
