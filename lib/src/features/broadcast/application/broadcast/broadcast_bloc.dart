import 'dart:async';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

part 'broadcast_bloc.freezed.dart';

part 'broadcast_event.dart';

part 'broadcast_state.dart';

class BroadcastBloc extends Bloc<BroadcastEvent, BroadcastState> {
  BroadcastBloc({required IBroadcastFacade facade})
      : _facade = facade,
        super(BroadcastState.initial()) {
    on<InitializeBroadcast>(_onInitializeBroadcast);
    on<BroadcastStartPressed>(_onBroadcastStartPressed);
    on<BroadcastReset>(_onBroadcastReset);
    on<BroadcastReconnectRequested>(_onBroadcastReconnectRequested);
  }

  final IBroadcastFacade _facade;
  final _initialState = BroadcastState.initial();

  Future<void> _onInitializeBroadcast(
    InitializeBroadcast event,
    Emitter<BroadcastState> emit,
  ) async {
    emit(state.copyWith(status: const _LoadInProgress()));
    emit(
      state.copyWith(
        broadcast: event.broadcast,
        status: const _Initial(),
      ),
    );
  }

  Future<void> _onBroadcastStartPressed(
    BroadcastStartPressed event,
    Emitter<BroadcastState> emit,
  ) async {
    emit(state.copyWith(status: const _LoadInProgress()));
    final failureOrBroadcast = await _facade.startBroadcast(event.broadcast.id);
    failureOrBroadcast.fold(
      (failure) => emit(state.copyWith(status: _BroadcastFailure(failure))),
      (broadcast) => emit(
        state.copyWith(
          broadcast: broadcast,
          status: const _BroadcastStarted(),
        ),
      ),
    );
  }

  void _onBroadcastReset(BroadcastReset event, Emitter<BroadcastState> emit) {
    emit(_initialState);
  }

  Future<void> _onBroadcastReconnectRequested(
    BroadcastReconnectRequested event,
    Emitter<BroadcastState> emit,
  ) async {
    emit(state.copyWith(status: const _LoadInProgress(), isReconnect: true));
    final option = await _facade.getSavedBroadcastDetails();
    emit(
      option.fold(
        () => state.copyWith(
          status: const LiveBroadcastStatus.failure(
            BroadcastException.message('No saved broadcast'),
          ),
        ),
        (broadcast) => state.copyWith(
          broadcast: broadcast,
          status: const _BroadcastStarted(),
        ),
      ),
    );
  }
}
