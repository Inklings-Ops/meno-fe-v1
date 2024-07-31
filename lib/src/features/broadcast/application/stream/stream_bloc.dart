import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'stream_bloc.freezed.dart';
part 'stream_event.dart';
part 'stream_state.dart';

@Injectable()
class StreamBloc extends Bloc<StreamEvent, StreamState> {
  StreamBloc({
    required IBroadcastFacade facade,
    required LiveKitService liveKit,
    required SocketService socket,
  })  : _facade = facade,
        _liveKit = liveKit,
        _socket = socket,
        super(const StreamLoadInProgress()) {
    on<StreamJoinRequested>(_onJoinBroadcast);
    on<StreamLeaveRequested>(_onLeaveBroadcast);
  }
  final IBroadcastFacade _facade;
  final LiveKitService _liveKit;
  final SocketService _socket;

  Future<void> _onJoinBroadcast(
    StreamJoinRequested event,
    Emitter<StreamState> emit,
  ) async {
    final fOrS = await _facade.joinBroadcast(event.id);
    await fOrS.fold(
      (failure) async => emit(StreamFailure(failure)),
      (jB) async {
        final broadcast = jB.broadcast;
        await _liveKit.stream(jB.broadcastToken).whenComplete(() async {
          _socket.emit(SocketEvent.joinBroadcast(broadcast.id.getOr()));
          emit(StreamJoinSuccess(broadcast));
        });
      },
    );
  }

  Future<void> _onLeaveBroadcast(
    StreamLeaveRequested event,
    Emitter<StreamState> emit,
  ) async {
    if (state is StreamJoinSuccess) {
      emit(const StreamLoadInProgress());
      await _liveKit
          .disconnect()
          .then((_) => _liveKit.dispose())
          .whenComplete(() async {
        _socket.emit(SocketEvent.leaveBroadcast(event.id.getOr()));
        emit(const StreamLeaveSuccess());
      });
    }
  }

  @override
  Future<void> close() async {
    await _liveKit.dispose();
    await super.close();
  }

  Future<void> dispose() => _liveKit.dispose();
}
