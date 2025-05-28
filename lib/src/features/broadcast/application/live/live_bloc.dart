import 'dart:async';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/services/live_kit/live_kit.dart';

part 'live_event.dart';

part 'live_state.dart';

part 'live_bloc.freezed.dart';

class LiveBloc extends Bloc<LiveEvent, LiveState> {
  LiveBloc({required LiveKitService liveKit})
      : super(const LiveState.offAir()) {
    on<GoLoading>((event, emit) => emit(const LiveLoading()));
    on<GoOffAir>((event, emit) => emit(const OffAir()));
    on<GoFailure>((event, emit) => emit(const Failure()));
    on<GoReconnecting>((event, emit) => emit(const Reconnecting()));
    on<GoStreaming>((event, emit) => emit(const Streaming()));
    on<GoLive>((event, emit) => emit(const Live()));
    on<LiveStarted>((event, emit) {
      if (_subscription != null) return;
      _subscription = liveKit.eventsStream.listen(_onData);
    });
    on<LiveReset>((event, emit) async {
      await _subscription?.cancel();
      _subscription = null;
      emit(const OffAir());
    });
  }

  StreamSubscription<RoomEvent>? _subscription;

  void _onData(RoomEvent e) {
    if (e is RoomConnectedEvent) {
      add(const GoLive());
    } else if (e is RoomReconnectedEvent) {
      add(const GoLive());
    } else if (e is RoomDisconnectedEvent) {
      // add(const GoOffAir());
    } else if (e is RoomReconnectingEvent || e is RoomAttemptReconnectEvent) {
      add(const GoReconnecting());
    } else {
      return;
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
