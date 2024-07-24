import 'package:figma_squircle/figma_squircle.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class LiveActivityCard extends StatelessWidget {
  const LiveActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StreamBloc, StreamState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        joinSuccess: (broadcast) => BlocBuilder<MenoBloc, MenoState>(
          builder: (context, menoState) => menoState.maybeWhen(
            orElse: () => const SizedBox(),
            streaming: () => const ActivityCard(badgeTitle: 'Now Streaming'),
            reconnecting: () => const ActivityCard(badgeTitle: 'Reconnecting'),
          ),
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.badgeTitle});
  final String badgeTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: $styles.insets.xxLarge),
      child: InkWell(
        onTap: () => context.push(Routes.stream),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: $styles.insets.large),
          shape: SmoothRectangleBorder(
            borderRadius: $styles.radius.squircleLarge,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14).radius,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Badge(badgeTitle: badgeTitle),
                      2.vSpace,
                      const _StreamTitle(),
                      const _StreamCreatorName(),
                    ],
                  ),
                ),
                $styles.spaces.horizontalMedium,
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
    return Row(
      children: [
        CircleAvatar(
          radius: 5.toScale,
          backgroundColor: colors.secondaryContainer,
          child: CircleAvatar(
            radius: 3.toScale,
            backgroundColor: colors.secondary,
          ),
        ),
        $styles.spaces.horizontalMicro,
        MText(
          badgeTitle,
          style: $styles.text.microMedium,
          color: MColorScheme.of(context)?.error,
        ),
      ],
    );
  }
}

class _LeaveButton extends StatelessWidget {
  const _LeaveButton();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<StreamBloc>();
    return BlocBuilder<StreamBloc, StreamState>(
      builder: (context, state) {
        void onLeave() {
          context.showLeaveBroadcastDialog().then((value) {
            if (value == true && state is StreamJoinSuccess) {
              bloc.add(StreamEvent.leave(state.broadcast.id));
              bloc.dispose();
              context.go(Routes.home);
            }
          });
        }

        return LimitedBox(
          maxHeight: 32.toScale,
          maxWidth: 79.toScale,
          child: MDangerButton(
            label: 'Leave',
            onPressed: onLeave,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: $styles.radius.small),
            ),
          ),
        );
      },
    );
  }
}

class _StreamTitle extends StatelessWidget {
  const _StreamTitle();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StreamBloc, StreamState, String?>(
      selector: (state) => state.whenOrNull(
        joinSuccess: (b) => b.title.getOr(),
      ),
      builder: (context, title) {
        if (title == null) return const SizedBox();
        return Container(
          height: 24.toScale,
          alignment: Alignment.centerLeft,
          child: MText(
            title,
            style: $styles.text.captionMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}

class _StreamCreatorName extends StatelessWidget {
  const _StreamCreatorName();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StreamBloc, StreamState, String?>(
      selector: (state) => state.whenOrNull(
        joinSuccess: (b) => b.creator?.fullName,
      ),
      builder: (context, fullName) {
        if (fullName == null) return const SizedBox();
        return MText(
          fullName,
          style: $styles.text.captionRegular,
          color: MColorScheme.of(context)!.onBackgroundVariant,
        );
      },
    );
  }
}
