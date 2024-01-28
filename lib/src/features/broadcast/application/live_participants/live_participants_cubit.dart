import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../../services/socket/socket_service.dart';
import '../../domain/domain.dart';
import '../../infrastructure/dtos/dtos.dart';

part 'live_participants_cubit.freezed.dart';
part 'live_participants_state.dart';

@lazySingleton
class LiveParticipantsCubit extends Cubit<LiveParticipantsState> {
  final SocketService _socket;

  LiveParticipantsCubit({
    required SocketService socket,
  })  : _socket = socket,
        super(LiveParticipantsState.initial());

  @postConstruct
  void init() {
    // _socket.on(sENewBroadcastListener, onNewBroadcastListener);
    // _socket.on(sENumberOfLiveListeners, onNumberOfLiveListeners);
  }

  dynamic fetch(String broadcastId) async {
    emit(state.copyWith(loading: true, broadcastId: broadcastId));

    // return await _socket.emit(
    //   sEGetBroadcastListeners,
    //   {'broadcastId': broadcastId},
    // ).then((data) {
    //   final res = (jsonDecode(jsonEncode(data))['data']);
    //
    //   if (res == null) {
    //     return emit(state.copyWith(loading: false, participants: []));
    //   }
    //
    //   final list = (res as List);
    //   final dtos = list.map((b) => ParticipantDto.fromJson(b)).toList();
    //   final participants = dtos.map((e) => e.toDomain).toList();
    //
    //   return emit(state.copyWith(participants: participants, loading: false));
    // });
  }

  dynamic onNewBroadcastListener(dynamic data) {
    final decodedData = jsonDecode(jsonEncode(data));
    final dto = ParticipantDto.fromJson(decodedData);
    final participants = List<Participant?>.from(state.participants);
    participants.add(dto.toDomain);
    emit(state.copyWith(participants: participants));
  }

  dynamic onNumberOfLiveListeners(dynamic data) {
    Logger().w('FROM NUMBER OF LIVE LISTENERS => $data');
  }
}
