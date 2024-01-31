import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../services/live_kit/live_kit_service.dart';
import '../../../../services/meno/meno_bloc.dart';
import '../../../../services/socket/event_names.dart';
import '../../../../services/socket/socket_service.dart';
import '../../domain/domain.dart';
import '../timer/timer_cubit.dart';

part 'stream_bloc.freezed.dart';
part 'stream_event.dart';
part 'stream_state.dart';

@lazySingleton
class StreamBloc extends Bloc<StreamEvent, StreamState> {
  final IBroadcastFacade _facade;
  final LiveKitService _liveKit;
  final SocketService _socket;
  final MenoBloc _menoBloc;
  final TimerCubit _timer;

  StreamBloc({
    required IBroadcastFacade facade,
    required LiveKitService liveKit,
    required SocketService socket,
    required MenoBloc menoBloc,
    required TimerCubit timer,
  })  : _facade = facade,
        _liveKit = liveKit,
        _socket = socket,
        _menoBloc = menoBloc,
        _timer = timer,
        super(StreamState.initial()) {
    on<_JoinBroadcast>(_onJoinBroadcast);
    on<_LeaveBroadcast>(_onLeaveBroadcast);

    // Listen for the 'endedBroadcast' event so we can emit the
    // EndedBroadcast Meno state
    _socket.on(sEEndedBroadcast, (_) => _emit(const MEndedBroadcast()));
  }

  @override
  Future<void> close() async {
    await _timer.close();
    await _liveKit.onDispose();
    super.close();
  }

  void _emit(MenoState state) => _menoBloc.add(MenoStateChanged(state));

  Future<void> _onJoinBroadcast(event, emit) async {
    final bID = event.broadcastId;

    // Update the state with a loading state
    emit(state.copyWith(loading: true, onJoined: none()));

    // Call the endpoint to get the broadcast token for the LiveKit engine
    await _facade.joinBroadcast(broadcastId: bID).then((res) async {
      await res.fold(
        (_) => emit(state.copyWith(loading: false, onJoined: some(res))),
        (success) async {
          final broadcast = success.broadcast;
          final broadcastToken = success.broadcastToken;

          // Connect to the LiveKit Client engine to start streaming
          await _liveKit.stream(broadcastToken).whenComplete(() {
            // Join broadcast via socket
            _socket.emitWithAck(sEJoinBroadcast, {'broadcastId': bID});

            // Set the timer to the difference between the start time and
            // current time
            _setAndStartTimer(broadcast.startTime);

            // Change the MenoState to the live state
            _menoBloc.add(MenoStateChanged(MStreaming(broadcast)));

            // Add listener for LiveKit
            _liveKit.listener
              ..on<RoomConnectedEvent>((_) => _emit(MStreaming(broadcast)))
              ..on<RoomReconnectedEvent>((_) => _emit(MStreaming(broadcast)))
              ..on<RoomDisconnectedEvent>((_) => _emit(const MOffAir()))
              ..on<RoomReconnectingEvent>(
                (_) => _emit(MReconnecting(broadcast)),
              );


            // Update Broadcast state
            emit(state.copyWith(
              loading: false,
              joinBroadcast: success,
              onJoined: some(res),
            ));
          });
        },
      );
    });
  }

  void _onLeaveBroadcast(event, emit) async {
    emit(state.copyWith(loading: true, onLeave: none()));
    final broadcastId = state.joinBroadcast.broadcast.id;
    await _liveKit.disconnect().whenComplete(() {
      _socket.emitWithAck(sELeaveBroadcast, {'broadcastId': broadcastId});
      _timer.reset();
      _menoBloc.add(const MenoStateChanged(MOffAir()));
      emit(state.copyWith(loading: false, onLeave: some(unit)));
    });
  }

  void _setAndStartTimer([DateTime? startTime]) => _timer
    ..set(startTime)
    ..start();
}
