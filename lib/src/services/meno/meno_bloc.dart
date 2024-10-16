import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

part 'meno_bloc.freezed.dart';
part 'meno_event.dart';
part 'meno_state.dart';

@Injectable()
class MenoBloc extends Bloc<MenoEvent, MenoState> {
  MenoBloc({
    required LiveKitService liveKit,
    required SocketService socket,
  })  : _liveKit = liveKit,
        _socket = socket,
        super(const MenoState.offAir()) {
    on<MenoStateChanged>((event, emit) => emit(event.state));
    _socketEventSub = _socket.eventsStream.listen(_mapSocketEventToState);
    _socketStateSub = _socket.stateStream.listen(_mapSocketStateToState);
    _liveKitSub = _liveKit.eventsStream.listen(_mapLiveKitEventToState);
  }
  final LiveKitService _liveKit;
  final SocketService _socket;
  late final StreamSubscription<RoomEvent> _liveKitSub;
  late final StreamSubscription<SocketEvent> _socketEventSub;
  late final StreamSubscription<SocketState> _socketStateSub;

  void _mapSocketEventToState(SocketEvent socketEvent) {
    socketEvent.whenOrNull(
      endedBroadcast: (b) => add(MenoStateChanged(MEndedBroadcast(b))),
    );
  }

  void _mapSocketStateToState(SocketState socketState) {
    socketState.whenOrNull();
  }

  void _mapLiveKitEventToState(RoomEvent roomEvent) {
    if (roomEvent is RoomReconnectedEvent) {
      add(const MenoStateChanged(MLive()));
    } else if (roomEvent is RoomDisconnectedEvent) {
      add(const MenoStateChanged(MOffAir()));
    } else if (roomEvent is RoomReconnectingEvent) {
      add(const MenoStateChanged(MReconnecting()));
    } else {
      add(MenoStateChanged(state));
    }
  }

  void update(MenoState state) => add(MenoStateChanged(state));

  @override
  Future<void> close() {
    _liveKitSub.cancel();
    _socketEventSub.cancel();
    _socketStateSub.cancel();
    return super.close();
  }
}
