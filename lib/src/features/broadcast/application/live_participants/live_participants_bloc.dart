import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart' hide Participant;

part 'live_participants_bloc.freezed.dart';
part 'live_participants_state.dart';

@lazySingleton
class LiveParticipantsBloc extends Cubit<LiveParticipantsState> {
  LiveParticipantsBloc({
    required SocketService socket,
    required IBroadcastFacade facade,
  })  : _socket = socket,
        _facade = facade,
        super(LiveParticipantsState.initial()) {
    _socketEventSub = _socket.eventsStream.listen((socketEvent) {
      socketEvent.whenOrNull(
        newBroadcastListener: _onNewBroadcastListener,
        broadcastListenerLeft: _onBroadcastListenerLeft,
      );
    });
  }
  final SocketService _socket;
  final IBroadcastFacade _facade;

  late final StreamSubscription<SocketEvent> _socketEventSub;

  Future<void> initialize(Broadcast broadcast) async {
    emit(state.copyWith(broadcast: broadcast, loading: true));
    final response = await _facade.liveListeners(broadcast.id);
    emit(
      response.fold(
        (failure) => state.copyWith(loading: false),
        (participants) => state.copyWith(
          loading: false,
          liveParticipants: participants,
          numberOfLiveParticipants: participants.length,
        ),
      ),
    );
  }

  Future<void> fetchTotal() async {
    emit(state.copyWith(loading: true));
    final response = await _facade.listeners(state.broadcast.id);
    emit(
      response.fold(
        (failure) => state.copyWith(loading: false),
        (participants) => state.copyWith(
          loading: false,
          totalParticipants: participants,
          numberOfTotalParticipants: participants.length,
        ),
      ),
    );
  }

  void _onNewBroadcastListener(BroadcastParticipant participant) {
    final updatedSet = state.liveParticipants.toSet();
    if (updatedSet.add(participant)) {
      emit(
        state.copyWith(
          liveParticipants: updatedSet.toList(),
          numberOfLiveParticipants: updatedSet.length,
        ),
      );
    }
  }

  void _onBroadcastListenerLeft(BroadcastParticipant participant) {
    Logger().w('From _onBroadcastListenerLeft => $participant');
    final updatedSet = state.liveParticipants.toSet()
      ..removeWhere((p) => p.id == participant.id);
    Logger().w('From _onBroadcastListenerLeft => $updatedSet');
    emit(
      state.copyWith(
        liveParticipants: updatedSet.toList(),
        numberOfLiveParticipants: participant.numberOfListeners!,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _socketEventSub.cancel();
    return super.close();
  }
}
