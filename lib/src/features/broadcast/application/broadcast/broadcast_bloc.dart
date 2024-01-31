import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../dependency_injector/injector.dart';
import '../../../../services/live_kit/live_kit_service.dart';
import '../../../../services/meno/meno_bloc.dart';
import '../../../../services/socket/event_names.dart';
import '../../../../services/socket/socket_service.dart';
import '../../domain/domain.dart';
import '../live_participants/live_participants_bloc.dart';
import '../timer/timer_cubit.dart';

part 'broadcast_bloc.freezed.dart';
part 'broadcast_event.dart';
part 'broadcast_state.dart';

@lazySingleton
class BroadcastBloc extends Bloc<BroadcastEvent, BroadcastState> {
  final IBroadcastFacade _facade;
  final LiveKitService _liveKit;
  final SocketService _socket;
  final MenoBloc _menoBloc;
  final TimerCubit _timer;

  BroadcastBloc({
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
        super(BroadcastState.initial()) {
    on<_Initialize>(_onInitialize);
    on<_EndBroadcast>(_onEndBroadcast);
    on<_StartBroadcast>(_onStartBroadcast);
    on<_DeleteBroadcast>(_onDeleteBroadcast);
    on<_MuteMicrophone>(_onMuteMicrophone);

    // Listen for the 'endedBroadcast' event so we can emit the
    // EndedBroadcast Meno state
    _socket.on(sEEndedBroadcast, (_) => _emit(const MEndedBroadcast()));
  }

  @override
  Future<void> close() async {
    await _liveKit.onDispose();
    await _timer.close();
    return super.close();
  }

  void _onInitialize(event, emit) {
    emit(state.copyWith(broadcast: event.broadcast));
  }

  Future<void> _onDeleteBroadcast(event, emit) async {
    emit(state.copyWith(loading: true, onDeleted: none()));

    await _facade
        .deleteBroadcast(broadcastId: event.broadcastId)
        .then((r) => emit(state.copyWith(loading: false, onDeleted: some(r))));
  }

  void _onEndBroadcast(event, emit) async {
    emit(state.copyWith(loading: true, onEnded: none()));
    await _liveKit.disconnect().whenComplete(() {
      _socket.emitWithAck(sEEndBroadcast, {'broadcastId': state.broadcast.id});
      _timer.stop();
      _menoBloc.add(const MenoStateChanged(MOffAir()));
      emit(state.copyWith(loading: false, onEnded: some(unit)));
    });
  }

  Future<void> _onMuteMicrophone(_MuteMicrophone event, emit) async {
    await _liveKit
        .mute(event.isMuted)
        .whenComplete(() => emit(state.copyWith(isMuted: event.isMuted)));
  }

  void _emit(MenoState state) => _menoBloc.add(MenoStateChanged(state));

  Future<void> _onStartBroadcast(event, emit) async {
    final bID = state.broadcast.id;

    // Update the state with a loading state
    emit(state.copyWith(loading: true, onStarted: none()));

    // Call the endpoint to get the broadcast token for the LiveKit engine
    await _facade.startBroadcast(broadcastId: bID).then((res) async {
      await res.fold(
        (_) => emit(state.copyWith(loading: false, onStarted: some(res))),
        (success) async {
          final broadcastToken = success.broadcastToken;

          // Connect to the LiveKit Client engine to start streaming
          await _liveKit.broadcast(broadcastToken!).whenComplete(() {
            // Start the broadcast via socket
            _socket.emitWithAck(sEStartedBroadcast, {'broadcastId': bID});

            // Start the broadcast timer
            _timer.start();

            // Change the MenoState to the live state
            _menoBloc.add(MenoStateChanged(MLive(success)));

            // Add listener for LiveKit
            _liveKit.listener
              ..on<RoomConnectedEvent>((_) => _emit(MLive(success)))
              ..on<RoomReconnectedEvent>((_) => _emit(MLive(success)))
              ..on<RoomDisconnectedEvent>((_) => _emit(const MOffAir()))
              ..on<RoomReconnectingEvent>((_) => _emit(MReconnecting(success)));

            // Update Broadcast state
            emit(state.copyWith(
              loading: false,
              broadcast: success,
              onStarted: some(res),
            ));

            di<LiveParticipantsBloc>().add(FetchParticipants(bID));
          });
        },
      );
    });
  }
}
