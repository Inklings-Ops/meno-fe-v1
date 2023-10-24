import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../services/live_kit_service.dart';
import '../../../../services/socket_service/socket_service.dart';
import '../../domain/domain.dart';
import '../broadcast_form/broadcast_form.dart';
import '../broadcast_providers.dart';

part 'broadcast_notifier.freezed.dart';
part 'broadcast_notifier.g.dart';
part 'broadcast_state.dart';

enum Status { live, offAir, reconnecting }

// TODO: add dispose method and inside it set broadcast in the state to empty and dispose of livekit

@riverpod
Status broadcastStatus(BroadcastStatusRef ref) {
  final notifier = ref.read(broadcastNotifierProvider.notifier);
  Status status = ref.watch(broadcastNotifierProvider).status;

  ref.listen(liveKitEventProvider, (previous, next) {
    next.on((event) {
      switch (event.runtimeType) {
        case RoomDisconnectedEvent:
          notifier.setStatus(Status.offAir);
          break;
        case RoomReconnectingEvent:
          notifier.setStatus(Status.reconnecting);
          break;
        case RoomReconnectedEvent:
          notifier.setStatus(Status.live);
          break;
        case ParticipantConnectedEvent:
          Logger().w((event as ParticipantConnectedEvent).participant);
          break;
        default:
          notifier.setStatus(Status.offAir);
      }
    });
  });

  return status;
}

@riverpod
class BroadcastNotifier extends _$BroadcastNotifier {
  @override
  BroadcastState build() => BroadcastState.empty();

  Future<void> createPressed() async {
    Either<BroadcastException, Broadcast> result;
    final broadcastForm = ref.read(broadcastFormProvider);

    if (broadcastForm.title.isValid()) {
      state = state.copyWith(loading: true, onDeleted: none());

      result = await ref.read(broadcastFacadeProvider).createBroadcast(
            title: broadcastForm.title,
            description: broadcastForm.description,
            artwork: broadcastForm.artwork,
            cohosts: broadcastForm.cohosts?.map((e) => e.id).toList(),
            timeZone: 'Africa/Abidjan',
          );

      state = state.copyWith(
        loading: false,
        onCreated: some(result),
        broadcast: result.foldRight(Broadcast.empty(), (r, p) => r),
        onDeleted: none(),
        onStarted: none(),
      );
    } else {
      state = state.copyWith(
        loading: false,
        showError: true,
        onCreated: none(),
      );
    }
  }

  Future<void> deletePressed(String broadcastId) async {
    state = state.copyWith(loading: true, onDeleted: none());

    final Either<BroadcastException, Unit> result = await ref
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
    state = state.copyWith(loading: true);
    ref.read(liveKitNotifierProvider.notifier).dispose();
    ref.read(socketServiceProvider.notifier).endBroadcast(state.broadcast.id);
    state = state.copyWith(
      loading: false,
      status: Status.offAir,
      onDeleted: none(),
      onCreated: none(),
      onStarted: none(),
    );
  }

  Future<void> startPressed() async {
    state = state.copyWith(loading: true);

    final Either<BroadcastException, Broadcast> result = await ref
        .read(broadcastFacadeProvider)
        .startBroadcast(broadcastId: state.broadcast.id);

    result.fold(
      (l) {
        state = state.copyWith(
          loading: false,
          onStarted: some(result),
          showError: true,
        );
      },
      (r) {
        state = state.copyWith(
          loading: false,
          onStarted: some(result),
          broadcast: r,
        );
        ref.watch(liveKitNotifierProvider.notifier).connect(r.broadcastToken!);
        ref.watch(socketServiceProvider.notifier).startBroadcast(r.id);
        state = state.copyWith(status: Status.live);
      },
    );
  }

  void setStatus(Status status) => state = state.copyWith(status: status);
}
