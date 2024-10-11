import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'broadcast_bloc.freezed.dart';
part 'broadcast_event.dart';
part 'broadcast_state.dart';

@Injectable()
class BroadcastBloc extends Bloc<BroadcastEvent, BroadcastState> {
  BroadcastBloc({
    @factoryParam required Broadcast broadcast,
    required IBroadcastFacade facade,
    required LiveKitService liveKit,
    required SocketService socket,
  })  : _broadcast = broadcast,
        _facade = facade,
        _liveKit = liveKit,
        _socket = socket,
        super(BroadcastInitial(broadcast)) {
    on<BroadcastStartRequested>(_onStartBroadcast);
    on<BroadcastMuteMicrophone>(_onMuteMicrophone);
    on<BroadcastEndRequested>(_onEndBroadcast);
    on<BroadcastDeleteRequested>(_onDeleteBroadcast);
  }
  final Broadcast _broadcast;
  final IBroadcastFacade _facade;
  final LiveKitService _liveKit;
  final SocketService _socket;

  Future<void> _onStartBroadcast(
    BroadcastStartRequested event,
    Emitter<BroadcastState> emit,
  ) async {
    emit(const BroadcastLoadInProgress());
    final fOrS = await _facade.startBroadcast(_broadcast.id);
    await fOrS.fold(
      (failure) async => emit(BroadcastFailure(failure)),
      (broadcast) async {
        final broadcastToken = broadcast.broadcastToken!;
        final startEvent = SocketEvent.startedBroadcast(broadcast.id.getOr());
        final socketResponse = await _socket.emit2(startEvent);

        if (socketResponse.error != null) {
          emit(BroadcastStartFailed(socketResponse.error));
        } else {
          try {
            await _liveKit.broadcast(broadcastToken);
            emit(BroadcastStartSuccess(broadcast: broadcast, muted: false));
          } catch (e) {
            emit(BroadcastStartFailed(e.toString()));
          }
        }
      },
    );
  }

  Future<void> _onMuteMicrophone(
    BroadcastMuteMicrophone event,
    Emitter<BroadcastState> emit,
  ) async {
    if (state is BroadcastStartSuccess) {
      final broadcast = (state as BroadcastStartSuccess).broadcast;
      unawaited(_liveKit.mute(enabled: event.value));
      emit(BroadcastStartSuccess(broadcast: broadcast, muted: event.value));
    }
  }

  Future<void> _onEndBroadcast(
    BroadcastEndRequested event,
    Emitter<BroadcastState> emit,
  ) async {
    if (state is BroadcastStartSuccess) {
      emit(const BroadcastLoadInProgress());
      await _liveKit.dispose();
      _socket.emit(SocketEvent.endBroadcast(_broadcast.id.getOr()));
      emit(const BroadcastEndSuccess());
    }
  }

  Future<void> _onDeleteBroadcast(
    BroadcastDeleteRequested event,
    Emitter<BroadcastState> emit,
  ) async {
    if (state is BroadcastStartSuccess) return;
    emit(const BroadcastLoadInProgress());
    final fOrS = await _facade.deleteBroadcast(event.id);
    emit(
      fOrS.fold(
        BroadcastFailure.new,
        (success) => const BroadcastDeleteSuccess(),
      ),
    );
  }

  Future<void> dispose() async => _liveKit.dispose();

  @override
  Future<void> close() async {
    await _liveKit.dispose();
    return super.close();
  }
}
