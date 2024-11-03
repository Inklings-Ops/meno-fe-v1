import 'package:figma_squircle/figma_squircle.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class LiveActivityCard extends StatelessWidget {
  const LiveActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenoBloc, MenoState>(
      builder: (context, menoState) => menoState.maybeWhen(
        orElse: () => const SizedBox(),
        streaming: () => const ActivityCard(badgeTitle: 'Now Streaming'),
        reconnecting: () => const ActivityCard(badgeTitle: 'Reconnecting'),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({required this.badgeTitle, super.key});
  final String badgeTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.xxl),
      child: InkWell(
        onTap: () => router.push(Routes.stream),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: Insets.lg),
          shape: SmoothRectangleBorder(borderRadius: Corners.squircleLg),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Badge(badgeTitle: badgeTitle),
                      const SizedBox(height: 2),
                      const _StreamTitle(),
                      const _StreamCreatorName(),
                    ],
                  ),
                ),
                Spaces.horizontalMedium,
                const _LeaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.badgeTitle});
  final String badgeTitle;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    return Row(
      children: [
        CircleAvatar(
          radius: 5,
          backgroundColor: colors.secondaryContainer,
          child: CircleAvatar(radius: 3, backgroundColor: colors.secondary),
        ),
        Spaces.horizontalMicro,
        MText(badgeTitle, style: textTheme.microMedium, color: colors.error),
      ],
    );
  }
}

class _LeaveButton extends StatelessWidget {
  const _LeaveButton();

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: 32,
      maxWidth: 79,
      child: MDangerButton(
        label: 'Leave',
        onPressed: () => onLeave(context),
        style: FilledButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
        ),
      ),
    );
  }

  void onLeave(BuildContext context) {
    final bloc = context.read<StreamBloc>();
    context.showLeaveBroadcastDialog().then((value) {
      if (value == null || value == false) return;
      return bloc.add(StreamLeavePressed(bloc.state.broadcast.id));
    });
  }
}

class _StreamTitle extends StatelessWidget {
  const _StreamTitle();

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return BlocSelector<StreamBloc, StreamState, String>(
      selector: (state) => state.broadcast.title.getOr(),
      builder: (context, title) => Container(
        height: 24,
        alignment: Alignment.centerLeft,
        child: MText(
          title,
          style: textTheme.captionMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _StreamCreatorName extends StatelessWidget {
  const _StreamCreatorName();

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return BlocSelector<StreamBloc, StreamState, String?>(
      selector: (state) => state.broadcast.creator?.fullName,
      builder: (context, fullName) {
        if (fullName == null) return const SizedBox();
        return MText(
          fullName,
          style: textTheme.captionRegular,
          color: MColorScheme.of(context)!.onBackgroundVariant,
        );
      },
    );
  }
}
