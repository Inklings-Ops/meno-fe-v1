import 'dart:async';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

part 'stream_bloc.freezed.dart';
part 'stream_event.dart';
part 'stream_state.dart';

class StreamBloc extends Bloc<StreamEvent, StreamState> {
  StreamBloc({
    required IBroadcastFacade facade,
    required LiveKitService liveKit,
    required SocketService socket,
  })  : _facade = facade,
        _liveKit = liveKit,
        _socket = socket,
        super(StreamState.initial()) {
    on<StreamJoinPressed>(_onStreamJoinPressed);
    on<StreamLeavePressed>(_onStreamLeavePressed);
    on<StreamEnded>(_onStreamEnded);
    on<StreamReset>(_onStreamReset);
    on<_SocketDataReceived>(_onSocketDataReceived);

    _initializeSocketListeners();
  }

  final IBroadcastFacade _facade;
  final LiveKitService _liveKit;
  final SocketService _socket;

  StreamSubscription<SocketState>? _socketStateSubscription;
  StreamSubscription<SocketEvent>? _socketEventSubscription;

  /// Tracks the initialization state of the Streams
  bool _listenersInitialized = false;

  void _initializeSocketListeners() {
    if (_listenersInitialized) return;

    _socketStateSubscription = _socket.stateStream.listen((socketState) {
      socketState.whenOrNull(
        error: (error) => add(_SocketDataReceived(error: error)),
      );
    });

    _socketEventSubscription = _socket.eventsStream.listen((socketEvent) {
      socketEvent.whenOrNull(
        endedBroadcast: (data) => add(StreamEnded(data)),
      );
    });

    _listenersInitialized = true;
  }

  Future<void> _onStreamJoinPressed(
    StreamJoinPressed event,
    Emitter<StreamState> emit,
  ) async {
    _initializeSocketListeners();
    emit(state.copyWith(status: const LiveLoadInProgress()));
    final failureOrJoinBroadcast = await _facade.joinBroadcast(event.id);
    await failureOrJoinBroadcast.fold(
      (failure) async => emit(state.copyWith(status: LiveFailure(failure))),
      (joinBroadcast) async {
        emit(state.copyWith(broadcast: joinBroadcast.broadcast));

        try {
          final token = joinBroadcast.broadcastToken;
          await _liveKit.stream(token).whenComplete(() async {
            final response = await _socket.emitFuture(
              SocketJoinBroadcast(event.id.getOr()),
            );
            if (response.error != null) {
              final exception = response.error!.toBroadcastException;
              emit(state.copyWith(status: LiveFailure(exception)));
            } else {
              emit(state.copyWith(status: const LiveBroadcastJoined()));
            }
          });
        } catch (e) {
          emit(state.copyWith(status: LiveFailure(e.toBroadcastException)));
        }
      },
    );
  }

  void _onStreamLeavePressed(
    StreamLeavePressed event,
    Emitter<StreamState> emit,
  ) {
    if (state.status is! LiveBroadcastJoined) return;

    // Emit the loading state
    emit(state.copyWith(status: const LiveLoadInProgress()));

    // Emit the `leaveBroadcast` socket event to leave the broadcast
    _socket.emit(SocketLeaveBroadcast(event.id.getOr()));

    // Emit the LiveBroadcastLeft state
    emit(state.copyWith(status: const LiveBroadcastLeft()));
  }

  /// To be emitted when a live broadcast by another user is ended either
  /// normally or abnormally
  void _onStreamEnded(StreamEnded event, Emitter<StreamState> emit) {
    emit(state.copyWith(status: LiveStreamEnded(event.data)));
  }

  Future<void> _cancelSubscriptions() async {
    await _socketStateSubscription?.cancel();
    await _socketEventSubscription?.cancel();
    _socketStateSubscription = null;
    _socketEventSubscription = null;
    _listenersInitialized = false;
  }

  Future<void> _onStreamReset(
    StreamReset event,
    Emitter<StreamState> emit,
  ) async {
    await _cancelSubscriptions();
    emit(StreamState.initial());
  }

  /// Will be called to check for any error on the Web Socket Service after an
  /// event has been emitted
  void _onSocketDataReceived(
    _SocketDataReceived event,
    Emitter<StreamState> emit,
  ) {
    if (event.error == null) return;
    // Disconnect Live Kit
    unawaited(_liveKit.disconnect());

    // Emit the failure state with the error message from the socket
    final exception = event.error!.toBroadcastException;
    emit(state.copyWith(status: LiveFailure(exception)));
  }

  @override
  Future<void> close() async {
    await _cancelSubscriptions();
    await super.close();
  }
}
