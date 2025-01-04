import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

part 'live_broadcasts_bloc.freezed.dart';

part 'live_broadcasts_event.dart';

part 'live_broadcasts_state.dart';

const _size = 8;

class LiveBroadcastsBloc
    extends Bloc<LiveBroadcastsEvent, LiveBroadcastsState> {
  LiveBroadcastsBloc({required IBroadcastFacade facade})
      : _facade = facade,
        super(const LoadingLiveBroadcasts()) {
    on<GetLiveBroadcasts>(_onGetLiveBroadcasts);
    on<GetMoreLiveBroadcasts>(_onGetMoreLiveBroadcasts);
    on<NewBroadcastReceived>(_onNewBroadcast);
    on<EndedBroadcastReceived>(_onEndedBroadcast);
  }

  final IBroadcastFacade _facade;

  void init() => add(const GetLiveBroadcasts());

  Future<void> _onGetLiveBroadcasts(
    GetLiveBroadcasts event,
    Emitter<LiveBroadcastsState> emit,
  ) async {
    emit(const LoadingLiveBroadcasts());
    final fOrB = await _facade.getBroadcasts(
      endTimeExist: false,
      startTimeExist: true,
      include: 'totalListeners',
      status: 'active',
      size: _size,
      page: 1,
    );
    emit(
      fOrB.fold(
        (l) => const LiveBroadcastFailure(),
        (b) => b.broadcasts.isEmpty
            ? const LiveBroadcastsEmpty()
            : LiveBroadcastsLoaded(b.broadcasts),
      ),
    );
  }

  Future<void> _onGetMoreLiveBroadcasts(
    GetMoreLiveBroadcasts event,
    Emitter<LiveBroadcastsState> emit,
  ) async {
    if (state is LiveBroadcastsLoaded) {
      final loadedState = state as LiveBroadcastsLoaded;
      final broadcasts = loadedState.broadcasts;

      emit(LoadingMoreLiveBroadcasts(broadcasts));

      final result = await _facade.getBroadcasts(
        endTimeExist: false,
        startTimeExist: true,
        include: 'totalListeners',
        status: 'active',
        size: _size,
        page: broadcasts.length ~/ _size + 1,
      );

      return result.fold(
        (failure) => emit(state),
        (success) => success.broadcasts.isEmpty
            ? emit(LiveBroadcastsLoadedLast(broadcasts))
            : emit(
                LiveBroadcastsLoaded([
                  ...broadcasts,
                  ...success.broadcasts,
                ]),
              ),
      );
    }
  }

  Future<void> _onNewBroadcast(
    NewBroadcastReceived event,
    Emitter<LiveBroadcastsState> emit,
  ) async {
    if (state is LiveBroadcastsEmpty) {
      final broadcasts = List<Broadcast?>.from([]);
      final updatedBroadcasts = [event.broadcast, ...broadcasts];
      emit(LiveBroadcastsLoaded(updatedBroadcasts));
    } else if (state is LiveBroadcastsLoaded) {
      final success = state as LiveBroadcastsLoaded;
      final broadcasts = List<Broadcast?>.from(success.broadcasts);
      final updatedBroadcasts = [event.broadcast, ...broadcasts];
      emit(LiveBroadcastsLoaded(updatedBroadcasts));
    }
  }

  Future<void> _onEndedBroadcast(
    EndedBroadcastReceived event,
    Emitter<LiveBroadcastsState> emit,
  ) async {
    if (state is LiveBroadcastsLoaded) {
      final success = state as LiveBroadcastsLoaded;
      final broadcasts = List<Broadcast?>.from(success.broadcasts)
        ..removeWhere((b) => event.data.broadcastDetails.id == b?.id);
      broadcasts.isEmpty
          ? emit(const LiveBroadcastsEmpty())
          : emit(LiveBroadcastsLoaded(broadcasts));
    }
  }
}
