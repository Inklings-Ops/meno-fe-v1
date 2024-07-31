import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart' hide Participant;

part 'live_participants_bloc.freezed.dart';
part 'live_participants_event.dart';
part 'live_participants_state.dart';

@lazySingleton
class LiveParticipantsBloc extends Cubit<LiveParticipantsState> {
  LiveParticipantsBloc({
    required SocketService socket,
  })  : _socket = socket,
        super(LiveParticipantsState.initial()) {
    _socketStateSub = _socket.stateStream.listen((socketState) {
      socketState.whenOrNull(
        getBroadcastListeners: (participants, _) => emit(state.copyWith(
          participants: participants,
        ),),
        getNumberOfBroadcastListeners: (value, _) => emit(state.copyWith(
          numberOfParticipants: value,
        ),),
      );
    });
    _socketEventSub = _socket.eventsStream.listen((socketEvent) {
      socketEvent.whenOrNull(
        newBroadcastListener: _onNewBroadcastListener,
        numberOfLiveListeners: _onNumberOfLiveListeners,
      );
    });
  }
  final SocketService _socket;
  late final StreamSubscription<SocketEvent> _socketEventSub;
  late final StreamSubscription<SocketState> _socketStateSub;

  Future<void> initialize(Broadcast broadcast) async {
    emit(state.copyWith(broadcast: broadcast, loading: true));
    final broadcastId = broadcast.id.getOr();
    _socket.emit(SocketEvent.getBroadcastListeners(broadcastId));
    _socket.emit(SocketEvent.getNumberOfBroadcastListeners(broadcastId));
    emit(state.copyWith(loading: false));
  }

  void _onNewBroadcastListener(BroadcastParticipant participant) {
    final currentParticipants = List<BroadcastParticipant?>.from(state.participants);
    final isAlreadyIn = currentParticipants.contains(participant);
    if (isAlreadyIn) return;
    final updatedParticipants = [...currentParticipants, participant];
    emit(state.copyWith(participants: updatedParticipants));
  }

  void _onNumberOfLiveListeners(int value) {
    emit(state.copyWith(numberOfParticipants: value));
    if (state.numberOfParticipants > value) {
      final broadcastId = state.broadcast.id.getOr();
      _socket.emit(SocketEvent.getBroadcastListeners(broadcastId));
    }
  }

  void participantLeft(BroadcastParticipant participant) {
    final currentList = List<BroadcastParticipant?>.from(state.participants);
    final updatedList = currentList.where((p) => p != participant).toList();
    emit(state.copyWith(participants: updatedList));
  }

  @override
  Future<void> close() {
    _socketEventSub.cancel();
    _socketStateSub.cancel();
    return super.close();
  }
}
