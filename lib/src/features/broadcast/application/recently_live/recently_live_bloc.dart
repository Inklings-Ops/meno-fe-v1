import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/session/session.dart';

part 'recently_live_event.dart';
part 'recently_live_state.dart';

class RecentlyLiveBloc extends Bloc<RecentlyLiveEvent, RecentlyLiveState> {
  RecentlyLiveBloc({
    required IBroadcastFacade facade,
    required SocketService socket,
    required ISessionContext session,
  })  : _facade = facade,
        _socket = socket,
        _session = session,
        super(const RecentlyLiveInitial()) {
    on<RecentlyLiveStarted>(_onRecentlyLiveStarted);
    on<RecentlyLiveFetchMoreRequested>(_onRecentlyLiveFetchMoreRequested);
    on<_EndedBroadcastSubscribed>(_onEndedBroadcastSubscribed);

    _subscription = _session.userChanges.listen((credential) {
      if (credential != null && (credential.token?.isValid ?? false)) {
        add(const RecentlyLiveStarted());
      }
    });
  }

  final IBroadcastFacade _facade;
  final SocketService _socket;
  final ISessionContext _session;

  StreamSubscription<UserCredential?>? _subscription;

  Future<void> _onRecentlyLiveStarted(
    RecentlyLiveStarted event,
    Emitter<RecentlyLiveState> emit,
  ) async {
    emit(const RecentlyLiveLoadInProgress());

    final response = await _facade.getBroadcasts(
      size: 10,
      orderBy: 'DESC',
      sortBy: 'endTime',
      endTimeExist: true,
      include: 'totalListeners',
      page: 1,
    );

    emit(
      response.fold(
        RecentlyLiveLoadFailure.new,
        (success) => RecentlyLiveLoadSuccess(
          broadcasts: success.broadcasts,
          currentPage: success.currentPage,
          hasMore: success.currentPage < success.totalPages,
        ),
      ),
    );
  }

  Future<void> _onRecentlyLiveFetchMoreRequested(
    RecentlyLiveFetchMoreRequested event,
    Emitter<RecentlyLiveState> emit,
  ) async {
    if (state is RecentlyLiveLoadSuccess) {
      final loadedState = state as RecentlyLiveLoadSuccess;

      emit(RecentlyLiveLoadMoreInProgress(loadedState.broadcasts));

      final response = await _facade.getBroadcasts(
        size: 10,
        orderBy: 'DESC',
        sortBy: 'endTime',
        endTimeExist: true,
        include: 'totalListeners',
        page: loadedState.currentPage + 1,
      );

      emit(
        response.fold(
          RecentlyLiveLoadFailure.new,
          (success) => RecentlyLiveLoadSuccess(
            broadcasts: success.broadcasts,
            currentPage: success.currentPage,
            hasMore: success.currentPage < success.totalPages,
          ),
        ),
      );
    }
  }

  void _onEndedBroadcastSubscribed(
    _EndedBroadcastSubscribed event,
    Emitter<RecentlyLiveState> emit,
  ) {
    if (state is RecentlyLiveLoadSuccess) {
      final eventData = event.data as Map<String, dynamic>;
      final endedDetails = EndedBroadcastDataDto.fromJson(eventData).toDomain;
      final endedBroadcast = endedDetails.broadcastDetails;

      final currentState = state as RecentlyLiveLoadSuccess;
      final currentBroadcasts = List<Broadcast?>.from(currentState.broadcasts);
      final updatedBroadcasts = [endedBroadcast, ...currentBroadcasts];
      emit(
        RecentlyLiveLoadSuccess(
          broadcasts: updatedBroadcasts,
          currentPage: currentState.currentPage,
          hasMore: currentState.hasMore,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _socket.removeListener('endedBroadcast');
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}
