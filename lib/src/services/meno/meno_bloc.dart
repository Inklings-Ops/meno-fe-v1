import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/domain.dart';
import 'package:meno_fe_v1/src/services/live_kit/live_kit.dart' as lv;
import 'package:meno_fe_v1/src/services/socket/socket.dart';

part 'meno_bloc.freezed.dart';
part 'meno_event.dart';
part 'meno_state.dart';

@Injectable()
class MenoBloc extends Bloc<MenoEvent, MenoState> {
  final lv.LiveKitService _liveKit;
  final SocketService _socket;
  late final StreamSubscription<lv.RoomEvent> _liveKitSub;
  late final StreamSubscription<SocketEvent> _socketEventSub;
  late final StreamSubscription<SocketState> _socketStateSub;
  MenoBloc({
    required lv.LiveKitService liveKit,
    required SocketService socket,
  })  : _liveKit = liveKit,
        _socket = socket,
        super(const MenoState.offAir()) {
    on<MenoStateChanged>((event, emit) => emit(event.state));
    _socketEventSub = _socket.eventsStream.listen(_mapSocketEventToState);
    _socketStateSub = _socket.stateStream.listen(_mapSocketStateToState);
    _liveKitSub = _liveKit.eventsStream.listen(_mapLiveKitEventToState);
  }

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

  void _mapLiveKitEventToState(lv.RoomEvent roomEvent) {
    if (roomEvent is lv.RoomConnectedEvent) {
      add(const MenoStateChanged(MLive()));
    } else if (roomEvent is lv.RoomReconnectedEvent) {
      add(const MenoStateChanged(MLive()));
    } else if (roomEvent is lv.RoomDisconnectedEvent) {
      add(const MenoStateChanged(MOffAir()));
    } else if (roomEvent is lv.RoomReconnectingEvent) {
      add(const MenoStateChanged(MReconnecting()));
    } else if (roomEvent is lv.ParticipantDisconnectedEvent) {
      Logger().w('FROM MENO BLOC PARTICIPANT => ${roomEvent.participant}');
      final participant = Participant(
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
