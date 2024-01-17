import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/src/features/broadcast/application/timer/timer_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../services/live_kit/live_kit_service.dart';
import '../../../../services/socket/socket_service.dart';
import '../../domain/domain.dart';
import '../broadcast_providers.dart';

part 'stream_notifier.freezed.dart';
part 'stream_notifier.g.dart';
part 'stream_state.dart';

@riverpod
class StreamNotifier extends _$StreamNotifier {
  @override
  StreamState build() {
    return StreamState.initial();
  }

  SocketService get socket => ref.read(socketServiceProvider.notifier);
  IBroadcastFacade get broadcastNotifier => ref.read(broadcastFacadeProvider);

  Future<void> joinBroadcast(String broadcastId) async {
    state = state.copyWith(loading: true, onJoined: none());

    final result =
        await broadcastNotifier.joinBroadcast(broadcastId: broadcastId);

    result.fold(
      (l) => state = state.copyWith(loading: false, onJoined: some(result)),
      (r) async {
        Logger().w(r);
        state = state.copyWith(onJoined: some(result), broadcast: r);
        await ref
            .read(liveKitNotifierProvider.notifier)
            .broadcast(r.broadcastToken);

        ref.watch(liveKitNotifierProvider).when(
              data: (data) {
                Logger().w(r);
                ref
                    .read(socketServiceProvider.notifier)
                    .joinBroadcast(r.broadcast.id);
                ref
                    .read(timerNotifierProvider.notifier)
                    .set(r.broadcast.startTime);
                ref.read(timerNotifierProvider.notifier).start();
                state = state.copyWith(loading: false);
                Logger().w(r);
              },
              error: (err, stack) {
                state = state.copyWith(loading: false, onJoined: some(result));
              },
              loading: () => state = state.copyWith(loading: true),
            );
      },
    );
  }

// TODO: Handle the scenario where someone leaves the broadcast abruptly and cannot join again. Suggest that LiveKit talks something about if someone joins a room with the same SID the old one gets kicked out
  Future<void> leaveBroadcast() async {
    state = state.copyWith(loading: true, onLeave: none());

    try {
      await ref.read(liveKitNotifierProvider.notifier).leave();
    } finally {
      socket.leaveBroadcast(state.broadcast.broadcast.id);
      ref.invalidate(timerNotifierProvider);
      ref.invalidateSelf();
    }
  }

  Future<void> dispose() async {
    await ref.read(liveKitNotifierProvider.notifier).dispose();
    state = StreamState.initial();
  }
}
