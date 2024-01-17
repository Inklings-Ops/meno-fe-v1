import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/src/core/broadcast/meno_event_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../services/live_kit/live_kit_service.dart';
import '../../../../services/socket/socket_service.dart';
import '../../domain/domain.dart';
import '../broadcast_form/broadcast_form_notifier.dart';
import '../broadcast_providers.dart';
import '../timer/timer_notifier.dart';

part 'broadcast_notifier.freezed.dart';
part 'broadcast_notifier.g.dart';
part 'broadcast_state.dart';

@riverpod
Future<void> mute(MuteRef ref, bool value) async {
  return await ref.watch(liveKitNotifierProvider.notifier).setMute(value);
}

@riverpod
class BroadcastNotifier extends _$BroadcastNotifier {
  @override
  BroadcastState build() {
    ref.listen(eventProvider, (_, next) {
      next.event.whenOrNull(
        isOffAir: () => ref.read(timerNotifierProvider.notifier).stop(),
        isReconnecting: () => ref.read(timerNotifierProvider.notifier).stop(),
        isLive: () => ref.read(timerNotifierProvider.notifier).start(),
      );
    });
    return BroadcastState.empty();
  }

  Future<void> createPressed() async {
    final broadcastForm = ref.read(broadcastFormNotifierProvider);

    if (broadcastForm.title.isValid()) {
      state = state.copyWith(loading: true, onDeleted: none());

      ref.invalidate(timerNotifierProvider);

      final result = await ref.read(createBroadcastProvider(
        title: broadcastForm.title,
        description: broadcastForm.description,
        artwork: broadcastForm.artwork,
        cohosts: broadcastForm.cohosts?.map((e) => e.id).toList(),
        timeZone: 'Africa/Abidjan',
      ));

      state = state.copyWith(
        loading: false,
        onDeleted: none(),
        onStarted: none(),
        onCreated: some(result),
        broadcast: result.foldRight(Broadcast.empty(), (r, p) => r),
      );

      Logger().f(result.foldRight(Broadcast.empty(), (r, p) => r));
    } else {
      state = state.copyWith(loading: false, onCreated: none());
    }
  }

  Future<void> deletePressed(String broadcastId) async {
    state = state.copyWith(loading: true, onDeleted: none());

    final result = await ref
        .read(broadcastFacadeProvider)
        .deleteBroadcast(broadcastId: broadcastId);

    state = state.copyWith(
      loading: false,
      onDeleted: some(result),
      onCreated: none(),
      onStarted: none(),
    );
  }

  Future<void> endPressed() async {
    try {
      await ref.read(liveKitNotifierProvider.notifier).leave();
    } finally {
      ref.read(socketServiceProvider.notifier).endBroadcast(state.broadcast.id);
      ref.watch(timerNotifierProvider.notifier).stop();
      state = state.copyWith(
        loading: false,
        status: Status.offAir,
        onDeleted: none(),
        onCreated: none(),
        onStarted: none(),
        onEnded: some(unit),
      );
    }
  }

  void dispose() {
    ref.invalidate(liveKitNotifierProvider);
    ref.invalidate(timerNotifierProvider);
    ref.invalidateSelf();
  }

  Future<void> startPressed() async {
    state = state.copyWith(loading: true);

    final result = await ref
        .read(broadcastFacadeProvider)
        .startBroadcast(broadcastId: state.broadcast.id);

    return result.fold(
      (l) => state = state.copyWith(loading: false, onStarted: some(result)),
      (r) async {
        await ref
            .read(liveKitNotifierProvider.notifier)
            .broadcast(r.broadcastToken!);

        ref.watch(liveKitNotifierProvider).when(
              data: (data) {
                ref.read(socketServiceProvider.notifier).startBroadcast(r.id);
                ref.read(timerNotifierProvider.notifier).start();
                state = state.copyWith(
                  status: Status.live,
                  loading: false,
                  onStarted: some(result),
                  broadcast: r,
                );
              },
              error: (err, stack) {
                state = state.copyWith(loading: false, onStarted: some(result));
              },
              loading: () => state = state.copyWith(loading: true),
            );
      },
    );
  }

  void setStatus(Status status) => state = state.copyWith(status: status);
}
