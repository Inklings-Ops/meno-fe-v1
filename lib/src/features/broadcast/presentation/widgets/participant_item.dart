import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class ParticipantItem extends StatelessWidget {
  const ParticipantItem({
    super.key,
    this.participant,
    this.onTap,
    this.isForAddCohost = false,
  });
  final BroadcastParticipant? participant;
  final VoidCallback? onTap;
  final bool isForAddCohost;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    final hasUser = participant != null;
    final isCohost = [Role.cohost, Role.COHOST].contains(participant?.role);
    final isHost = [Role.host, Role.HOST].contains(participant?.role);
    return InkWell(
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
            SizedBox(
              height: Insets.lg,
              child: MText(
                hasUser ? participant!.fullName : 'Add Co-host',
                style: textTheme.microMedium?.copyWith(height: 1),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                color: hasUser ? null : MColor.grey50,
                textAlign: TextAlign.center,
              ),
            ),
            if (isCohost) ...[
              Spaces.verticalMicro,
              SizedBox(
                height: Insets.md,
                child: _CoHostTag(participantId: participant!.id),
              ),
            ],
            if (isHost) ...[
              Spaces.verticalMicro,
              SizedBox(
                height: Insets.md,
                child: _HostTag(participantId: participant!.id),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ParticipantAvatar extends StatelessWidget {
  const _ParticipantAvatar({required this.isForAddCohost, this.participant});
  final BroadcastParticipant? participant;
  final bool isForAddCohost;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return SizedBox.square(
      dimension: 48,
      child: Stack(
        children: [
          MAvatar(
            radius: 24,
            url: participant?.imageUrl,
            hasBorder: false,
            child:
                participant == null ? const Icon(MIcons.user, size: 16) : null,
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
                  border: Border.all(
                    width: 2,
                    color: colors.background!,
                  ),
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

class _HostTag extends StatelessWidget {
  const _HostTag({required this.participantId});
  final String participantId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        authenticated: (user, _) {
          if (participantId == user.id.getOr()) {
            return const _Tag(title: 'You');
          } else {
            return const _Tag(title: 'Host');
          }
        },
      ),
    );
  }
}

class _CoHostTag extends StatelessWidget {
  const _CoHostTag({required this.participantId});
  final String participantId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        authenticated: (user, _) {
          if (participantId == user.id.getOr()) {
            return const _Tag(title: 'You');
          } else {
            return const _Tag(title: 'Co-Host');
          }
        },
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return MText(title, style: textTheme.nanoRegular?.copyWith(height: 1));
  }
}
