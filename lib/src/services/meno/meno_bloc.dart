import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
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
      startedBroadcast: (_) => add(const MenoStateChanged(MLive())),
      joinBroadcast: (_) => add(const MenoStateChanged(MStreaming())),
      leaveBroadcast: (_) => add(const MenoStateChanged(MLeaveBroadcast())),
      endedBroadcast: (b) => add(MenoStateChanged(MEndedBroadcast(b))),
    );
  }

  void _mapSocketStateToState(SocketState socketState) {
    socketState.whenOrNull(
      broadcastStarted: () => add(const MenoStateChanged(MLive())),
      broadcastJoined: () => add(const MenoStateChanged(MStreaming())),
    );
  }

  void _mapLiveKitEventToState(RoomEvent roomEvent) {
    if (roomEvent is RoomConnectedEvent) {
      add(const MenoStateChanged(MLive()));
    } else if (roomEvent is RoomReconnectedEvent) {
      add(const MenoStateChanged(MLive()));
    } else if (roomEvent is RoomDisconnectedEvent) {
      add(const MenoStateChanged(MOffAir()));
    } else if (roomEvent is RoomReconnectingEvent) {
      add(const MenoStateChanged(MReconnecting()));
    } else if (roomEvent is ParticipantDisconnectedEvent) {
      Logger().w('FROM MENO BLOC PARTICIPANT => ${roomEvent.participant}');
      final participant = BroadcastParticipant(
        id: roomEvent.participant.identity,
        fullName: roomEvent.participant.name,
      );
      add(MenoStateChanged(MLeftBroadcast(participant)));
    } else {
      Logger().w('FROM MENO BLOC ANY => $roomEvent');
      add(MenoStateChanged(state));
    }
  }

  @override
  Future<void> close() {
    _liveKitSub.cancel();
    _socketEventSub.cancel();
    _socketStateSub.cancel();
    return super.close();
  }
}
