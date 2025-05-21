import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/shared/shared.dart' show fakeBroadcasts;
import 'package:meno_fe_v1/src/shared/widgets/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NowLiveListWidget extends HookWidget {
  const NowLiveListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    Future<void> listener() async {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      const delta = 120.0;
      if (maxScroll - currentScroll <= delta) {
        final bloc = context.read<BroadcastsBloc>();
        bloc.add(const BroadcastsFetchMoreRequested());
      }
    }

    useEffect(
      () {
        scrollController.addListener(listener);
        return () => scrollController.removeListener(listener);
      },
      [scrollController],
    );

    return BlocBuilder<BroadcastsBloc, BroadcastsState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status.isLoading) {
          return _ListWidget(broadcasts: fakeBroadcasts, isLoading: true);
        }

        if (state.status.isSuccess) {
          return _ListWidget(
            broadcasts: state.broadcasts,
            scrollController: scrollController,
            moreInProgress: state.status.isLoadingMore,
            exception: state.exception,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _ListWidget extends StatelessWidget {
  const _ListWidget({
    required this.broadcasts,
    this.scrollController,
    this.isLoading = false,
    this.moreInProgress = false,
    this.exception,
  });

  final List<Broadcast?> broadcasts;
  final ScrollController? scrollController;
  final bool isLoading;
  final bool moreInProgress;
  final BroadcastException? exception;

  @override
  Widget build(BuildContext context) {
    if (broadcasts.isEmpty) return const EmptyListWidget();

    final itemCount =
        broadcasts.length + (moreInProgress || exception != null ? 1 : 0);

    return Skeletonizer(
      enabled: isLoading,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 32),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: Insets.sm,
          mainAxisSpacing: Insets.lg,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index == broadcasts.length) {
            if (exception != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Tooltip(
                    message: exception.toString(),
                    child: const Icon(Icons.error, color: Colors.red),
                  ),
                ),
              );
            }

            if (moreInProgress) {
              return Skeletonizer(
                child: MCard.live(
                  title: BoneMock.title,
                  host: BoneMock.fullName,
                ),
              );
            }

            return const SizedBox.shrink();
          }

          final broadcast = broadcasts[index]!;
          return LiveBroadcastCard(broadcast: broadcast);
        },
      ),
    );
  }
}
