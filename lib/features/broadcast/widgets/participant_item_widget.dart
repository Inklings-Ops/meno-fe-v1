import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/value_objects/id.dart';
import 'package:meno/_shared/manager/user_manager.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ParticipantItemWidget extends StatelessWidget {
  const ParticipantItemWidget({
    super.key,
    this.participant,
    this.onTap,
    this.isEmpty = false,
    this.isSelected = false,
  });

  final Participant? participant;
  final VoidCallback? onTap;
  final bool isEmpty;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);

    final role = participant?.role;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: 88,
        child: Stack(
          children: [
            Column(
              children: [
                _ParticipantAvatar(participant: participant, isEmpty: isEmpty),
                Spaces.verticalSmall,
                MText(
                  isEmpty ? participant!.fullName.getOrCrash() : 'Add Co-host',
                  style: textTheme.microMedium.copyWith(height: 1),
                  maxLines: 1,
                  overflow: .ellipsis,
                  color: isEmpty ? null : MColor.grey50,
                  textAlign: .center,
                ),
                if (role?.isCohost ?? false) ...[
                  Spaces.verticalMicro,
                  _CoHostTag(participantId: participant!.id),
                ],
                if (role?.isHost ?? false) ...[
                  Spaces.verticalMicro,
                  _HostTag(participantId: participant!.id),
                ],
              ],
            ),
            if (isSelected) ...[
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: .all(color: Colors.white, width: 1.5),
                    shape: .circle,
                  ),
                  child: const Icon(
                    MIcons.x_close,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ParticipantAvatar extends StatelessWidget {
  const _ParticipantAvatar({required this.isEmpty, this.participant});

  final Participant? participant;
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    return SizedBox.square(
      dimension: 48,
      child: Stack(
        children: [
          MAvatar(
            radius: 24,
            url: participant?.imageUrl,
            hasBorder: false,
            child: isEmpty ? const Icon(MIcons.user, size: 16) : null,
          ),
          if (isEmpty)
            Positioned(
              left: 30,
              top: 30,
              child: Container(
                padding: const .all(Insets.xs),
                decoration: BoxDecoration(
                  color: colors.error,
                  shape: .circle,
                  border: .all(width: 2, color: colors.background),
                ),
                child: Icon(
                  MIcons.x_close,
                  size: Insets.sm,
                  color: colors.onError,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HostTag extends WatchingWidget {
  const _HostTag({required this.participantId});

  final Id participantId;

  @override
  Widget build(BuildContext context) {
    final currentUserId = watchValue((UserManager m) => m.currentUserId);
    final isYou = participantId == currentUserId;
    return isYou ? const _Tag(title: 'You') : const _Tag(title: 'Host');
  }
}

class _CoHostTag extends WatchingWidget {
  const _CoHostTag({required this.participantId});

  final Id participantId;

  @override
  Widget build(BuildContext context) {
    final currentUserId = watchValue((UserManager m) => m.currentUserId);
    final isYou = participantId == currentUserId;
    return isYou ? const _Tag(title: 'You') : const _Tag(title: 'Co-Host');
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return MText(title, style: textTheme.nanoRegular.copyWith(height: 1));
  }
}
