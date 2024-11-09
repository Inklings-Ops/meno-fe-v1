import 'dart:async';
import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'broadcast_bloc.freezed.dart';

part 'broadcast_event.dart';

part 'broadcast_state.dart';

const _liveBroadcastKey = 'liveBroadcast';

class BroadcastBloc extends Bloc<BroadcastEvent, BroadcastState> {
  BroadcastBloc({
    required IBroadcastFacade facade,
    required LiveKitService liveKit,
    required SocketService socket,
    required SharedPreferences preferences,
  })  : _facade = facade,
        _liveKit = liveKit,
        _socket = socket,
        _preferences = preferences,
        super(BroadcastState.initial()) {
    on<BroadcastInitialized>(_onBroadcastInitialized);
    on<BroadcastStartPressed>(_onBroadcastStartPressed);
    on<_BroadcastStartReceived>(_onStarted);
    on<BroadcastEndPressed>(_onBroadcastEndPressed);
    on<BroadcastMuteToggled>(_onBroadcastMuteToggled);
    on<BroadcastReset>(_onBroadcastReset);
    on<_SocketDataReceived>(_onSocketDataReceived);
    on<BroadcastReconnectRequested>(_onBroadcastReconnectRequested);
    on<_SocketBroadcastRetrieved>(_onSocketBroadcastRetrieved);
  }

  final IBroadcastFacade _facade;
  final LiveKitService _liveKit;
  final SocketService _socket;
  final SharedPreferences _preferences;

  StreamSubscription<SocketState>? _socketStateSubscription;

  /// Tracks the initialization state of the Streams
  bool _listenersInitialized = false;

  Future<void> checkForLiveBroadcasts() async {
    Logger().w('Checking... => ${_preferences.containsKey(_liveBroadcastKey)}');
    if (_preferences.containsKey(_liveBroadcastKey)) {
      final jsonString = _preferences.getString(_liveBroadcastKey);
      final source = jsonDecode(jsonString!) as Map<String, dynamic>;
      final storedBroadcast = BroadcastDto.fromJson(source).toDomain;
      _socket.stateStream.listen(
        (socketState) => socketState.whenOrNull(
          liveBroadcastRetrieved: (broadcast) => add(
            _SocketBroadcastRetrieved(
              broadcast: broadcast,
              storedBroadcast: storedBroadcast,
            ),
          ),
        ),
      );
      _socket.emit(SocketEvent.getLiveBroadcast(storedBroadcast.id.getOr()));
    }
  }

  void _onBroadcastInitialized(
    BroadcastInitialized event,
    Emitter<BroadcastState> emit,
  ) {
    if (_listenersInitialized) return;
    emit(state.copyWith(broadcast: event.broadcast));
    _socketStateSubscription = _socket.stateStream.listen((socketState) {
      socketState.whenOrNull(
        error: (error) => add(_SocketDataReceived(error: error)),
        broadcastStarted: (data, error) {
          add(_BroadcastStartReceived(data: data, error: error));
        },
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
        emit(state.copyWith(broadcast: broadcast));
        try {
          await _liveKit.broadcast(broadcast.broadcastToken!);
          _socket.emit(SocketStartedBroadcast(broadcast.id.getOr()));
        } catch (e) {
          emit(state.copyWith(status: LiveFailure(e.toException)));
        }
      },
    );
  }

  Future<void> _onStarted(
    _BroadcastStartReceived event,
    Emitter<BroadcastState> emit,
  ) async {
    if (event.error == null) {
      emit(state.copyWith(status: const LiveBroadcastStarted()));
      final jsonString = jsonEncode(state.broadcast.toDto.toJson());
      await _preferences.setString(_liveBroadcastKey, jsonString);
    } else {
      emit(state.copyWith(status: LiveFailure(event.error!.toException)));
    }
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
    await _preferences.remove(_liveBroadcastKey);
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
    final exception = event.error!.toException;
    emit(state.copyWith(status: LiveFailure(exception)));
  }

  Future<void> _onBroadcastReconnectRequested(
    BroadcastReconnectRequested event,
    Emitter<BroadcastState> emit,
  ) async {
    emit(state.copyWith(status: const LiveLoadInProgress()));
    try {
      await _liveKit.broadcast(event.broadcast.broadcastToken!);
      emit(
        state.copyWith(
          status: const LiveBroadcastStarted(reconnected: true),
          hostDisconnected: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: LiveFailure(e.toException)));
    }
  }

  void _onSocketBroadcastRetrieved(
    _SocketBroadcastRetrieved event,
    Emitter<BroadcastState> emit,
  ) {
    if (event.storedBroadcast.id == event.broadcast.id) {
      final startTime = event.broadcast.startTime;
      emit(
        state.copyWith(
          broadcast: event.storedBroadcast.copyWith(startTime: startTime),
          hostDisconnected: true,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _socketStateSubscription?.cancel();
    return super.close();
  }
}
