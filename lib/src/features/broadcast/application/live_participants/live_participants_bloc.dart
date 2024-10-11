import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart' hide Participant;

part 'live_participants_bloc.freezed.dart';
part 'live_participants_event.dart';
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
        numberOfLiveListeners: _onNumberOfLiveListeners,
      );
    });
  }
  final SocketService _socket;
  final IBroadcastFacade _facade;
  late final StreamSubscription<SocketEvent> _socketEventSub;
  late final StreamSubscription<SocketState> _socketStateSub;

  Future<void> initialize(Broadcast broadcast) async {
    emit(state.copyWith(broadcast: broadcast, loading: true));
    final response = await _facade.liveListeners(broadcast.id);
    emit(
      response.fold(
        (failure) => state.copyWith(loading: false),
        (participants) => state.copyWith(
          loading: false,
          participants: participants,
          numberOfParticipants: participants.length,
        ),
      ),
    );
  }

  void _onNewBroadcastListener(BroadcastParticipant participant) {
    Logger().w(participant);
    final currentParticipants =
        List<BroadcastParticipant?>.from(state.participants);
    final isAlreadyIn = currentParticipants.contains(participant);
    if (isAlreadyIn) return;
    final updatedParticipants = [...currentParticipants, participant];
    emit(
      state.copyWith(
        participants: updatedParticipants,
        numberOfParticipants:
            participant.numberOfListeners ?? currentParticipants.length,
      ),
    );
  }

  void _onBroadcastListenerLeft(BroadcastParticipant participant) {
    final participants = List<BroadcastParticipant?>.from(state.participants);
    final updatedParticipants =
        participants.where((p) => p?.id != participant.id).toList();
    emit(state.copyWith(participants: updatedParticipants ));
  }

  void _onNumberOfLiveListeners(int value) {
    emit(state.copyWith(numberOfParticipants: value));
  }

  @override
  Future<void> close() {
    _socketEventSub.cancel();
    _socketStateSub.cancel();
    return super.close();
  }
}
