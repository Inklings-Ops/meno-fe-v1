import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'broadcast_event.dart';
part 'broadcast_state.dart';

class BroadcastBloc extends Bloc<BroadcastEvent, BroadcastState> {
  BroadcastBloc({
    required StartBroadcastUsecase startBroadcastUsecase,
    required EndBroadcastUsecase endBroadcastUsecase,
    required JoinBroadcastUsecase joinBroadcastUsecase,
    required LeaveBroadcastUsecase leaveBroadcastUsecase,
    required ReconnectBroadcastUsecase reconnectBroadcastUsecase,
    // required SocketService socket,
    required LiveKitService liveKit,
  })  : _startBroadcastUsecase = startBroadcastUsecase,
        _endBroadcastUsecase = endBroadcastUsecase,
        _joinBroadcastUsecase = joinBroadcastUsecase,
        _leaveBroadcastUsecase = leaveBroadcastUsecase,
        _reconnectBroadcastUsecase = reconnectBroadcastUsecase,
        // _socket = socket,
        _liveKit = liveKit,
        super(BroadcastState()) {
    on<BroadcastStartRequested>(_onBroadcastStartRequested);
    on<BroadcastJoinRequested>(_onBroadcastJoinRequested);
    on<BroadcastEndRequested>(_onBroadcastEndRequested);
    on<BroadcastLeaveRequested>(_onBroadcastLeaveRequested);
    on<BroadcastResetRequested>(_onBroadcastResetRequested);
    on<BroadcastReconnectRequested>(_onBroadcastReconnectRequested);
    on<BroadcastMuteMicRequested>(_onBroadcastMuteMicRequested);
    on<BroadcastUnMuteMicRequested>(_onBroadcastUnMuteMicRequested);

    // _socket.addListener('hostReconnected', (data) {
    //   Logger().w('FROM BROADCAST_BLOC HOST DISCONNECTED => $data');
    //   add(const BroadcastReconnectRequested());
    // });
  }

  final StartBroadcastUsecase _startBroadcastUsecase;
  final EndBroadcastUsecase _endBroadcastUsecase;
  final JoinBroadcastUsecase _joinBroadcastUsecase;
  final LeaveBroadcastUsecase _leaveBroadcastUsecase;
  final ReconnectBroadcastUsecase _reconnectBroadcastUsecase;
  // final SocketService _socket;
  final LiveKitService _liveKit;

  StreamSubscription<RoomEvent>? _subscription;

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
      (broadcast) {
        var status = LiveBroadcastStatus.started;

        _subscription = _liveKit.eventsStream.listen((liveEvent) {
          switch (liveEvent) {
            case RoomConnectedEvent():
            case RoomReconnectedEvent():
              status = LiveBroadcastStatus.started;
              return;
            case RoomDisconnectedEvent():
              status = LiveBroadcastStatus.offAir;
              return;
            case RoomReconnectingEvent():
            case RoomAttemptReconnectEvent():
              status = LiveBroadcastStatus.reconnecting;
              return;
            default:
          }
        });

        emit(
          state.copyWith(
            status: status,
            broadcast: broadcast,
            isMicrophoneEnabled: true,
          ),
        );
      },
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
      (_) => emit(state.copyWith(status: LiveBroadcastStatus.ended)),
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
      (broadcast) {
        var status = LiveBroadcastStatus.joined;

        _subscription = _liveKit.eventsStream.listen((liveEvent) {
          switch (liveEvent) {
            case RoomConnectedEvent():
            case RoomReconnectedEvent():
              status = LiveBroadcastStatus.joined;
              return;
            case RoomDisconnectedEvent():
              status = LiveBroadcastStatus.offAir;
              return;
            case RoomReconnectingEvent():
            case RoomAttemptReconnectEvent():
              status = LiveBroadcastStatus.reconnecting;
              return;
            default:
          }
        });

        emit(
          state.copyWith(
            status: status,
            broadcast: broadcast,
            isStream: true,
          ),
        );
      },
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
      (_) => emit(state.copyWith(status: LiveBroadcastStatus.left)),
    );
  }

  Future<void> _onBroadcastResetRequested(
    BroadcastResetRequested event,
    Emitter<BroadcastState> emit,
  ) async {
    await _subscription?.cancel();
    _subscription = null;
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
          isMicrophoneEnabled: !isStream,
          isReconnect: true,
          isStream: isStream,
          status: isStream
              ? LiveBroadcastStatus.joined
              : LiveBroadcastStatus.started,
        ),
      ),
    );
  }

  Future<void> _onBroadcastMuteMicRequested(
    BroadcastMuteMicRequested event,
    Emitter<BroadcastState> emit,
  ) async {
    unawaited(_liveKit.enableMicrophone(false));
    emit(state.copyWith(isMicrophoneEnabled: false));
  }

  Future<void> _onBroadcastUnMuteMicRequested(
    BroadcastUnMuteMicRequested event,
    Emitter<BroadcastState> emit,
  ) async {
    unawaited(_liveKit.enableMicrophone());
    emit(state.copyWith(isMicrophoneEnabled: true));
  }
}
