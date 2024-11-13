import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

part 'live_broadcasts_bloc.freezed.dart';

part 'live_broadcasts_event.dart';

part 'live_broadcasts_state.dart';

class LiveBroadcastsBloc
    extends Bloc<LiveBroadcastsEvent, LiveBroadcastsState> {
  LiveBroadcastsBloc({required IBroadcastFacade facade})
      : _facade = facade,
        super(const _Loading()) {
    on<_GetLiveBroadcasts>(_onGetLiveBroadcasts);
    on<NewBroadcastReceived>(_onNewBroadcast);
    on<EndedBroadcastReceived>(_onEndedBroadcast);
  }

  final IBroadcastFacade _facade;

  void init() => add(const _GetLiveBroadcasts());

  Future<void> _onGetLiveBroadcasts(
    _GetLiveBroadcasts event,
    Emitter<LiveBroadcastsState> emit,
  ) async {
    emit(const _Loading());
    final fOrB = await _facade.getBroadcasts(
      endTimeExist: false,
      startTimeExist: true,
      include: 'totalListeners',
      status: 'active',
      size: 8,
      page: 1,
    );
    emit(
      fOrB.fold(
        (l) => const _Failure(),
        (b) => b.broadcasts.isEmpty ? const _Empty() : _Success(b.broadcasts),
      ),
    );
  }

  Future<void> _onNewBroadcast(
    NewBroadcastReceived event,
    Emitter<LiveBroadcastsState> emit,
  ) async {
    if (state is _Empty) {
      final broadcasts = List<Broadcast?>.from([]);
      final updatedBroadcasts = [event.broadcast, ...broadcasts];
      emit(_Success(updatedBroadcasts));
    } else if (state is _Success) {
      final success = state as _Success;
      final broadcasts = List<Broadcast?>.from(success.broadcasts);
      final updatedBroadcasts = [event.broadcast, ...broadcasts];
      emit(_Success(updatedBroadcasts));
    }
  }

  Future<void> _onEndedBroadcast(
    EndedBroadcastReceived event,
    Emitter<LiveBroadcastsState> emit,
  ) async {
    if (state is _Success) {
      final success = state as _Success;
      final broadcasts = List<Broadcast?>.from(success.broadcasts)
        ..removeWhere((b) => event.data.broadcastDetails.id == b?.id);
      broadcasts.isEmpty ? emit(const _Empty()) : emit(_Success(broadcasts));
    }
  }
}
