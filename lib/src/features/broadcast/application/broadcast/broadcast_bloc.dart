import 'dart:async';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

part 'broadcast_bloc.freezed.dart';
part 'broadcast_event.dart';
part 'broadcast_state.dart';

class BroadcastBloc extends Bloc<BroadcastEvent, BroadcastState> {
  BroadcastBloc({
    required IBroadcastFacade facade,
    required LiveKitService liveKit,
    required SocketService socket,
  })  : _facade = facade,
        _liveKit = liveKit,
        _socket = socket,
        super(BroadcastState.initial()) {
    on<BroadcastInitialized>(_onBroadcastInitialized);
    on<BroadcastStartPressed>(_onBroadcastStartPressed);
    on<BroadcastEndPressed>(_onBroadcastEndPressed);
    on<BroadcastMuteToggled>(_onBroadcastMuteToggled);
    on<BroadcastReset>(_onBroadcastReset);
    on<_SocketDataReceived>(_onSocketDataReceived);
  }
  final IBroadcastFacade _facade;
  final LiveKitService _liveKit;
  final SocketService _socket;

  StreamSubscription<SocketState>? _socketStateSubscription;

  /// Tracks the initialization state of the Streams
  bool _listenersInitialized = false;

  void _onBroadcastInitialized(
    BroadcastInitialized event,
    Emitter<BroadcastState> emit,
  ) {
    if (_listenersInitialized) return;
    emit(state.copyWith(broadcast: event.broadcast));
    _socketStateSubscription = _socket.stateStream.listen((socketState) {
      socketState.whenOrNull(
        broadcastStarted: (data, error) => add(
          _SocketDataReceived(data: data, error: error),
        ),
      );
    });

    _listenersInitialized = true;
  }

  Future<void> _onBroadcastStartPressed(
    BroadcastStartPressed event,
    Emitter<BroadcastState> emit,
  ) async {
    final broadcastId = state.broadcast.id;
    emit(state.copyWith(status: const LiveLoadInProgress()));
    final failureOrBroadcast = await _facade.startBroadcast(broadcastId);
    await failureOrBroadcast.fold(
      (failure) async => emit(state.copyWith(status: LiveFailure(failure))),
      (broadcast) async {
        try {
          // Attempt to connect to LiveKit using the token
          await _liveKit.broadcast(broadcast.broadcastToken!);

          // Emit socket event to indicate joining the broadcast room
          _socket.emit(SocketStartedBroadcast(broadcast.id.getOr()));

          // Check for any error from the web socket service
          if (state.status is! LiveFailure) {
            // Update state to reflect successful joining of the broadcast
            emit(
              state.copyWith(
                status: const LiveBroadcastStarted(),
                broadcast: broadcast,
              ),
            );
          }
        } catch (e) {
          // Emit a failure status if connection fails
          final exception = BroadcastException.message(e.toString());
          emit(state.copyWith(status: LiveFailure(exception)));
        }
      },
    );
  }

  void _onBroadcastEndPressed(
    BroadcastEndPressed event,
    Emitter<BroadcastState> emit,
  ) {
    if (state.status is! LiveBroadcastStarted) return;

    // Emit the loading state
    emit(state.copyWith(status: const LiveLoadInProgress()));

    // Emit the `endBroadcast` socket event to leave the broadcast
    _socket.emit(SocketEndBroadcast(event.broadcastId.getOr()));

    // Emit the BroadcastEnded state
    emit(state.copyWith(status: const LiveBroadcastEnded()));
  }

  void _onBroadcastMuteToggled(
    BroadcastMuteToggled event,
    Emitter<BroadcastState> emit,
  ) {
    if (state.status is! LiveBroadcastStarted) return;
    final enabled = (state.status as LiveBroadcastStarted).microphoneEnabled;
    unawaited(_liveKit.mute(enabled: !enabled));
    emit(
      state.copyWith(
        status: LiveBroadcastStarted(
          microphoneEnabled: !enabled,
        ),
      ),
    );
  }

  Future<void> _onBroadcastReset(
    BroadcastReset event,
    Emitter<BroadcastState> emit,
  ) async {
    await _socketStateSubscription?.cancel();
    _socketStateSubscription = null;
    _listenersInitialized = false;
  }

  void _onSocketDataReceived(
    _SocketDataReceived event,
    Emitter<BroadcastState> emit,
  ) {
    if (event.error == null) return;

    // Disconnect Live Kit
    unawaited(_liveKit.disconnect());

    // Emit the failure state with the error message from the socket
    final exception = BroadcastException.message(event.error!);
    emit(state.copyWith(status: LiveFailure(exception)));
  }

  @override
  Future<void> close() async {
    await _socketStateSubscription?.cancel();
    return super.close();
  }
}
