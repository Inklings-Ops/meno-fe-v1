import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class ParticipantItem extends StatelessWidget {
  const ParticipantItem({
    super.key,
    this.participant,
    this.onTap,
    this.isCreator = false,
    this.isCohost = false,
    this.isForAddCohost = false,
  });
  final Participant? participant;
  final VoidCallback? onTap;
  final bool isCohost;
  final bool isForAddCohost;
  final bool isCreator;

  @override
  Widget build(BuildContext context) {
    final hasUser = participant != null;
    return InkWell(
      onTap: onTap,
      child: SizedBox.square(
        dimension: 88.toScale,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _ParticipantAvatar(
              participant: participant,
              isForAddCohost: isForAddCohost,
            ),
            $styles.spaces.verticalSmall,
            SizedBox(
              height: $styles.insets.large,
              child: MText(
                hasUser ? participant!.fullName : 'Add Co-host',
                style: $styles.text.microMedium.copyWith(height: 1),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                color: hasUser ? null : MColor.grey50,
                textAlign: TextAlign.center,
              ),
            ),
            if (isCohost) ...[
              $styles.spaces.verticalMicro,
              SizedBox(
                height: $styles.insets.medium,
                child: _CoHostTag(participantId: participant!.id),
              ),
            ],
            if (isCreator) ...[
              $styles.spaces.verticalMicro,
              SizedBox(
                height: $styles.insets.medium,
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
  const _ParticipantAvatar({this.participant, required this.isForAddCohost});
  final Participant? participant;
  final bool isForAddCohost;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return SizedBox.square(
      dimension: 48.toScale,
      child: Stack(
        fit: StackFit.loose,
        children: [
          MAvatar(
            radius: 24.toScale,
            url: participant?.imageUrl,
            hasBorder: false,
            child: participant == null
                ? Icon(MIcons.user, size: 16.toScale)
                : null,
          ),
          if (isForAddCohost)
            Positioned(
              left: 30.toScale,
              top: 30.toScale,
              child: Container(
                padding: EdgeInsets.all($styles.insets.micro),
                decoration: BoxDecoration(
                  color: colors.error,
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2.toScale,
                    color: colors.background!,
                  ),
                ),
                child: Icon(
                  MIcons.x_close,
                  size: $styles.insets.small,
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
    return MText(title, style: $styles.text.nanoRegular.copyWith(height: 1));
  }
}
