import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

part 'broadcast_bloc.freezed.dart';
part 'broadcast_state.dart';

@Injectable()
class BroadcastBloc extends Cubit<BroadcastState> {
  BroadcastBloc({
    @factoryParam required Broadcast broadcast,
    required IBroadcastFacade facade,
    required LiveKitService liveKit,
    required SocketService socket,
  })  : _facade = facade,
        _liveKit = liveKit,
        _socket = socket,
        super(BroadcastState(broadcast: broadcast)) {
    _socketStateSub = _socket.stateStream.listen((socketState) {
      socketState.whenOrNull(
        broadcastStarted: (_, error) => _updateFailure(error),
      );
    });
  }
  final IBroadcastFacade _facade;
  final LiveKitService _liveKit;
  final SocketService _socket;

  late final StreamSubscription<SocketState> _socketStateSub;

  Future<void> startBroadcast() async {
    final broadcastId = state.broadcast.id;
    emit(state.copyWith(status: LiveStatus.loading, failure: null));
    final fOrS = await _facade.startBroadcast(broadcastId);
    await fOrS.fold(
      (failure) async => emit(
        state.copyWith(
          failure: failure,
          status: LiveStatus.failure,
        ),
      ),
      (broadcast) async {
        final startEvent = SocketEvent.startedBroadcast(broadcastId.getOr());
        _socket.emit(startEvent);
        if (state.failure == null) {
          try {
            final token = broadcast.broadcastToken!;
            await _liveKit.broadcast(token).whenComplete(() async {
              emit(
                state.copyWith(
                  status: LiveStatus.started,
                  broadcast: broadcast,
                ),
              );
            });
          } catch (e) {
            emit(
              state.copyWith(
                status: LiveStatus.failure,
                failure: BroadcastException.message(e.toString()),
              ),
            );
          }
        } else {
          emit(
            state.copyWith(
              status: LiveStatus.failure,
              failure: state.failure,
            ),
          );
        }
      },
    );
  }

  Future<void> mute({bool value = false}) async {
    if (state.status == LiveStatus.started) {
      unawaited(_liveKit.mute(enabled: value));
      emit(state.copyWith(muted: value));
    }
  }

  Future<void> endBroadcast() async {
    if (state.status == LiveStatus.started) {
      emit(state.copyWith(status: LiveStatus.loading, failure: null));
      _socket.emit(SocketEvent.endBroadcast(state.broadcast.id.getOr()));
      await _liveKit.dispose();
      emit(state.copyWith(status: LiveStatus.ended));
    }
  }

  Future<void> deleteBroadcast(Uid<Broadcast> id) async {
    if (state.status != LiveStatus.started) {
      emit(state.copyWith(status: LiveStatus.loading, failure: null));
      final fOrS = await _facade.deleteBroadcast(id);
      emit(
        fOrS.fold(
          (failure) => state.copyWith(
            status: LiveStatus.failure,
            failure: failure,
          ),
          (success) => state.copyWith(
            status: LiveStatus.deleted,
          ),
        ),
      );
    }
  }

  Future<void> dispose() async => _liveKit.dispose();

  void _updateFailure(String? error) {
    if (error != null) {
      final failure = BroadcastException.message(error);
      emit(state.copyWith(failure: failure, status: LiveStatus.failure));
    }
  }

  @override
  Future<void> close() async {
    await _liveKit.dispose();
    await _socketStateSub.cancel();
    return super.close();
  }
}
