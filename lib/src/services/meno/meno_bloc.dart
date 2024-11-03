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
    _socketEventSubscription = _socket.eventsStream.listen(_socketEventToState);
    _socketStateSubscription = _socket.stateStream.listen(_socketStateToState);
    _liveKitSubscription = _liveKit.eventsStream?.listen(_liveKitEventToState);
    
    on<MenoStateChanged>((event, emit) => emit(event.state));
  }
  
  final LiveKitService _liveKit;
  final SocketService _socket;

  StreamSubscription<RoomEvent>? _liveKitSubscription;
  StreamSubscription<SocketEvent>? _socketEventSubscription;
  StreamSubscription<SocketState>? _socketStateSubscription;

  void _socketEventToState(SocketEvent socketEvent) {
    socketEvent.whenOrNull(
      endedBroadcast: (b) => add(MenoStateChanged(MEndedBroadcast(b))),
    );
  }

  void _socketStateToState(SocketState socketState) {
    socketState.whenOrNull();
  }

  void _liveKitEventToState(RoomEvent roomEvent) {
    if (roomEvent is RoomConnectedEvent) {
      add(const MenoStateChanged(MLive()));
    } else if (roomEvent is RoomReconnectedEvent) {
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
  Future<void> close() async {
    await _liveKitSubscription?.cancel();
    await _socketEventSubscription?.cancel();
    await _socketStateSubscription?.cancel();
    _liveKitSubscription = null;
    _socketStateSubscription = null;
    _socketEventSubscription = null;
    return super.close();
  }
}
