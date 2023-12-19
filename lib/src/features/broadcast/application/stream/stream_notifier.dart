import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../services/live_kit_service.dart';
import '../../../../services/socket/socket_service.dart';
import '../../domain/domain.dart';
import '../broadcast_providers.dart';

part 'stream_notifier.freezed.dart';
part 'stream_notifier.g.dart';
part 'stream_state.dart';

@riverpod
class StreamNotifier extends _$StreamNotifier {
  @override
  StreamState build() => StreamState.initial();

  SocketService get streamNotifier => ref.read(socketServiceProvider.notifier);
  IBroadcastFacade get broadcastNotifier => ref.read(broadcastFacadeProvider);
  LiveKitNotifier get liveKitNotifier =>
      ref.read(liveKitNotifierProvider.notifier);

  Future<void> joinBroadcast(String broadcastId) async {
    state = state.copyWith(loading: true, onJoined: none());

    final Either<BroadcastException, JoinBroadcastEntity> result =
        await broadcastNotifier.joinBroadcast(broadcastId: broadcastId);

    result.fold(
      (l) => state = state.copyWith(loading: false, onJoined: some(result)),
      (r) async {
        state = state.copyWith(onJoined: some(result), broadcast: r);
        await liveKitNotifier.stream(r.broadcastToken);
        ref.read(socketServiceProvider.notifier).joinBroadcast(r.broadcast.id);
        state = state.copyWith(status: Status.streaming, loading: false);
        // ref.listen(liveKitEventStreamProvider, (previous, next) {
        //   Logger().w("From Broadcast Notifier: $next");
        // });
      },
    );
  }

  Future<void> leaveBroadcast() async {
    state = state.copyWith(loading: true, onLeave: none());

    await liveKitNotifier.leave();
    streamNotifier.leaveBroadcast(state.broadcast.broadcast.id);

    state = StreamState.initial();
    await liveKitNotifier.dispose();
  }

  void dispose() => state = StreamState.initial();
}
