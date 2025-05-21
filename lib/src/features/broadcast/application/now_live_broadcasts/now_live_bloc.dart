import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/socket/socket_service.dart';
import 'package:meno_fe_v1/src/shared/constants/constants.dart' show OrderBy;
import 'package:meno_fe_v1/src/shared/session/session.dart';

part 'now_live_event.dart';
part 'now_live_state.dart';

class NowLiveBloc extends Bloc<NowLiveEvent, NowLiveState> {
  NowLiveBloc({
    required IBroadcastFacade facade,
    required SocketService socket,
    required ISessionContext session,
  })  : _facade = facade,
        _socket = socket,
        _session = session,
        super(const NowLiveInitial()) {
    on<NowLiveStarted>(_onNowLiveStarted);
    on<NowLiveFetchMoreRequested>(_onNowLiveFetchMoreRequested);
    on<_NewBroadcastSubscribed>(_onNewBroadcastSubscribed);
    on<_EndedBroadcastSubscribed>(_onEndedBroadcastSubscribed);

    _socket.addListener(
      'newBroadcast',
      (data) => add(_NewBroadcastSubscribed(data)),
    );

    _socket.addListener(
      'endedBroadcast',
      (data) => add(_EndedBroadcastSubscribed(data)),
    );

    _subscription = _session.userChanges.listen((credential) {
      if (credential != null && (credential.token?.isValid ?? false)) {
        add(const NowLiveStarted());
      }
    });
  }

  final IBroadcastFacade _facade;
  final SocketService _socket;
  final ISessionContext _session;

  StreamSubscription<UserCredential?>? _subscription;

  Future<void> _onNowLiveStarted(
    NowLiveStarted event,
    Emitter<NowLiveState> emit,
  ) async {
    emit(const NowLiveLoadInProgress());

    final response = await _facade.getBroadcasts(
      sortBy: 'startTime',
      orderBy: OrderBy.ASC.name,
      endTimeExist: false,
      startTimeExist: true,
      include: 'totalListeners',
      status: 'active',
      size: 10,
      page: 1,
    );

    emit(
      response.fold(
        NowLiveLoadFailure.new,
        (success) => NowLiveLoadSuccess(
          broadcasts: success.broadcasts,
          currentPage: success.currentPage,
          hasMore: success.currentPage < success.totalPages,
        ),
      ),
    );
  }

  Future<void> _onNowLiveFetchMoreRequested(
    NowLiveFetchMoreRequested event,
    Emitter<NowLiveState> emit,
  ) async {
    if (state is NowLiveLoadSuccess) {
      final loadedState = state as NowLiveLoadSuccess;

      emit(NowLiveLoadMoreInProgress(loadedState.broadcasts));

      final response = await _facade.getBroadcasts(
        sortBy: 'startTime',
        orderBy: OrderBy.ASC.name,
        endTimeExist: false,
        startTimeExist: true,
        include: 'totalListeners',
        status: 'active',
        size: 10,
        page: loadedState.currentPage + 1,
      );

      emit(
        response.fold(
          NowLiveLoadFailure.new,
          (success) => NowLiveLoadSuccess(
            broadcasts: success.broadcasts,
            currentPage: success.currentPage,
            hasMore: success.currentPage < success.totalPages,
          ),
        ),
      );
    }
  }

  void _onNewBroadcastSubscribed(
    _NewBroadcastSubscribed event,
    Emitter<NowLiveState> emit,
  ) {
    if (state is NowLiveLoadSuccess) {
      final eventData = event.data as Map<String, dynamic>;
      final newBroadcast = BroadcastDto.fromJson(eventData).toDomain;

      final currentState = state as NowLiveLoadSuccess;
      final currentBroadcasts = List<Broadcast?>.from(currentState.broadcasts);
      final updatedBroadcasts = [newBroadcast, ...currentBroadcasts];
      emit(
        NowLiveLoadSuccess(
          broadcasts: updatedBroadcasts,
          currentPage: currentState.currentPage,
          hasMore: currentState.hasMore,
        ),
      );
    }
  }

  void _onEndedBroadcastSubscribed(
    _EndedBroadcastSubscribed event,
    Emitter<NowLiveState> emit,
  ) {
    if (state is NowLiveLoadSuccess) {
      final eventData = event.data as Map<String, dynamic>;
      final endedDetails = EndedBroadcastDataDto.fromJson(eventData).toDomain;
      final endedBroadcast = endedDetails.broadcastDetails;

      final currentState = state as NowLiveLoadSuccess;
      final currentBroadcasts = List<Broadcast?>.from(currentState.broadcasts);
      final updatedBroadcasts = currentBroadcasts
          .where((broadcast) => broadcast?.id != endedBroadcast.id)
          .toList();
      emit(
        NowLiveLoadSuccess(
          broadcasts: updatedBroadcasts,
          currentPage: currentState.currentPage,
          hasMore: currentState.hasMore,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _socket.removeListener('newBroadcast');
    _socket.removeListener('endedBroadcast');
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}
