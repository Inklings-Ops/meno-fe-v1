import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../services/socket/event_names.dart';
import '../../../../services/socket/socket_service.dart';
import '../../domain/domain.dart';
import '../../infrastructure/dtos/dtos.dart';

part 'live_participants_bloc.freezed.dart';
part 'live_participants_event.dart';
part 'live_participants_state.dart';

@lazySingleton
class LiveParticipantsBloc
    extends Bloc<LiveParticipantsEvent, LiveParticipantsState> {
  final SocketService _socket;

  LiveParticipantsBloc({
    required SocketService socket,
  })  : _socket = socket,
        super(LiveParticipantsState.initial()) {
    on<FetchParticipants>(_onFetch);
    on<_UpdateAfterFetch>(_onUpdateAfterFetch);
    on<_UpdateParticipantList>(_onNewBroadcastListener);
    on<_UpdateParticipantNumber>(_onNumberOfLiveListeners);

    _socket.on(
      sENewBroadcastListener,
      (data) => add(_UpdateParticipantList(data)),
    );
    _socket.on(
      sENumberOfLiveListeners,
      (data) => add(_UpdateParticipantNumber(data)),
    );
  }

  _onFetch(FetchParticipants event, emit) async {
    emit(state.copyWith(loading: true, broadcastId: event.broadcastId));
    _socket.socket.emitWithAck(
      sEGetBroadcastListeners,
      {'broadcastId': event.broadcastId},
      ack: (data) => add(_UpdateAfterFetch(data)),
    );
  }

  _onNewBroadcastListener(_UpdateParticipantList event, emit) {
    final decodedData = jsonDecode(jsonEncode(event.data));
    final dto = ParticipantDto.fromJson(decodedData);
    final participants = List<Participant?>.from(state.participants);
    final updatedList = [...participants, dto.toDomain];
    emit(state.copyWith(participants: updatedList));
  }

  _onNumberOfLiveListeners(_UpdateParticipantNumber event, emit) {
    emit(state.copyWith(numberOfParticipants: event.data));
    add(FetchParticipants(state.broadcastId!));
  }

  _onUpdateAfterFetch(_UpdateAfterFetch event, emit) async {
    final res = event.data['data'] as List;

    if (res.isEmpty) {
      return emit(state.copyWith(
        loading: false,
        participants: [],
        numberOfParticipants: 0,
      ));
    }

    final list = res.map((b) => ParticipantDto.fromJson(b).toDomain).toList();

    return emit(state.copyWith(
      participants: list,
      loading: false,
      numberOfParticipants: list.length,
    ));
  }
}
