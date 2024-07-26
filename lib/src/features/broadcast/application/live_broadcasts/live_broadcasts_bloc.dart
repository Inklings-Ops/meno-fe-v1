import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart';

part 'live_broadcasts_bloc.freezed.dart';
part 'live_broadcasts_event.dart';
part 'live_broadcasts_state.dart';

@lazySingleton
class LiveBroadcastsBloc
    extends Bloc<LiveBroadcastsEvent, LiveBroadcastsState> {
  final IBroadcastFacade _facade;
  final SocketService _socket;
  late final StreamSubscription<SocketState> _socketStateSub;
  late final StreamSubscription<SocketEvent> _socketEventSub;
  LiveBroadcastsBloc({
    required IBroadcastFacade facade,
    required SocketService socket,
  })  : _facade = facade,
        _socket = socket,
        super(const _Loading()) {
    on<_GetLiveBroadcasts>(_onGetLiveBroadcasts);
    on<_UpdateBroadcastList>(_onUpdateBroadcastList);
    on<_NewBroadcast>(_onNewBroadcast);
    on<_EndedBroadcast>(_onEndedBroadcast);

    _socketStateSub = _socket.stateStream.listen((socketState) {
      socketState.whenOrNull(
        liveBroadcasts: (data, error) => add(_UpdateBroadcastList(data)),
      );
    });
    _socketEventSub = _socket.eventsStream.listen((socketEvent) {
      socketEvent.whenOrNull(
        newBroadcast: (broadcast) => add(_NewBroadcast(broadcast)),
        endedBroadcast: (broadcast) => add(_EndedBroadcast(broadcast)),
      );
    });
  }

  void init() => add(const _GetLiveBroadcasts());

  Future<void> _onGetLiveBroadcasts(_GetLiveBroadcasts event, emit) async {
    emit(const _Loading());
    final fOrB = await _facade.getBroadcasts(
      endTimeExist: false,
      startTimeExist: true,
      include: 'totalListeners',
      size: 8,
      page: 1,
    );
    emit(fOrB.fold((l) => const _Failure(), (b) => _Success(b.broadcasts)));
  }

  _onUpdateBroadcastList(_UpdateBroadcastList event, emit) async {
    final broadcasts = event.broadcasts;
    broadcasts.isEmpty ? emit(const _Empty()) : emit(_Success(broadcasts));
  }

  _onNewBroadcast(_NewBroadcast event, emit) async {
    if (state is _Empty) {
      final broadcasts = List<Broadcast?>.from([]);
      final updatedBroadcasts = [event.broadcast, ...broadcasts];
      emit(_Success(updatedBroadcasts));
    } else if (state is _Success) {
      final success = (state as _Success);
      final broadcasts = List<Broadcast?>.from(success.broadcasts);
      final updatedBroadcasts = [event.broadcast, ...broadcasts];
      emit(_Success(updatedBroadcasts));
    }
  }

  _onEndedBroadcast(_EndedBroadcast event, emit) async {
    if (state is _Success) {
      final success = (state as _Success);
      final broadcasts = List<Broadcast?>.from(success.broadcasts);
      broadcasts.removeWhere((b) => event.broadcast.id == b?.id);
      broadcasts.isEmpty ? emit(const _Empty()) : emit(_Success(broadcasts));
    }
  }

  @override
  Future<void> close() async {
    await _socketStateSub.cancel();
    await _socketEventSub.cancel();
    super.close();
  }
}
