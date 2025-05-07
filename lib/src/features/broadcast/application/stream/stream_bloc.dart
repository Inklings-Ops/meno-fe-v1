import 'dart:async';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

part 'stream_bloc.freezed.dart';

part 'stream_event.dart';

part 'stream_state.dart';

class StreamBloc extends Bloc<StreamEvent, StreamState> {
  StreamBloc({required IBroadcastFacade facade})
      : _facade = facade,
        super(StreamState.initial()) {
    on<StreamJoinPressed>(_onStreamJoinPressed);
    on<StreamReconnectRequested>(_onStreamReconnectRequested);
    on<StreamReset>(_onStreamReset);
  }

  final IBroadcastFacade _facade;
  final _initialState = StreamState.initial();

  Future<void> _onStreamJoinPressed(
    StreamJoinPressed event,
    Emitter<StreamState> emit,
  ) async {
    emit(state.copyWith(status: const _LoadInProgress()));
    final failureOrJoin = await _facade.joinBroadcast(event.broadcastId);
    failureOrJoin.fold(
      (failure) => emit(state.copyWith(status: _StreamFailure(failure))),
      (joinBroadcast) => emit(
        state.copyWith(
          broadcast: joinBroadcast.broadcast,
          status: _StreamJoined(joinBroadcast.broadcastToken),
        ),
      ),
    );
  }

  void _onStreamReset(StreamReset event, Emitter<StreamState> emit) {
    emit(_initialState);
  }

  Future<void> _onStreamReconnectRequested(
    StreamReconnectRequested event,
    Emitter<StreamState> emit,
  ) async {
    emit(state.copyWith(status: const _LoadInProgress(), isReconnect: true));
    final option = await _facade.getSavedStreamDetails();
    emit(
      option.fold(
        () => state.copyWith(
          status: const LiveStreamStatus.failure(
            BroadcastException.message('No saved streams'),
          ),
        ),
        (joinBroadcast) => state.copyWith(
          broadcast: joinBroadcast.broadcast,
          status: _StreamJoined(joinBroadcast.broadcastToken),
        ),
      ),
    );
  }
}
