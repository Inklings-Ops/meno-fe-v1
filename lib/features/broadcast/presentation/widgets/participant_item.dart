import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/domain/entities/participant.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ParticipantItem extends StatelessWidget {
  const ParticipantItem({
    super.key,
    this.participant,
    this.onTap,
    this.isForAddCohost = false,
  });

  final Participant? participant;
  final VoidCallback? onTap;
  final bool isForAddCohost;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    final hasUser = participant != null;

    final role = participant?.role;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: 88,
        child: Column(
          children: [
            _ParticipantAvatar(
              participant: participant,
              isForAddCohost: isForAddCohost,
            ),
            Spaces.verticalSmall,
            MText(
              hasUser
                  ? participant!.fullName.getOrElse((_) => '')
                  : 'Add Co-host',
              style: textTheme.microMedium.copyWith(height: 1),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              color: hasUser ? null : MColor.grey50,
              textAlign: TextAlign.center,
            ),
            if (role?.isCohost ?? false) ...[
              Spaces.verticalMicro,
              _CoHostTag(participantId: participant!.id.getOrElse((_) => '')),
            ],
            if (role?.isHost ?? false) ...[
              Spaces.verticalMicro,
              _HostTag(participantId: participant!.id.getOrElse((_) => '')),
            ],
          ],
        ),
      ),
    );
  }
}

class _ParticipantAvatar extends StatelessWidget {
  const _ParticipantAvatar({required this.isForAddCohost, this.participant});

  final Participant? participant;
  final bool isForAddCohost;

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
            child: participant == null
                ? const Icon(MIcons.user, size: 16)
                : null,
          ),
          if (isForAddCohost)
            Positioned(
              left: 30,
              top: 30,
              child: Container(
                padding: const EdgeInsets.all(Insets.xs),
                decoration: BoxDecoration(
                  color: colors.error,
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: colors.background),
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

  final String participantId;

  @override
  Widget build(BuildContext context) {
    final currentUserIdOption = watchValue((UserManager m) => m.currentUserId);
    return currentUserIdOption.fold(() => const SizedBox(), (currentUserId) {
      final isYou = participantId == currentUserId.getOrElse((_) => '');
      return isYou ? const _Tag(title: 'You') : const _Tag(title: 'Host');
    });
  }
}

class _CoHostTag extends WatchingWidget {
  const _CoHostTag({required this.participantId});

  final String participantId;

  @override
  Widget build(BuildContext context) {
    final currentUserIdOption = watchValue((UserManager m) => m.currentUserId);
    return currentUserIdOption.fold(() => const SizedBox(), (currentUserId) {
      final isYou = participantId == currentUserId.getOrElse((_) => '');
      return isYou ? const _Tag(title: 'You') : const _Tag(title: 'Co-Host');
    });
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
