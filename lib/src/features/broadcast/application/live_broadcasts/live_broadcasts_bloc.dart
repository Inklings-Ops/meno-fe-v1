import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../services/socket/event_names.dart';
import '../../../../services/socket/socket_response.dart';
import '../../../../services/socket/socket_service.dart';
import '../../domain/domain.dart';
import '../../infrastructure/dtos/dtos.dart';

part 'live_broadcasts_bloc.freezed.dart';
part 'live_broadcasts_event.dart';
part 'live_broadcasts_state.dart';

@lazySingleton
class LiveBroadcastsBloc
    extends Bloc<LiveBroadcastsEvent, LiveBroadcastsState> {
  final SocketService _socket;

  LiveBroadcastsBloc({required SocketService socket})
      : _socket = socket,
        super(const _Loading()) {
    on<_GetLiveBroadcasts>(_onGetLiveBroadcasts);
    on<_UpdateOnNewBroadcast>(_onUpdateOnNewBroadcast);
    on<_UpdateOnEndedBroadcast>(_onUpdateOnEndedBroadcast);
    on<_FilterBroadcasts>(_onFilterBroadcasts);

    _socket.on(sEConnect, (_) => add(const _GetLiveBroadcasts()));
    _socket.on(sENewBroadcast, (data) => add(_UpdateOnNewBroadcast(data)));
    _socket.on(sEEndedBroadcast, (data) => add(_UpdateOnEndedBroadcast(data)));
  }

  _onFilterBroadcasts(_FilterBroadcasts event, emit) {
    final response = SocketResponse<List<Broadcast?>>.fromJson(
      event.data,
      (s) => (s as List).map((e) => BroadcastDto.fromJson(e).toDomain).toList(),
    );

    if (response.data?.isEmpty == true) {
      return emit(const _Empty());
    } else {
      return emit(_Success(response.data!));
    }
  }

  void _onGetLiveBroadcasts(_GetLiveBroadcasts event, emit) {
    emit(const _Loading());
    _socket.emitWithAck(
      sEGetLiveBroadcasts,
      {},
      ack: (data) => add(_FilterBroadcasts(data)),
    );
  }

  _onUpdateOnNewBroadcast(_UpdateOnNewBroadcast event, emit) async {
    final dto = BroadcastDto.fromJson(event.data);

    if (state is _Empty) {
      final liveBroadcasts = List<Broadcast?>.from([]);
      final updatedList = [dto.toDomain, ...liveBroadcasts];
      emit(_Success(updatedList));
    } else if (state is _Success) {
      final success = (state as _Success);
      final liveBroadcasts = List<Broadcast?>.from(success.broadcasts);
      final updatedList = [dto.toDomain, ...liveBroadcasts];
      emit(_Success(updatedList));
    }
  }

  _onUpdateOnEndedBroadcast(_UpdateOnEndedBroadcast event, emit) async {
    if (state is _Success) {
      final dto = BroadcastDto.fromJson(event.data);

      final success = (state as _Success);
      final liveBroadcasts = List<Broadcast?>.from(success.broadcasts);
      liveBroadcasts.removeWhere((b) => dto.id == b?.id);
      emit(_Success(liveBroadcasts));
    }
  }
}
