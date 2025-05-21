import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/shared/shared.dart' show SingleLineString, Uid;

part 'broadcast_event.dart';
part 'broadcast_state.dart';

class BroadcastBloc extends Bloc<BroadcastEvent, BroadcastState> {
  BroadcastBloc({
    required StartBroadcastUsecase startBroadcastUsecase,
    required EndBroadcastUsecase endBroadcastUsecase,
    required JoinBroadcastUsecase joinBroadcastUsecase,
    required LeaveBroadcastUsecase leaveBroadcastUsecase,
    required ReconnectBroadcastUsecase reconnectBroadcastUsecase,
  })  : _startBroadcastUsecase = startBroadcastUsecase,
        _endBroadcastUsecase = endBroadcastUsecase,
        _joinBroadcastUsecase = joinBroadcastUsecase,
        _leaveBroadcastUsecase = leaveBroadcastUsecase,
        _reconnectBroadcastUsecase = reconnectBroadcastUsecase,
        super(BroadcastState()) {
    on<BroadcastStartRequested>(_onBroadcastStartRequested);
    on<BroadcastResetRequested>(_onBroadcastResetRequested);
    on<BroadcastReconnectRequested>(_onBroadcastReconnectRequested);
  }

  final StartBroadcastUsecase _startBroadcastUsecase;
  final EndBroadcastUsecase _endBroadcastUsecase;
  final JoinBroadcastUsecase _joinBroadcastUsecase;
  final LeaveBroadcastUsecase _leaveBroadcastUsecase;
  final ReconnectBroadcastUsecase _reconnectBroadcastUsecase;

  Future<void> _onBroadcastStartRequested(
    BroadcastStartRequested event,
    Emitter<BroadcastState> emit,
  ) async {
    emit(state.copyWith(status: LiveBroadcastStatus.loading));

    final params = StartBroadcastParams(
      title: event.title,
      description: event.description,
      artwork: event.artwork,
      cohosts: event.cohosts,
      timeZone: event.timeZone,
    );

    final failureOrBroadcast = await _startBroadcastUsecase(params);

    failureOrBroadcast.fold(
      (exception) => emit(
        state.copyWith(
          status: LiveBroadcastStatus.failure,
          exception: exception,
        ),
      ),
      (broadcast) => emit(
        state.copyWith(
          status: LiveBroadcastStatus.started,
          broadcast: broadcast,
        ),
      ),
    );
  }

  Future<void> _onBroadcastEndRequested(
    BroadcastEndRequested event,
    Emitter<BroadcastState> emit,
  ) async {
    emit(state.copyWith(status: LiveBroadcastStatus.loading));

    final failureOrEnd = await _endBroadcastUsecase(event.broadcastId);

    failureOrEnd.fold(
      (exception) => emit(
        state.copyWith(
          status: LiveBroadcastStatus.failure,
          exception: exception,
        ),
      ),
      (_) => emit(state.copyWith(status: LiveBroadcastStatus.failure)),
    );
  }

  Future<void> _onBroadcastJoinRequested(
    BroadcastJoinRequested event,
    Emitter<BroadcastState> emit,
  ) async {
    emit(state.copyWith(status: LiveBroadcastStatus.loading));

    final failureOrBroadcast = await _joinBroadcastUsecase(event.broadcastId);

    failureOrBroadcast.fold(
      (exception) => emit(
        state.copyWith(
          status: LiveBroadcastStatus.failure,
          exception: exception,
        ),
      ),
      (broadcast) => emit(
        state.copyWith(
          status: LiveBroadcastStatus.joined,
          broadcast: broadcast,
          isStream: true,
        ),
      ),
    );
  }

  Future<void> _onBroadcastLeaveRequested(
    BroadcastLeaveRequested event,
    Emitter<BroadcastState> emit,
  ) async {
    emit(state.copyWith(status: LiveBroadcastStatus.loading));

    final failureOrLeave = await _leaveBroadcastUsecase(event.broadcastId);

    failureOrLeave.fold(
      (exception) => emit(
        state.copyWith(
          status: LiveBroadcastStatus.failure,
          exception: exception,
        ),
      ),
      (_) => emit(BroadcastState()),
    );
  }

  void _onBroadcastResetRequested(
    BroadcastResetRequested event,
    Emitter<BroadcastState> emit,
  ) {
    emit(BroadcastState());
  }

  Future<void> _onBroadcastReconnectRequested(
    BroadcastReconnectRequested event,
    Emitter<BroadcastState> emit,
  ) async {
    final isStream = event.isStream;
    emit(state.copyWith(status: LiveBroadcastStatus.loading));
    final connectOrFailure = await _reconnectBroadcastUsecase(isStream);
    emit(
      connectOrFailure.fold(
        (failure) => state.copyWith(
          status: LiveBroadcastStatus.failure,
          exception: failure,
        ),
        (broadcast) => state.copyWith(
          broadcast: broadcast,
          isReconnect: true,
          isStream: isStream,
          status: isStream
              ? LiveBroadcastStatus.joined
              : LiveBroadcastStatus.started,
        ),
      ),
    );
  }
}
