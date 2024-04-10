import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/broadcast/domain/entities/status.dart';

import 'meno_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'meno_state.dart';
part 'meno_event_provider.freezed.dart';
part 'meno_event_provider.g.dart';

@riverpod
class Event extends _$Event {
  @override
  MenoState build() => MenoState.initial();

  void emit(MenoEvent event) {
    state = state.copyWith(
      event: event,
      status: event.maybeWhen(
        orElse: () => state.status,
        isOffAir: () => Status.offAir,
        endedBroadcast: (_) => Status.offAir,
        isStreaming: () => Status.offAir,
        isLive: () => Status.live,
        isReconnecting: () => Status.reconnecting,
        leaveBroadcast: () => Status.offAir,
      ),
    );
  }
}
